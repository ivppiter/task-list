-module(rax_request_tools).
-export([list_data_to_view/2, list_data_to_view/3, get_field_from_object/2, get_json_from_request/1,
    id_from_request/1, task_data_to_view/2, task_data_to_view/3, read_task/1]).

list_data_to_view(R, {list, Id, Title}) -> 
    TasksUrl = wrq:base_uri(R) ++ "/list/" ++ integer_to_list(Id) ++ "/tasks",
    [{id, Id}, {title, list_to_binary(Title)}, {tasks, list_to_binary(TasksUrl)}];
list_data_to_view(R, L) -> list_data_to_view(R, L, []).
list_data_to_view(_, [], Acc) -> Acc;
list_data_to_view(R, [H|T], Acc) -> list_data_to_view(R, T, [list_data_to_view(R, H) | Acc]).

get_field_from_object(Object, Key) when is_list(Key) ->
    get_field_from_object(Object, list_to_binary(Key));
get_field_from_object(Object, Key) ->
    proplists:get_value(Key, Object).

get_json_from_request(Request) ->
    get_json_from_request_body(wrq:req_body(Request)).
get_json_from_request_body(Body) ->
    {struct, Obj} = mochijson2:decode(Body),
    Obj.
id_from_request(Request) ->
    Value = list_to_integer(wrq:path_info(id, Request)),
    case Value of
        undefined -> {error, no_data};
        _Else -> Value
    end.

task_data_to_view(R, {task, Id, ListId, Title, IsComplete, WhenDue}) ->
    Url = wrq:base_uri(R) ++ "/list/" ++ integer_to_list(ListId),
    [{id, Id}, {title, list_to_binary(Title)}, {is_complete, IsComplete}, {list, list_to_binary(Url)}, {when_due, WhenDue}];
task_data_to_view(R, L) -> task_data_to_view(R, L, []).
task_data_to_view(_, [], Acc) -> Acc;
task_data_to_view(R, [H|T], Acc) -> task_data_to_view(R, T, [task_data_to_view(R, H) | Acc]).

read_task(Obj) -> read_task(Obj, rax_request_tools:get_field_from_object(Obj, "title")).
read_task(Obj, Title) when is_binary(Title) -> read_task(Obj, binary_to_list(Title));
read_task(Obj, Title) -> read_task(Obj, Title, rax_request_tools:get_field_from_object(Obj, "is_complete")).
read_task(Obj, Title, IsComplete) -> read_task(Obj, Title, IsComplete, rax_request_tools:get_field_from_object(Obj, "when_due")).
read_task(Obj, Title, IsComplete, WhenDue) when is_binary(WhenDue) -> 
    read_task(Obj, Title, IsComplete, binary_to_list(WhenDue));
read_task(_, Title, IsComplete, WhenDue) -> {ok, {Title, IsComplete, WhenDue}}.
