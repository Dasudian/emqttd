-module(sunwoda_filter).
-behavior(dsd_data_filter).
-export([init/1, handle_req/2, terminate/0]).
-export([start_link/0]).

start_link()->
	dsd_data_filter:start_link(sunwoda, ?MODULE).

init([])->
	io:format("Init of the callback~n",[]),
	ok.

handle_req(_Req, _State)->
	io:format("handle_req of callback"),
	{ok, reply}.

terminate()->
	ok.
