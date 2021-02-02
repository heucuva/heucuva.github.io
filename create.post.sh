#!/bin/bash
# Create a new jekyll post with the current date and the given title
# and print the path to the post file.
#
# author: andreasl
#
# modifications to make this work with mkdocs by: heucuva

post_title="$*"
[ -z "$post_title" ] && printf 'Error: Script needs a post title.\n' && exit 1

repo_dir="$(git rev-parse --show-toplevel 2>/dev/null)"
if [ -z "${repo_dir}" ]; then
    repo_dir="."
fi
post_year="$(date '+%Y')"
post_month="$(date '+%m')"
post_day="$(date '+%d')"
post_date="$(date '+%Y-%m-%d %H:%M:%S %z')"
blog_folder=$(python -c 'import yaml; a_yaml_file = open("mkdocs.yml"); parsed_yaml_file = yaml.load(a_yaml_file, Loader=yaml.FullLoader); print(parsed_yaml_file["plugins"][0]["blog"]["folder"])' 2>/dev/null)
if [ -z "${blog_folder}" ]; then
    blog_folder="blog"
fi
title_slug="$(printf -- "$post_title" | sed -E 's/[^a-zA-Z0-9]+/-/g' | tr "[:upper:]" "[:lower:]")"
post_dir="${repo_dir}/docs/${blog_folder}/${post_year}/${post_month}/${post_day}"
mkdir -p "${post_dir}"
post_path="${post_dir}/${title_slug}.md"
[ -e "$post_path" ] && printf 'Error: Post exists already.\n' && exit 2

IFS= read -r -d '' front_matter << EOF
---
layout: post
title:  "${*}"
date:   ${post_date}
categories: category
---
EOF

printf -- "${front_matter}" > "${post_path}"

printf -- '%s\n' "${post_path}"
