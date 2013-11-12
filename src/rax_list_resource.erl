-module(rax_list_resource).
-export([init/1, allowed_methods/2, content_types_provided/2, resource_exists/2, to_json/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

allowed_methods(Request, Context) ->
    {['GET', 'HEAD'], Request, Context}.

content_types_provided(Request, Context) ->
    {[{"application/json", to_json}], Request, Context}.

resource_exists(Request, Context) ->
    {false, Request, Context}.

to_json(Request, Context) ->
    {"null", Request, Context}.
