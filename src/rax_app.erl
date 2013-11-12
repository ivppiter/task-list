%% @author author <author@example.com>
%% @copyright YYYY author.

%% @doc Callbacks for the rax application.

-module(rax_app).
-author('author <author@example.com>').

-behaviour(application).
-export([start/2,stop/1]).


%% @spec start(_Type, _StartArgs) -> ServerRet
%% @doc application start callback for rax.
start(_Type, _StartArgs) ->
    rax_sup:start_link().

%% @spec stop(_State) -> ServerRet
%% @doc application stop callback for rax.
stop(_State) ->
    ok.
