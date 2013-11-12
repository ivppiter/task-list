-module(rax_list_resource).
-export([init/1, allowed_methods/2, content_types_provided/2, 
    content_types_accepted/2, resource_exists/2, delete_resource/2, to_json/2, from_json/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> {ok, undefined}.

allowed_methods(Request, Context) ->
    {['GET', 'HEAD', 'PUT', 'DELETE'], Request, Context}.

content_types_provided(Request, Context) ->
    {[{"application/json", to_json}], Request, Context}.

content_types_accepted(Request, Context) ->
    {[{"application/json", from_json}], Request, Context}.

resource_exists(Request, Context) ->
    {rax_schema:list_exists(rax_request_tools:id_from_request(Request)), Request, Context}.

delete_resource(Request, Context) ->
    Id = rax_request_tools:id_from_request(Request),
    rax_schema:delete_list(Id),
    {true, Request, Context}.

to_json(Request, Context) ->
    {get_list_json(Request), Request, Context}.

from_json(Request, Context) ->
    Id = rax_request_tools:id_from_request(Request),
    Obj = rax_request_tools:get_json_from_request(Request),
    T = rax_request_tools:get_field_from_object(Obj, "title"),
    update_list(Id, T),
    R = wrq:set_resp_body(get_list_json(Request), Request),
    {ok, R, Context}.

get_list_json(Request) ->
    V = rax_schema:read_list(rax_request_tools:id_from_request(Request)),
    mochijson2:encode(rax_request_tools:list_data_to_view(Request, V)).

update_list(Id, T) when is_binary(T) -> update_list(Id, binary_to_list(T));
update_list(Id, T) -> rax_schema:create_list(Id, T).