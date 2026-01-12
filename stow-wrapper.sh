#!/usr/bin/env bash

# Forward arguments to GNU stow and strip any spurious warning
# (https://github.com/aspiers/stow/issues/65)
stow "$@" \
	2> >(grep -v 'BUG in find_stowed_path? Absolute/relative mismatch' 1>&2)
