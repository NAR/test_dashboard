#!/bin/bash


CI_PROJECT_NAME=test_dashboard
output_name="dashboard/cover-output-${CI_PROJECT_NAME}.txt"
rebar3 cover --verbose | tee ${output_name}

actual_coverage=`perl -ne 'print $1 if (/\|\s+total\s+\|\s+(\d+)/);' $output_name`
if [ -z "$actual_coverage" ]; then
  actual_coverage=0
fi
echo "actual coverage: $actual_coverage"

scripts/history_update_dashboard.sh coverage $actual_coverage

exit 0
