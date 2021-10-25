#!/bin/sh
set -e

env | cut -f1 -d= | grep ECS_FILES |
while IFS= read -r value; do
  contents=$(printenv $value | jq -r .contents | base64 -d)
  file=$(printenv $value | jq -r .file)
  echo "Processing environment variable $value... writing file $file"
  echo $contents > $file
done

# based on docker official images example
# https://github.com/docker-library/official-images

# else default to run whatever the user wanted like "bash" or "sh"
exec "$@"
