-module(dsd_datastore_filters).
-export([get_filter/1]).

get_filter(Topic) when is_binary(Topic)->
	case Topic of
		<<"even">> ->
			fun(Data)-> if(Data rem 2 == 0)-> true; true -> false end end;
		<<"5mult">> ->
			fun(Data)-> if(Data rem 5 == 0)-> true; true -> false end end;
		_Else -> undefined
	end.
			
