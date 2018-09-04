-module(myapp_test).

-include_lib("eunit/include/eunit.hrl").

hello_test() ->
  myapp_app:status().
