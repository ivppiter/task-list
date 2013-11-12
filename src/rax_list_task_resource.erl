-module(rax_list_task_resource).
-export([init/1, allowed_methods/2, content_types_provided/2, to_json/2, process_post/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) -> 
    {ok, undefined}.

allowed_methods(Request, Context) ->
    {['GET', 'HEAD', 'POST'], Request, Context}.

content_types_provided(Request, Context) ->
    {[{"application/json", to_json}], Request, Context}.

to_json(Request, Context) ->
    L = rax_schema:tasks_in_list(rax_request_tools:id_from_request(Request)),
    Json = mochijson2:encode(rax_request_tools:task_data_to_view(Request, L)),
    io:format("Current tasks ~p for list~n", [L]),
    {Json, Request, Context}.

process_post(Request, Context) ->
    Obj = rax_request_tools:get_json_from_request(Request),
    case rax_request_tools:read_task(Obj) of
        {ok, Tup} -> 
            Task = create_new_task(rax_request_tools:id_from_request(Request), Tup),
            Json = mochijson2:encode(rax_request_tools:task_data_to_view(Request, Task)),
            R1 = wrq:set_resp_header("Location", "/task/" ++ integer_to_list(element(2, Task)), Request),
            R2 = wrq:set_resp_body(Json, R1),
            {true, R2, Context};
        _Else -> {false, Request, Context}
    end.

create_new_task(ListId, {Title, IsComplete, WhenDue}) ->
    new_task(ListId, Title, IsComplete, WhenDue).
new_task(ListId, Title, IsComplete, WhenDue) ->
    rax_schema:new_task(ListId, Title, IsComplete, WhenDue).
