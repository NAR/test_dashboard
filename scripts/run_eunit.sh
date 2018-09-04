#!/bin/bash

#
#


# Run eunit
# Also: Extract passed/failed/skipped numbers and write history
output_name="dashboard/eunit-output-${PROJECT_NAME}.txt"

if rebar3 eunit --sname ctnode$$ --cover | tee ${output_name} ; then
    x_total=`grep "[0-9]* tests, [0-9]* failures" ${output_name} | perl -nle 'm/(\d+) tests, (\d+) failures/; print $1;'`
    x_failed=`grep "[0-9]* tests, [0-9]* failures" ${output_name} | perl -nle 'm/(\d+) tests, (\d+) failures/; print $2;'`

    scripts/history_update_dashboard.sh eunit "$x_failed" "$x_total"
    return_value=$x_failed
else
    scripts/history_update_dashboard.sh eunit failed
    echo "Test failed!"
    return_value=1
fi

exit ${return_value}
