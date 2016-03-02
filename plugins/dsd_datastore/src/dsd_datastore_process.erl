-module(dsd_datastore_process).
-include("../../../include/emqttd.hrl").
-compile([export_all]).

%-record(mqtt_message, {
%    msgid           :: mqtt_msgid(),          %% Global unique message ID
%    pktid           :: mqtt_pktid(),          %% PacketId
%    topic           :: binary(),              %% Topic that the message is published to
%    from            :: binary() | atom(),     %% ClientId of the publisher
%    sender          :: binary() | undefined,  %% Username of the publisher
%    qos    = 0      :: 0 | 1 | 2,             %% Message QoS
%    flags  = []     :: [retain | dup | sys],  %% Message Flags
%    retain = false  :: boolean(),             %% Retain flag
%    dup    = false  :: boolean(),             %% Dup flag
%    sys    = false  :: boolean(),             %% $SYS flag
%    payload         :: binary(),              %% Payload
%    timestamp       :: erlang:timestamp()     %% os:timestamp
%}).

process(Message = #mqtt_message{topic = Topic, payload = Data})->
	case dsd_datastore_filters:get_filter(Topic) of
		undefined -> lager:error("No filter is defined for Topic:~p",[Topic]);
		Filter ->
			N_Data = normalize_data(Topic,Data),
			case Filter(N_Data) of
				true ->
					lager:error("Filter TRUE"),
					dsd_datastore_db:store(Data),
					done;
				false ->
					lager:error("Filter FALSE"),
					done
			end
		end.

normalize_data(<<"evenlength">>,Data)->
	erlang:binary_to_list(Data);
normalize_data(_,Data)->
	erlang:binary_to_integer(Data).
