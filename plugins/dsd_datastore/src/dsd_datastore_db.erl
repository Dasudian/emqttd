-module(dsd_datastore_db).
-define(DBase,"test_mqtt").
-compile([export_all]).

init()->
	dsdbc:create_database(?DBase).

store(Data)->
	T1 = calendar:local_time(),
    Key = calendar:datetime_to_gregorian_seconds(T1),
	Value = jsonx:encode([{<<"value">>, Data}]),
	case dsdbc:put(?DBase, Key, Value) of
		ok ->
			ok;
			%lager:error("Data, key:~p, Value:~p stored in DB:~p",[Key,Value,?DBase]);
		_ ->
			lager:error("Unablet to store data in DB")
	end.
