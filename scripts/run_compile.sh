#!/bin/bash

#
#

CI_PROJECT_NAME=test_dashboard

output_name="dashboard/compile-output-${CI_PROJECT_NAME}.txt"
set -o pipefail
rebar3 compile | tee $output_name
if [ $? -ne 0 ]; then
    echo "Build failed!"
    scripts/history_update_dashboard.sh build failed
    scripts/history_update_dashboard.sh dialyzer failed
    scripts/history_update_dashboard.sh eunit failed
    scripts/history_update_dashboard.sh common_test failed
    exit 1
fi
set +o pipefail

warnings_number=`grep ':[0-9]*: Warning' $output_name | wc -l`
scripts/history_update_dashboard.sh build success "$warnings_number"
exit 0

