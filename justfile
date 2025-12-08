build :
    docker build --progress=plain --build-arg MISE_GITHUB_TOKEN=${MISE_GITHUB_TOKEN} -t devcontainer_tmp . 2>&1 | tee build.log

build-nocache:
  docker build --no-cache --build-arg MISE_GITHUB_TOKEN=${MISE_GITHUB_TOKEN} -t devcontainer_tmp .
