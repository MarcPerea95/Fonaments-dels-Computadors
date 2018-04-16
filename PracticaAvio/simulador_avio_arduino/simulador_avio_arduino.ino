#include "comm.h"

#define BUZZER_PIN  3
#define TRIGGER_PIN 9
#define ECHO_PIN 5
#define SENSOR_PIN 2
#define MOTOR_PIN 10

int temps; //temps que triga el eco en rebotar
int distancia; //distancia recorreguda en cm
int inclinacioPerillosa; //true = 1; false = 0
int velocitatBase;  //velocitat de gir inicial
int incrementVelocitat; //increment fixe de velocitat
int multiplicadorVelocitat; //parametre rebut introduit per Processing
int valorVelocitat; //velocitat final amb el increment calculat

void setup() {

  //Serial.begin(9600);
  //ALTIMETRE
  pinMode(TRIGGER_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);

  //SENSOR INCLINACIO
  pinMode(SENSOR_PIN, INPUT);
  digitalWrite(SENSOR_PIN, HIGH);

  //ALARMA
  pinMode(BUZZER_PIN, OUTPUT);

  //MOTOR
  pinMode(MOTOR_PIN, OUTPUT);
  velocitatBase = 0;
  incrementVelocitat = 10;

  commSetup();
}

void loop() {

  //ALTIMETRE
  digitalWrite(TRIGGER_PIN, LOW);
  delayMicroseconds(2);

  //Enviem un pols de 10 microsegons
  digitalWrite(TRIGGER_PIN, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIGGER_PIN, LOW);
  //obtenim el resultat del pols i calculem la distancia
  temps = pulseIn(ECHO_PIN, HIGH);
  distancia = (temps / 59); //escalem el temps a una distancia en m

  //imprimim els resultats
  //Serial.print("Distancia: ");
  //Serial.print(distancia);  //imprimim la distancia
  //Serial.print("metres");
  //Serial.println();
  delay(100); //fem una pausa de 100ms

  //SENSOR INCLINACIO + BUZZER
  if (digitalRead(SENSOR_PIN))   {
    //MASSA INCLINACIÓ
    //Serial.print("INCLINACIÓ MÀXIMA: ALERTA");
    //Serial.println();
    inclinacioPerillosa = 1;
    digitalWrite(BUZZER_PIN, HIGH);
    //delay(100);
  } else {
    //TOT OK
    //Serial.print("INCLINACIÓ OK");
    //Serial.println();
    inclinacioPerillosa = 0;
    digitalWrite(BUZZER_PIN, LOW);
  }

  //MOTOR
  valorVelocitat = velocitatBase + (incrementVelocitat * multiplicadorVelocitat);
  analogWrite(MOTOR_PIN, map(valorVelocitat, 0, 100, 0, 255));
  //Serial.print("MULTIPLICADOR ACTUAL: ");
  //Serial.print(multiplicadorVelocitat);
  //Serial.println();

  //COMUNICACIÓ
  if ( portIsConnected() ) {
    sendData (CHANNEL_1, distancia);
    sendData (CHANNEL_2, inclinacioPerillosa);
    if (dataAvailable(CHANNEL_3) ) {
      multiplicadorVelocitat = getData(CHANNEL_3);
      //digitalWrite(BUZZER_PIN, HIGH);
    }
  }
  commManager();
  
}



