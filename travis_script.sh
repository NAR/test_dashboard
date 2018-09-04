#!/bin/bash
set -x
rebar3 dialyzer
rebar3 compile
rebar3 eunit

scripts/history_clone.sh

