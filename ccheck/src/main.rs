use anyhow::Result;
use clap::Parser;
use colored::*;
use std::{fs, process::Command};

#[derive(Parser)]
#[command(about = "Check if commands are available in a Docker image")]
struct Args {
    /// Docker image to check
    image: String,
    /// Commands to check (if not using --file)
    commands: Vec<String>,
    /// File containing commands to check
    #[arg(short, long)]
    file: Option<String>,
    /// Shell to use
    #[arg(short, long, default_value = "sh")]
    shell: String,
}

fn main() -> Result<()> {
    let args = Args::parse();

    let commands = match args.file {
        Some(path) => fs::read_to_string(path)?
            .lines()
            .filter(|l| !l.trim().is_empty() && !l.starts_with('#'))
            .map(|l| l.trim().to_string())
            .collect(),
        None => args.commands,
    };

    if commands.is_empty() {
        anyhow::bail!("No commands specified");
    }

    println!(
        "{}",
        format!("Checking Docker image: {}", args.image).yellow()
    );
    println!(
        "{}",
        format!("Checking {} command(s):", commands.len()).yellow()
    );
    println!();

    let script = match args.shell.as_str() {
        "nu" | "nushell" => commands
            .iter()
            .map(|cmd| format!(r#"if (try {{ which {} }} catch {{ null }}) != null {{ print "✓ {}" }} else {{ print "✗ {}" }}"#, cmd, cmd, cmd))
            .collect::<Vec<_>>()
            .join("; "),
        _ => commands
            .iter()
            .map(|cmd| format!(r#"if command -v "{}" >/dev/null 2>&1; then echo "✓ {}"; else echo "✗ {}"; fi"#, cmd, cmd, cmd))
            .collect::<Vec<_>>()
            .join("; "),
    };

    let mut docker_cmd = Command::new("docker");
    docker_cmd.args(["run", "--rm", "--entrypoint=", &args.image, &args.shell]);

    match args.shell.as_str() {
        "zsh" => {
            docker_cmd.arg("-i");
        }
        "nu" | "nushell" => {} // No special flags needed for nushell
        _ => {}
    }

    let output = docker_cmd.args(["-c", &script]).output()?;

    let (mut available, mut missing) = (0, 0);

    for line in String::from_utf8_lossy(&output.stdout).lines() {
        let line = line.trim();
        if line.starts_with("✓") {
            println!("{}", line.green());
            available += 1;
        } else if line.starts_with("✗") {
            println!("{}", line.red());
            missing += 1;
        } else if !line.is_empty() {
            eprintln!("{}", line);
        }
    }

    println!();
    println!(
        "{}",
        format!(
            "Summary: {}/{} commands available",
            available,
            available + missing
        )
        .yellow()
    );

    if missing == 0 {
        println!("{}", "All commands are available!".green());
        Ok(())
    } else {
        anyhow::bail!("{} command(s) missing", missing)
    }
}
