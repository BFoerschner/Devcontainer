build :
    docker buildx inspect verbose >/dev/null 2>&1 || docker buildx create --name verbose --driver docker-container --driver-opt env.BUILDKIT_STEP_LOG_MAX_SPEED=10485760 --driver-opt env.BUILDKIT_STEP_LOG_MAX_SIZE=104857600
    docker buildx use verbose
    docker buildx inspect --bootstrap
    docker buildx build --progress=plain -t devcontainer_tmp . 2>&1 | tee build.log

build-nocache:
  docker build --no-cache --build-arg -t devcontainer_tmp .

run:
  docker run -v $HOME/.ssh/:/root/.ssh -v /var/run/docker.sock:/var/run/docker.sock -e DISPLAY="host.docker.internal:0" --network=host --name devcontainer --entrypoint tmux -i -t devcontainer_tmp -u new-session -A -s main /bin/bash

run-tmp:
  docker run -v $HOME/.ssh/:/root/.ssh -v /var/run/docker.sock:/var/run/docker.sock -e DISPLAY="host.docker.internal:0" --network=host --rm --name devcontainer --entrypoint tmux -i -t devcontainer_tmp -u new-session -A -s main /bin/bash

attach:
  container=$(docker ps | sed 1d | awk '{print $NF}' | fzf --prompt='Select container > ' --height=40% --reverse) && [ -n "$container" ] && docker exec -i -t "$container" tmux -u new-session -A -s main /bin/bash
