#!/usr/bin/env bash

#
# Clone history repository for modification
#
# Assumption: Private key `history.rsa` has been `ssh-add`-ed before running
# this script (can do this in `.gitlab-ci.yml`)
#

#cd ${CI_PROJECT_DIR}
set -x
env
lsb_release -a
rm -fr dashboard
git clone git@github.com:NAR/dashboard.git

