#!/bin/bash
set -x

eval "$(ssh-agent -s)"
chmod 600 scripts/updater.key
ssh-add scripts/updater.key

export PROJECT_NAME=`echo $TRAVIS_REPO_SLUG | sed 's,/,-,g'`
export REBAR_COLOR=none
export TERM=dumb

# Get the history (clone)
scripts/history_clone.sh

# Compile
if scripts/run_compile.sh; then

  # Run Dialyzer and collect history line with dialyzer warnings
  scripts/run_dialyzer.sh
  dialyzer_return_value=$?

  rebar3 as test tree
  scripts/run_eunit.sh
  eunit_return_value=$?

  scripts/run_common_test.sh
  common_test_return_value=$?
  
  scripts/run_coverage.sh

  return_value=$((dialyzer_return_value+eunit_return_value+common_test_return_value))
else
  return_value=1
fi

# Finished: Push the history
scripts/history_commit_push.sh

exit $return_value

