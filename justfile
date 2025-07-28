build CONTAINER BASE_IMAGE="ubuntu:rolling":
    @echo "Building {{CONTAINER}} development image from Ubuntu rolling..."
    docker build \
      --build-arg BASE_IMAGE={{BASE_IMAGE}} \
      --build-arg INIT_SCRIPT_PATH=init_scripts/init_{{CONTAINER}}.sh \
      -t devcontainer_{{CONTAINER}} .
    just test {{CONTAINER}}
    @echo "Base image 'devcontainer_{{CONTAINER}}' built successfully!"

# Test image for available commands
test CONTAINER:
    @echo "Testing {{CONTAINER}} image commands..."
    cargo install --git https://github.com/bfoerschner/ccheck.git
    ccheck devcontainer_{{CONTAINER}} \
      -s zsh \
      -f test/commands_{{CONTAINER}}.txt
