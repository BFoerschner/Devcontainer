build :
    docker build --progress=plain --build-arg MISE_GITHUB_TOKEN=${MISE_GITHUB_TOKEN} -t devcontainer_tmp . 2>&1 | tee build.log

build-nocache:
  docker build --no-cache --build-arg MISE_GITHUB_TOKEN=${MISE_GITHUB_TOKEN} -t devcontainer_tmp .

build-layered:
    docker buildx inspect verbose >/dev/null 2>&1 || docker buildx create --name verbose --driver docker-container --driver-opt env.BUILDKIT_STEP_LOG_MAX_SPEED=10485760 --driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=104857600
    docker buildx use verbose
    docker buildx inspect --bootstrap
    docker buildx build --progress=plain --load -f Dockerfile.layered --build-arg MISE_GITHUB_TOKEN=${MISE_GITHUB_TOKEN} -t devcontainer_tmp . 2>&1 | tee build.log
