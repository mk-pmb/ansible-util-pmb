#!/bin/sed -nurf
# -*- coding: UTF-8, tab-width: 2 -*-

: regular_read
  /\S/!b regular_next
  /^\}$/b regular_next
  /^[A-Z]{2,8} /s~\s*\*+$~~
  /^TASK /{
    N;s~\n\s*(\S+)\s+~\t\1\t~
    / => \{$/{N;s~\n\s*~ ~}
  }

  $b gosub_summarize
  /^PLAY RECAP$/{
    s~^PLAY ~~
    $!{N;s~\n(\S+)\s*~: \1~}
    s~\s+[a-z]+=0\b~~g
    b gosub_summarize
  }
  : comefrom_summarize

  s~\b(fail|fatal)(ed|)([:=])~\x1B[97;41m\1\3\x1B[0m~g
  s~\b(ok)[:=]|\b"changed": false\b~\x1B[97;42m&\x1B[0m~g
  s~\b(change)(d|)([:=])~\x1B[97;43m\1\3\x1B[0m~g
  s~\b(skip)(ping|ped|)([:=])~\x1B[94m\1\3\x1B[0m~g
  s~(=)(\x1B\[0m)~\2\1~g

  p
: regular_next
  n
b regular_read



: gosub_summarize
  /\sfailed=[1-9]/{/\f/!s~$~\n\
      \f31:█▀▀▀  ▄▀▄   █  █     █ \
      \f31:█    █   █  █  █     █ \
      \f31:█▀▀  █▀▀▀█  █  █     █ \
      \f31:█    █   █  █  █▄▄▄  ▄ \n~
  }
  /\sok=[1-9]/{/\f/!s~$~\n\
      \f32: ▄▀▀▄   █   █  █ \
      \f32:█    █  █ ▄▀   █ \
      \f32:█    █  █▀▄    █ \
      \f32: ▀▄▄▀   █  ▀▄  ▄ \n~
  }
  s~ +\n~\n~g
  s~(\n +)\f([0-9]+) *:?([^\n]*)~\1\x1B[\2m\3\x1B[0m~g
b comefrom_summarize





: end
