#!/bin/bash

# Automatically run Ruby scripts with "bundle exec" (but only when appropriate).
# FORK by coreymartella limited to only core executables (rails,rack,rake,passenger,unicorn)
# http://effectif.com/ruby/automating-bundle-exec
# Github: https://github.com/coreymartella/bundler-exec

## Functions

bundler-installed()
{
    which bundle > /dev/null 2>&1
}

within-bundled-project()
{
    local dir="$(pwd)"
    while [ "$(dirname $dir)" != "/" ]; do
        [ -f "$dir/Gemfile" ] && return
        dir="$(dirname $dir)"
    done
    false
}

run-with-bundler()
{
    if bundler-installed && within-bundled-project; then
        bundle exec "$@"
    else
        "$@"
    fi
}

## Main program

BUNDLED_COMMANDS="${BUNDLED_COMMANDS:-
passenger
rake
rails
unicorn
unicorn_rails
}"

for CMD in $BUNDLED_COMMANDS; do
    if [[ $CMD != "bundle" && $CMD != "gem" ]]; then
        alias $CMD="run-with-bundler $CMD"
    fi
done
