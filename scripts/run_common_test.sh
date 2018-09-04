#!/bin/bash

#
# Please do not run this file directly. Should be started from BUILD_AND_TEST.sh
# by Gitlab CI.
#

CI_PROJECT_NAME=test_dashboard

# Run CT
# Also: Extract passed/failed/skipped numbers and write history
output_name="dashboard/ct-output-${CI_PROJECT_NAME}.txt"

if rebar3 ct --sname ctnode$$ --cover | tee ${output_name} ; then
    x_passed=`tail -n 5 ${output_name} | grep "passed." | perl -nle 'm/(\d+) tests passed\./; print $1'`
    x_failed=0
    x_skipped=0
    if [ -z "${x_passed}" ] ; then
        x_passed=`tail -n 5 ${output_name} | grep "Passed " | perl -nle 'm/Passed (\d+) tests\./; print $1'`
        x_failed=`tail -n 5 ${output_name} | grep "Failed " | perl -nle 'm/Failed (\d+) tests\./; print $1'`
        x_skipped=`tail -n 5 ${output_name} | grep "Skipped " | perl -nle 'm/Skipped (\d+) /; print $1'`
    fi

    if [ -z "$x_passed" ]; then
      x_passed=0
    fi
    if [ -z "$x_failed" ]; then
      x_failed=0
    fi
    if [ -z "$x_skipped" ]; then
      x_skipped=0
    fi
    x_total=$(($x_passed+$x_failed+$x_skipped))
    scripts/history_update_dashboard.sh common_test "$x_failed" "$x_total" "$x_skipped"
    if [ ${x_total} -eq ${x_passed} ]; then
        # Total success
        return_value=0
    else
        return_value=1
    fi
else
    echo "Test failed!"
    scripts/history_update_dashboard.sh common_test failed
    return_value=1
fi

exit ${return_value}
