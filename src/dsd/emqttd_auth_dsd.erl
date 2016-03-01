%%% @doc Dasudian Authentication module
%%%
%%% @author Anmol Kumar Singh <anmol@dasudian.com>
%%%-----------------------------------------------------------------------------
-module(emqttd_auth_dsd).

-include("emqttd.hrl").

-behaviour(emqttd_auth_mod).

%% emqttd_auth callbacks
-export([init/1, check/3, description/0, make_client/2]).
%%%=============================================================================
%%% emqttd_auth callbacks
%%%=============================================================================
init(Opts) ->
    {ok, Opts}.
check(#mqtt_client{username = undefined}, _Password, _Opts) ->
    {error, "Username undefined"};
check(_User, undefined, _Opts) ->
    {error, "Password undefined"};
check(#mqtt_client{username = Username,client_id = ClientId}, Password, _Opts) ->
	User = lib_util:to_list(Username),
	try
	[Cust,App1,App2,Client | Rest]=re:split(ClientId,"_"),
	Client1 = case Rest of
		[]->
			lib_util:to_list(Client);
		Rest->
			make_client(Rest,Client)
	end,
	Appid = binary_to_list(Cust) ++ "_" ++ binary_to_list(App1) ++ "_" ++ binary_to_list(App2),
	App = lib_util:to_list(Appid),
	case dsd_cookie:verify_token(Password) of
		{ok, {App, User, Client1, _Random, _TokenSecret}}->
			lager:info("Authenticated successfully using DSD-Auth module"),
			ok;
		{error, invalid}->
			{error, invalid_token}
	end
	catch
	_:_-> 
		{error, invalid}
	end.
description() ->
    "Dasudian Token based authentication module".
%%%=============================================================================
%%% Internal functions
%%%=============================================================================
make_client([],Return)->
	lib_util:to_list(Return);
make_client([P|Rest],Client)->
	Return = lib_util:to_list(Client) ++ "_" ++ lib_util:to_list(P),
	make_client(Rest,Return).
