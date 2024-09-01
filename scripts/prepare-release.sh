#!/bin/bash
version=""
while getopts "v:" arg; do
    case $arg in
        v)
            version=$OPTARG
            ;;
        *)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done
# Checks if value of $version is empty
if [[ -z $version ]]; then
    echo "Error: -v option is mandatory" >&2
    exit 1
fi

dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
project_dir=$(readlink -f "$dir/..")

$project_dir/scripts/cleanup-demo-files.sh
$project_dir/scripts/compile-demo-stylesheets.sh
$project_dir/scripts/empty-dist-stylesheets.sh
node $project_dir/scripts/compile-stylesheets.js sourceMap=0
cp $project_dir/dist/example.css $project_dir/docs/examples/example.css
cp $project_dir/dist/example.min.css $project_dir/docs/examples/example.min.css