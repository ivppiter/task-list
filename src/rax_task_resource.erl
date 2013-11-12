-module(rax_task_resource).
-export([init/1, allowed_methods/2, content_types_provided/2, content_types_accepted/2, resource_exists/2,
    to_json/2, from_json/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

allowed_methods(Request, Context) ->
    {['GET', 'HEAD', 'PUT', 'DELETE'], Request, Context}.

content_types_provided(Request, Context) ->
    {[{"application/json", to_json}], Request, Context}.

content_types_accepted(Request, Context) ->
    {[{"application/json", from_json}], Request, Context}.

resource_exists(Request, Context) ->
    {rax_schema:task_exists(rax_request_tools:id_from_request(Request)), Request, Context}.

to_json(Request, Context) ->
    {get_task_json(Request), Request, Context}.

from_json(Request, Context) ->
    Obj = rax_request_tools:get_json_from_request(Request),
    case rax_request_tools:read_task(Obj) of
        {ok, Tup} ->
            Id = rax_request_tools:id_from_request(Request),
            update_task(Id, Tup),
            R = wrq:set_resp_body(get_task_json(Request), Request),
            {ok, R, Context};
        _ -> {false, Request, Context}
    end.

get_task_json(Request) ->
    V = rax_schema:read_task(rax_request_tools:id_from_request(Request)),
    mochijson2:encode(rax_request_tools:task_data_to_view(Request, V)).

update_task(Id,{T, C, D}) ->
    {task, _, LId, _, _, _} = rax_schema:read_task(Id),
    update_task(Id, LId, no_binary(T), C, no_binary(D)).
update_task(Id, LId, T, C, D) -> 
    rax_schema:create_task(Id, LId, T, C, D).

no_binary(V) when is_binary(V)-> binary_to_list(V);
no_binary(V) -> V.