-module(rax_list_resource).
-export([init/1, allowed_methods/2, content_types_provided/2, resource_exists/2, to_json/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

allowed_methods(Request, Context) ->
    {['GET', 'HEAD'], Request, Context}.

content_types_provided(Request, Context) ->
    {[{"application/json", to_json}], Request, Context}.

resource_exists(Request, Context) ->
    {rax_schema:list_exists(id_from_request(Request)), Request, Context}.

to_json(Request, Context) ->
    V = rax_schema:read_list(id_from_request(Request)),
    {mochijson2:encode(rax_request_tools:list_data_to_view(Request, V)), Request, Context}.

id_from_request(Request) ->
    Value = list_to_integer(wrq:path_info(id, Request)),
    case Value of
        undefined -> {error, no_data};
        _Else -> Value
    end.
