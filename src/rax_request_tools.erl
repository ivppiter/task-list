-module(rax_request_tools).
-export([list_data_to_view/2, list_data_to_view/3]).

list_data_to_view(R, {list, Id, Title}) -> 
    TasksUrl = wrq:base_uri(R) ++ "/list/" ++ integer_to_list(Id) ++ "/tasks",
    [{id, Id}, {title, list_to_binary(Title)}, {tasks, list_to_binary(TasksUrl)}];
list_data_to_view(R, L) -> list_data_to_view(R, L, []).
list_data_to_view(_, [], Acc) -> Acc;
list_data_to_view(R, [H|T], Acc) -> list_data_to_view(R, T, [list_data_to_view(R, H) | Acc]).