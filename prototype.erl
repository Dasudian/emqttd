-module(prototype).
-compile([export_all]).
-define(HOST, "localhost").
-define(MQTT, 1883).
-define(N, 10).
%-define(DATA, <<"100">>).	
-define(DATA, <<"Hi this is a string of even length, but as this is a test scenarion we try to make the data big and very big and even bigger, as this data is to be stored in DB and we wanna check how much time it takes to store. I hope that this is even length string.">>).	
-define(DATA1, <<"Hi this is a string of even length, but as this is a test scenarion we try to make the data big and very big and even bigger, as this data is to be stored in DB and we wanna check how much time it takes to store. I hope that this is even length string">>).	

start(Client,Topic,N)->
	unregister(proto),
	register(proto, self()),
	ClientID = lib_util:to_binary(Client),
	Topic1 = lib_util:to_binary(Topic),
	{ok,C} = emqttc:start_link([{host, ?HOST},{client_id,ClientID}]),
	io:format("main:~p C:~p~n",[self(),C]),
	receive 
		Any->
			io:format("#####PROTOTYE: Received ~p~n",[Any])
	end,
	Start = erlang:now(),
	publish(C,Topic1,N),
	Time=timer:now_diff(erlang:now(),Start),
	io:format("Time elapsed in microseconds:~p~n",[Time]),
	emqttc:disconnect(C).

publish(_C,_Topic,0)->
	ok;
publish(C, Topic,N)->
%	io:format("N:~p~n",[N+1-N]),
%	io:format("submain: ~p~n",[self()]),
	%T1 = erlang:now(),
	case N rem 2 of
	0 ->
		emqttc:publish(C,Topic,?DATA,qos1);
	_Else ->
		emqttc:publish(C,Topic,?DATA,qos1)
	end,
	receive
		Any ->
			io:format("Received ~p~n",[Any])
		after
		1000 ->
        	io:format("Error: receive timeout!~n")
	end,
	%Diff = timer:now_diff(erlang:now(),T1),
	%io:format("Time:~p~n",[Diff]),
	publish(C,Topic,N-1).

