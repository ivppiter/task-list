-module(rax_schema).
-export([init_tables/0, new_list/1, create_list/2, delete_list/1, read_list/1, list_exists/1, all_lists/0]).
-export([tasks_in_list/1, new_task/4, create_task/5]).

-include("include/rax_datatypes.hrl").

init_tables() ->
    io:format("Initializing Tables~n"),
    mnesia:create_table(list, [{attributes, record_info(fields, list)}]),
    mnesia:create_table(task, [{attributes, record_info(fields, task)}]).

new_list(Title) -> create_list(gen_id_list(), Title).
create_list(Id, Title) ->
    Value = {list, Id, Title},
    case mnesia:transaction(fun() -> mnesia:write(Value) end) of
        {atomic, ok} -> Value
    end.
delete_list(Id) ->
    case mnesia:transaction(fun() -> mnesia:delete({list, Id}) end) of
        {atomic, ok} -> ok
    end.

read_list(Id) ->
    case mnesia:transaction(fun() -> mnesia:read(list, Id) end) of
        {atomic, [List]} -> List;
        {atomic, []} -> {error, not_found}
    end.
list_exists(Id) ->
    case read_list(Id) of
        {error, _} -> false;
        _Else -> true
    end.

all_lists() ->
    Q = #list{_='_'},
    case mnesia:transaction(fun() -> mnesia:match_object(Q) end) of
        {atomic, ResultList} -> ResultList
    end.

gen_id_list() -> mnesia:table_info(list, size) + 1.

tasks_in_list(ListId) ->
    Q = #task{list_id = ListId, _ = '_'},
    case mnesia:transaction(fun() -> mnesia:match_object(Q) end) of
        {atomic, ResultList} -> ResultList
    end.

new_task(ListId, Title, IsComplete, WhenDue) -> create_task(gen_id_task(), ListId, Title, IsComplete, WhenDue).
create_task(Id, ListId, Title, IsComplete, WhenDue) ->
    Value = {task, Id, ListId, Title, IsComplete, WhenDue},
    case mnesia:transaction(fun() -> mnesia:write(Value) end) of
        {atomic, ok} -> Value
    end.

gen_id_task() -> mnesia:table_info(task, size) + 1.
