-module(rax_all_lists_resource).
-export([init/1, allowed_methods/2, content_types_provided/2, to_json/2, process_post/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> 
    {ok, undefined}.

allowed_methods(Request, Context) ->
    {['GET', 'HEAD', 'POST'], Request, Context}.

content_types_provided(Request, Context) ->
    {[{"application/json", to_json}], Request, Context}.

to_json(Request, Context) ->
    L = rax_schema:all_lists(),
    Json = mochijson2:encode(rax_request_tools:list_data_to_view(Request, L)),
    io:format("Current lists ~p~n", [L]),
    {Json, Request, Context}.

process_post(Request, Context) ->
    Obj = get_json_from_request(Request),
    T = get_field_from_object(Obj, "title"),
    NewList = new_list(binary_to_list(T)),
    Json = mochijson2:encode(rax_request_tools:list_data_to_view(Request, NewList)),
    Resp = wrq:set_resp_header("Location", "/list/" ++ integer_to_list(element(2, NewList)), Request),
    R = wrq:set_resp_body(Json, Resp),
    {true, R, Context}.

get_json_from_request(Request) ->
    get_json_from_request_body(wrq:req_body(Request)).
get_json_from_request_body(Body) ->
    {struct, Obj} = mochijson2:decode(Body),
    Obj.

get_field_from_object(Object, Key) when is_list(Key) ->
    get_field_from_object(Object, list_to_binary(Key));
get_field_from_object(Object, Key) ->
    proplists:get_value(Key, Object).

new_list(undefined) -> {error, no_arg};
new_list(Title) ->
    rax_schema:new_list(Title).
