#define BUZZER_PIN  3
#define TRIGGER_PIN 9 
#define ECHO_PIN 5  
#define SENSOR_PIN 2
#define MOTOR_PIN 10

long t; //temps que triga el eco en rebotar
long d; //distancia recorreguda en cm

int valorVelocitat;


void setup() {
  
  Serial.begin(9600);
  //ALTIMETRE
  pinMode(TRIGGER_PIN, OUTPUT);
  pinMode(ECHO_PIN, INPUT);


  //SENSOR INCLINACIO
  pinMode(SENSOR_PIN, INPUT);
  digitalWrite(SENSOR_PIN, HIGH);

  //ALARMA
  pinMode(BUZZER_PIN,OUTPUT);

  //MOTOR
  pinMode(MOTOR_PIN, OUTPUT);
  //valorVelocitat = 0;
}

void loop() {

  //ALTIMETRE
  digitalWrite(TRIGGER_PIN, LOW);
  delayMicroseconds(2);


  digitalWrite(TRIGGER_PIN, HIGH);
  delayMicroseconds(10); //Enviem un pols de 10 microsegons
  digitalWrite(TRIGGER_PIN, LOW);

  t = pulseIn(ECHO_PIN, HIGH); //obtenim el ancho de pulso
  d = (t / 59) * 10000; //escalem el temps a una distancia en cm

  Serial.print("Distancia: ");
  Serial.print(d);  //imprimim la distancia
  Serial.print("metres");
  Serial.println();
  delay(100); //fem una pausa de 100ms


  //SENSOR INCLINACIO + BUZZER
  if (digitalRead(SENSOR_PIN))   {
    //MASSA INCLINACIÓ
    Serial.print("INCLINACIÓ MÀXIMA: ALERTA");
    Serial.println();
    digitalWrite(BUZZER_PIN, HIGH);
    delay(100);

  } else {
    //TOT OK
    Serial.print("INCLINACIÓ OK");
    Serial.println();
    digitalWrite(BUZZER_PIN, LOW);
  }

  //MOTOR
  for (int i = 0; i < 255; i++)
  {
     analogWrite(MOTOR_PIN, i);
  }
 
}



