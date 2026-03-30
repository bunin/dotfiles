#!/usr/bin/env bash

if ! command -v clockify-cli &>/dev/null; then
    echo '{"text": "", "tooltip": "", "class": "stopped"}'
    exit 0
fi

project=$(clockify-cli show -f'{{ .Project.Name }}' 2>/dev/null)
description=$(clockify-cli show -f'{{ .Description }}' 2>/dev/null)
duration=$(clockify-cli show -D 2>/dev/null)

if [[ -z "$project" && -z "$duration" ]]; then
    echo '{"text": "", "tooltip": "", "class": "stopped"}'
    exit 0
fi

text=" ${project}"
[[ -n "$duration" ]] && text+=" [$duration]"

tooltip="${project}"
[[ -n "$description" ]] && tooltip+=" / ${description}"
[[ -n "$duration" ]] && tooltip+=" [$duration]"

# Escape quotes for JSON
text="${text//\"/\\\"}"
tooltip="${tooltip//\"/\\\"}"

echo "{\"text\": \"${text}\", \"tooltip\": \"${tooltip}\", \"class\": \"running\"}"
