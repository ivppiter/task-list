-module(rax_request_tools).
-export([list_data_to_view/2, list_data_to_view/3, get_field_from_object/2, get_json_from_request/1,
    id_from_request/1, task_data_to_view/2, task_data_to_view/3]).

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
