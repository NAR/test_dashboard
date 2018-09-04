#!/bin/bash
set -x
rebar3 dialyzer
rebar3 compile
rebar3 eunit --cover
rebar3 ct --cover
rebar3 cover --verbose

scripts/history_clone.sh

