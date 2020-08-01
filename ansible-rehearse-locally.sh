#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-

function rehearse () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFFILE="$(readlink -m -- "$BASH_SOURCE")"

  local ARG="$1"
  case "$ARG" in
    -s )
      shift
      "$SELFFILE" "$@" | colorize-ansible-log | smart-less-pmb
      ARG="${PIPESTATUS[*]}"; let ARG="${ARG// /+}"
      return "$ARG";;
  esac

  local -A CFG=()
  while [ "$#" -ge 1 ]; do
    case "$1" in
      -- ) shift; break;;
      -s ) echo "E: option $1 must be the first argument." >&2; return 2;;
      -* ) echo "E: unsupported CLI argument '$1'" >&2; return 3;;
      * ) break;;
    esac
  done

  local ANS_HOST='localhost'
  local ANS_CMD=(
    ansible-playbook
    --connection=local
    --inventory "$ANS_HOST,"  # "," means list of hostnames
    --limit "$ANS_HOST"
    )
  "${ANS_CMD[@]}" -- "$@"
  local ANS_RV="$?"
  wait
  return "$ANS_RV"
}

rehearse "$@"; exit $?
