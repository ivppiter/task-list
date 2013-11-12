-module(rax_task_resource).
-export([init/1, allowed_methods/2, content_types_provided/2, resource_exists/2, to_json/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

allowed_methods(Request, Context) ->
    {['GET', 'HEAD', 'PUT', 'DELETE'], Request, Context}.

content_types_provided(Request, Context) ->
    {[{"application/json", to_json}], Request, Context}.

resource_exists(Request, Context) ->
    {rax_schema:task_exists(rax_request_tools:id_from_request(Request)), Request, Context}.

to_json(Request, Context) ->
    {get_task_json(Request), Request, Context}.

get_task_json(Request) ->
    V = rax_schema:read_task(rax_request_tools:id_from_request(Request)),
    mochijson2:encode(rax_request_tools:task_data_to_view(Request, V)).
