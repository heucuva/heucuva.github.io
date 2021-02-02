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
blog_path="${blog_folder}/${post_year}/${post_month}/${post_day}"
post_dir="${repo_dir}/docs/${blog_path}"
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

IFS= read -r -d '' front_matter << EOF
---
title: "Home"
layout: main
---
!!! About

    This is a development blog for my personal projects and any work that I might do outside of my normal employer-sanctioned activities.

    I talk about pretty much anything that catches my attention while I'm working on a project and it might seem like I'm bouncing around aimlessly at times.

    My opinions are my own and do not reflect those that might be held by my employer - past or present - such as Activision Blizzard, Sony, Apple, or any others not explicitly named.

!!! Blog

    Latest Blog Entry: [${*} (${post_month}/${post_day}/${post_year})](${blog_path}/${title_slug}.md)
EOF

printf -- "${front_matter}" > "${repo_dir}/docs/index.md"
