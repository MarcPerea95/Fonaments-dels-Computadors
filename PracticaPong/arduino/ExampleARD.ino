#include "comm.h"

void setup() {

  commSetup();    
}

void loop() {

  // Manage communications
  
  // ***** Example
  // In this example, data received through CHANNEL_2 is re-sent through CHANNEL_1
  if ( portIsConnected() ) {
    if ( dataAvailable(CHANNEL_2) ) {
      sendData (CHANNEL_1, getData(CHANNEL_2));
    }
  }
  // ***** End example

  // Call the following function at the end of loop
  commManager();
}
