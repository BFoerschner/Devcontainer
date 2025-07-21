# Build base development image with core toolchains
build-base:
    @echo "Building base development image..."
    docker build --no-cache --build-arg INIT_SCRIPT_PATH=init_scripts/init_base.sh -t devel_base .
    @echo "Base image 'devel_base' built successfully!"

# Test base image commands with zsh configuration
test-base:
    @echo "Testing base image commands..."
    cd ccheck && cargo build --release && ./target/release/ccheck devel_base -s zsh -f ../test/base-commands.txt
