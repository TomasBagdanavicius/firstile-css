#!/usr/bin/env bash
dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
project_dir=$(readlink -f "$dir/..")
target_dir=$project_dir/var/stylesheets
destination_dir=$project_dir/dist
for filename in $target_dir/*; do
    basename=$(basename "$filename")
    if [[ $basename != _* && $basename == *.scss ]]; then
        sass $filename $destination_dir/${basename%.*}.css
    fi
done