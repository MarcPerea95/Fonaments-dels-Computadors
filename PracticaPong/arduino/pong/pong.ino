#include "comm.h"

#define PIN_POTENCIOMETRE 2
#define PIN_SENSOR_LLUM 0
#define PIN_SENSOR_TEMP 1

int valor_potenciometre = 0;
int valor_llum = 0;
int valor_temp = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  commSetup();
  
  
}

void loop() {

  valor_potenciometre = analogRead(PIN_POTENCIOMETRE);
  valor_llum = analogRead(PIN_SENSOR_LLUM);
  valor_temp = analogRead(PIN_SENSOR_TEMP);

  valor_temp = valor_temp * 0.48828125;

  
  // put your main code here, to run repeatedly:
  float proc_val_potenciometre = valor_potenciometre / 1023.0;
  float proc_val_llum = valor_llum / 1023.0;
  float proc_val_temp = valor_temp / 1023.0;

  delay(100);
  Serial.println(valor_llum);
  //send and recieve Data
   if ( portIsConnected() ) {
      sendData (CHANNEL_1, proc_val_llum);
      sendData (CHANNEL_2, proc_val_potenciometre);
      sendData (CHANNEL_3, proc_val_temp);
  }

  

  //light1
  //poten2
  //temp3
  commManager();
}
