-module(dsd_data_filter).
-export([start_link/2, init/3]).

-callback init(State :: term()) -> 'ok'.
-callback handle_req(Req:: term(), State :: term()) -> {'ok', Reply :: term()}.
-callback terminate() -> 'ok'.

start_link(Name, Module) ->
	proc_lib:start_link(?MODULE, init, [self(), Name, Module]).

init(Parent, Name, Module) ->
	register(Name, self()),
	ok = Module:init(),
	proc_lib:init_ack(Parent, {ok, self()}).
