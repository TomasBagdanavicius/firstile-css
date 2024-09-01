#!/usr/bin/env bash
dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
project_dir=$(readlink -f "$dir/..")
demo_dir=$project_dir/demo
components_dir=$project_dir/src/components
delete_generated_files_inside() {
    local dir=$1
    for file in $dir/*; do
        extension="${file##*.}"
        basename=$(basename "$file")
        if [ -f "$file" ] && [ $basename != "demo.css" ] && { [ "$extension" = "css" ] || [ "$extension" = "map" ]; }; then
            rm $file
        fi
    done
}
for filename in $demo_dir/*; do
    if [ -d "$filename" ]; then
        component_name=$(basename "$filename")
        # main counterpart exists
        if [ -d "$components_dir/$component_name" ]; then
            delete_generated_files_inside $filename
            # component contains modules
            if test -d $filename/modules; then
                for module_dir in $filename/modules/*; do
                    module_name=$(basename "$module_dir")
                    if test -d $project_dir/var/components/$component_name/modules/$module_name; then
                        rm -rf $module_dir
                    else
                        delete_generated_files_inside $module_dir
                    fi
                done
            fi
        else
            rm -rf $filename
        fi
    fi
done