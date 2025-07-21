build-base:
    @echo "Building base development image from Ubuntu rolling..."
    docker build --no-cache --build-arg BASE_IMAGE=ubuntu:rolling --build-arg INIT_SCRIPT_PATH=init_scripts/init_base.sh -t devel_base .
    @echo "Base image 'devel_base_ubuntu' built successfully!"

# Test base image commands with zsh configuration
test-base:
    @echo "Testing base image commands..."
    cd ccheck && cargo build --release && ./target/release/ccheck devel_base -s zsh -f ../test/base-commands.txt

build-full:
    @echo "Building full development image..."
    docker build --no-cache --build-arg BASE_IMAGE=devel_base:latest --build-arg INIT_SCRIPT_PATH=init_scripts/init_full.sh -t devel_full .
    @echo "Full image 'devel_full' built successfully!"
