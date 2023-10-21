#!/bin/bash
# BUILD DATETIME: %{DATETIME}%
set -eu

printf "\n\x1b[1;37mhttp://localhost:8080/animated.gif\x1b[0m\n\n"

/closure/ld-linux-x86-64.so.2 --library-path /closure /closure/darkhttpd /
