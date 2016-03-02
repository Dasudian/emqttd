## INTRODUCTION
Simulated the scenario in which device sends data to the server, server upon receiving the data executes certain logic and returns the result of the logic back to the device.  

## STEP WISE FLOW
1. EMQTT-CLIENT (Device) sends/publish data along with the Topic (or TAG) to the MQTT-SERVER.  
2. MQTT-SERVER receives the data and check the TOPIC(TAG) associated with the data.  
3. MQTT-SERVER then according to this TOPIC executes the filter(decision logic).  
4. Filter either returns true or false.  
5. If the filter returns true data is stored in the database.  
6. Acknowledgement is sent to the MQTT-CLIENT (Device).  

## TEST DETAILS  
1. MQTT-Client sends a string attached with TOPIC evenlength.  
2. MQTT-SERVER receives the data and according to the TOPIC evenlength runs a filter.  
3. This filter checks if the length of string is even or not.  
4. If filter returns true data is stored in DSDB, else not.  
5. Acknowledgement is sent to the MQTT-CLIENT.  

The above test-case is executed 1000 times below are the results:  
1. When the test case is executed with an odd length string and data is not stored in DB it took __57149 microseconds__.  
2. When the test case is executed with an even length string and data is stored in DB it took __8312359 microseconds__.  
3. When the test case is executed with alternate even/odd length string and data is stored in DB in alternate rounds it took __6153671 microseconds__.  

## SPECS
__DataBase used:__ DSDB  
__MQTT-SERVER:__ Running on Ubuntu with 4GB RAM  
__MQTT-CLIENT:__ Running on Ubuntu with 4GB RAM  
