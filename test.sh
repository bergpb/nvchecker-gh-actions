#!/bin/bash

touch result.tmp

docker build . -t bergpb/nvchecker:test -f Dockerfile

docker run -dit \
    --name nvchecker-github-actions \
    -e "GITHUB_TOKEN=${GITHUB_TOKEN}" \
    -e "GOTIFY_SERVER=${GOTIFY_SERVER}" \
    -e "GOTIFY_TOKEN=${GOTIFY_TOKEN}" \
    bergpb/nvchecker:test > /dev/null

docker cp . nvchecker-github-actions:/

docker exec -it \
    nvchecker-github-actions \
    /bin/sh -c "sed -i -e 's/__GITHUB_ACCESS_TOKEN__/$GITHUB_TOKEN/g' keyfile.toml && \
    nvchecker --file config.toml --keyfile keyfile.toml && \
    nvcmp --file config.toml > result.tmp && \
    nvtake --file config.toml --all
    TITLE='nvchecker Updates' \
    PRIORITY='5' \
    URL='$GOTIY_SERVER/message?token=$GOTIFY_TOKEN' \
    RESULT=$(cat result.tmp) \
    DATE=$(date +'%Y-%m-%d') \
    && [[ ! -z $RESULT ]] \
    && curl $URL -F 'title=$TITLE' -F 'message=$RESULT' -F 'priority=$PRIORITY' \
    || echo 'No new versions'"

docker stop -t 0 nvchecker-github-actions > /dev/null && \
docker container rm nvchecker-github-actions > /dev/null && \
rm result.tmp