build-base:
    @echo "Building base development image from Ubuntu rolling..."
    docker build \
      --build-arg INIT_SCRIPT_PATH=init_scripts/init_base.sh \
      -t devcontainer_base .
    just test base
    @echo "Base image 'devcontainer_base' built successfully!"

build CONTAINER: build-base
    @echo "Building full development image..."
    docker build \
      --build-arg BASE_IMAGE=devcontainer_base:latest \
      --build-arg INIT_SCRIPT_PATH=init_scripts/init_{{CONTAINER}}.sh \
      -t devcontainer_{{CONTAINER}} .
    just test {{CONTAINER}}
    @echo "Full image 'devcontainer_{{CONTAINER}}' built successfully!"

# Test base image commands with zsh configuration
test CONTAINER:
    @echo "Testing {{CONTAINER}} image commands..."
    cargo install --git https://github.com/bfoerschner/ccheck.git
    ccheck devcontainer_{{CONTAINER}} \
      -s zsh \
      -f test/commands_{{CONTAINER}}.txt
