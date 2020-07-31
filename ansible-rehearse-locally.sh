#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-

function rehearse () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local -A CFG=()
  local ARG=

  while [ "$#" -ge 1 ]; do
    case "$1" in
      -- ) shift; break;;
      -s )
        CFG[smartless]='smart-less-pmb --exec'
        shift;;
      -* ) echo "E: unsupported CLI argument '$1'" >&2; return 3;;
      * ) break;;
    esac
  done

  local ANS_HOST='localhost'
  local ANS_CMD=(
    ${CFG[smartless]}
    ansible-playbook
    --connection=local
    --inventory "$ANS_HOST,"  # "," means list of hostnames
    --limit "$ANS_HOST"
    )
  exec "${ANS_CMD[@]}" -- "$@" || return $?
}

rehearse "$@"; exit $?
