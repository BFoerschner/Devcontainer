use anyhow::Result;
use clap::Parser;
use colored::*;
use std::{fs, process::Command};

#[derive(Parser)]
#[command(about = "Check if commands are installed inside a Docker Image")]
struct Args {
    image: String,
    commands: Vec<String>,
    #[arg(short, long)]
    file: Option<String>,
    #[arg(short, long, default_value = "zsh")]
    shell: String,
}

fn build_docker_cmd(image: &str, shell: &str) -> Command {
    let mut docker_cmd = Command::new("docker");
    docker_cmd.args(["run", "--rm", "--entrypoint=", image, shell]);

    match shell {
        "zsh" => {
            docker_cmd.arg("-i"); // Because we want it to load .zshrc
        }
        "nu" | "nushell" => {} // No special flags needed for nushell
        _ => {}
    }

    docker_cmd
}

fn get_installed_and_missing_commands_new(
    script: String,
    docker_cmd: &mut Command,
) -> Result<(Vec<String>, Vec<String>)> {
    let mut installed = Vec::new();
    let mut missing = Vec::new();

    let output = docker_cmd.args(["-c", &script]).output().unwrap();

    for line in String::from_utf8_lossy(&output.stdout).lines() {
        let line = line.trim();
        if line.contains("not installed") {
            missing.push(line.to_string());
        } else if line.contains("installed") {
            installed.push(line.to_string());
        } else if !line.is_empty() {
            eprintln!("{line}");
        }
    }
    Ok((installed, missing))
}

fn create_summary(installed: Vec<String>, missing: Vec<String>) -> Result<()> {
    let summary = format!(
        "\nSummary: {}/{} commands installed",
        installed.len(),
        installed.len() + missing.len()
    )
    .yellow();

    if missing.is_empty() {
        println!("{}", "All commands are installed!".green());
        for cmd in installed {
            println!("{}", cmd.green());
        }
        println!("{summary}");
        Ok(())
    } else {
        println!("{}", "Some commands are missing:".red());
        for cmd in &missing {
            println!("{}", cmd.red());
        }
        println!("{summary}");
        anyhow::bail!("{} command(s) missing", missing.len());
    }
}

fn create_availability_check_script(shell: &str, cmd: &str) -> String {
    let nushell_template = r#"
if (try { which {cmd} } catch { null }) != null {
    print "{cmd} installed"
} else {
    print "{cmd} not installed"
}"#;

    let posix_template = r#"
if command -v "{cmd}" >/dev/null 2>&1; then
    echo "{cmd} installed"
else
    echo "{cmd} not installed"
fi"#;

    let script = match shell {
        "nu" | "nushell" => nushell_template,
        _ => posix_template,
    };

    script.replace("{cmd}", cmd)
}

fn main() -> Result<()> {
    let args = Args::parse();

    let commands = match args.file {
        Some(path) => fs::read_to_string(path)?
            .lines()
            .filter(|line| !line.trim().is_empty() && !line.starts_with('#'))
            .map(|l| l.trim().to_string())
            .collect(),
        None => args.commands,
    };

    if commands.is_empty() {
        anyhow::bail!("No commands specified");
    }

    println!("Checking Docker image: {}", args.image.to_string().yellow());
    println!(
        "Checking {} command(s):\n",
        commands.len().to_string().yellow()
    );

    let script = commands
        .iter()
        .map(|cmd| create_availability_check_script(args.shell.as_str(), cmd))
        .collect::<Vec<_>>()
        .join("; ");

    let mut docker_cmd = build_docker_cmd(&args.image, &args.shell);
    // let (installed, missing) = get_installed_and_missing_commands(script, &mut docker_cmd)?;
    let (installed, missing) = get_installed_and_missing_commands_new(script, &mut docker_cmd)?;
    create_summary(installed, missing)
}
