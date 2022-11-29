#!/bin/bash

exec shellcheck -s bash -x \
  bin/* -P lib/
