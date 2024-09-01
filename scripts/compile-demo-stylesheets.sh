#!/usr/bin/env bash
dir="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
project_dir=$(readlink -f "$dir/..")
components_dir=$project_dir/src/components
demo_dir=$project_dir/demo
document_template_file=$project_dir/var/stylesheets/_document-template.scss
compile_sass() {
    local filename=$1
    basename=$(basename "$filename")
    normalize_filename=$filename/normalize.scss
    if test -f $normalize_filename; then
        sass $normalize_filename $demo_dir/$basename/normalize.css
    fi
    base_filename=$filename/base.scss
    if test -f $base_filename; then
        sass $base_filename $demo_dir/$basename/base.css
        cp $document_template_file $filename/document.scss
        sass $filename/document.scss $demo_dir/$basename/document.css
        rm $filename/document.scss
    fi
    demo_styles_file=$demo_dir/$basename/styles.scss
    if test -f $demo_styles_file; then
        sass $demo_styles_file $demo_dir/$basename/styles.css
    fi
    # compile module styles
    if test -d $demo_dir/$basename/modules; then
        for module_dir in $demo_dir/$basename/modules/*; do
            if [ -d "$module_dir" ]; then
                if test -f $module_dir/styles.scss; then
                    sass $module_dir/styles.scss $module_dir/styles.css
                fi
            fi
        done
    fi
}
for filename in $components_dir/*; do
    compile_sass $filename
done
# custom components
custom_components_dir=$project_dir/var/components
if test -d $custom_components_dir; then
    for component_dir in $custom_components_dir/*; do
        if [ -d $component_dir ]; then
            component_name=$(basename "$component_dir")
            if [[ ! "$component_name" =~ ^_ ]]; then
                # custom component contains demo files
                if [ -d "$component_dir/demo" ]; then
                    rsync -a -q --progress $component_dir/demo/ $demo_dir/$component_name/
                fi
                copied=0
                if [ ! -d "$components_dir/$component_name" ]; then
                    cp -R $component_dir $components_dir
                    copied=1
                fi
                compile_sass $components_dir/$component_name
                if [ $copied -eq 1 ]; then
                    rm -rf $components_dir/$component_name
                fi
            fi
        fi
    done
fi