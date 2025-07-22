build-base:
    @echo "Building base development image from Ubuntu rolling..."
    docker build \
      --no-cache \
      --build-arg BASE_IMAGE=ubuntu:rolling \
      --build-arg INIT_SCRIPT_PATH=init_scripts/init_base.sh \
      -t devel_base .
    just test base
    @echo "Base image 'devel_base' built successfully!"

build CONTAINER: build-base
    @echo "Building full development image..."
    docker build \
      --no-cache \
      --build-arg BASE_IMAGE=devel_base:latest \
      --build-arg INIT_SCRIPT_PATH=init_scripts/init_{{CONTAINER}}.sh \
      -t devel_{{CONTAINER}} .
    just test {{CONTAINER}}
    @echo "Full image 'devel_{{CONTAINER}}' built successfully!"

# Test base image commands with zsh configuration
test CONTAINER:
    @echo "Testing {{CONTAINER}} image commands..."
    cd ccheck \
      && cargo build --release \
      && ./target/release/ccheck devel_{{CONTAINER}} \
      -s zsh \
      -f ../test/commands_{{CONTAINER}}.txt
