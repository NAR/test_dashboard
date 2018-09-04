#!/usr/bin/env bash

# Requires:
# Env value $CI_PROJECT_NAME: Repository name to analyze. Will search in
#       _checkouts/$1 or if not found, will go to _build/test/lib/$1
# Env value $CI_PROJECT_DIR
#

hist_scripts_dir=$PWD/scripts

CI_PROJECT_NAME=test_dashboard
output_name="dashboard/dialyzer-output-${CI_PROJECT_NAME}.txt"

export TERM=dumb
if rebar3 as test dialyzer | tee ${output_name} ; then
    # Error/warn is not the last line but one before last
    x_warn=`tail -n 5 ${output_name} | awk '/Warnings occurred/ {print $6}'`
    if [ -z "$x_warn" ]; then
      x_warn=0
    fi
    echo "Dialyzer finished. warnings: ${x_warn}"

    ${hist_scripts_dir}/history_update_dashboard.sh dialyzer ${x_warn}
    exit ${x_warn}
else
    ${hist_scripts_dir}/history_update_dashboard.sh dialyzer failed
    exit 1
fi
