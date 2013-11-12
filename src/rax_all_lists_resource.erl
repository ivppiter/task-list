-module(rax_all_lists_resource).
-export([init/1, content_types_provided/2, to_json/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

content_types_provided(Request, Context) ->
    {[{"application/json", to_json}], Request, Context}.

to_json(Request, Context) ->
    {"[]", Request, Context}.
