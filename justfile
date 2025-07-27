build CONTAINER:
    @echo "Building {{CONTAINER}} development image from Ubuntu rolling..."
    docker build \
      --build-arg INIT_SCRIPT_PATH=init_scripts/init_{{CONTAINER}}.sh \
      -t devcontainer_{{CONTAINER}} .
    just test base
    @echo "Base image 'devcontainer_{{CONTAINER}}' built successfully!"

build-staged CONTAINER BASE_IMAGE:
    @echo "Building {{CONTAINER}} development image from {{BASE_IMAGE}}..."
    docker build \
      --build-arg BASE_IMAGE={{BASE_IMAGE}} \
      --build-arg INIT_SCRIPT_PATH=init_scripts/init_{{CONTAINER}}.sh \
      -t devcontainer_{{CONTAINER}} .
    just test {{CONTAINER}}
    @echo "Staged image 'devcontainer_{{CONTAINER}}' built successfully!"

# Test image for available commands
test CONTAINER:
    @echo "Testing {{CONTAINER}} image commands..."
    cargo install --git https://github.com/bfoerschner/ccheck.git
    ccheck devcontainer_{{CONTAINER}} \
      -s zsh \
      -f test/commands_{{CONTAINER}}.txt

# Trigger Docker build workflow on GitHub
docker-build:
    @echo "Triggering Docker build workflow on GitHub..."
    gh workflow run docker-build.yml --ref $(git branch --show-current)
    @echo "Workflow triggered! Check status with: gh run list --workflow=docker-build.yml"
