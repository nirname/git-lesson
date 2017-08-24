#!/usr/bin/env bash

docker build -t lesson . && docker run -it lesson /bin/bash
