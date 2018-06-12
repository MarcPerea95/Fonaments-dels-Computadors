#include <Servo.h>

//Pins
#define LASER_PIN 7
#define ALTIMETER_ECHO_PIN 5
#define ALTIMETER_TRIGGER_PIN 6
#define BUTTON_PIN 13
#define SERVO_H 9
#define SERVO_V 10

//Constants
#define TIME_INTERVAL 10
#define CLEAR_INTERVAL 4
#define SOUND_SPEED 292

#define CHANGE_IN_DISTANCE 50






enum ALTIMETER_MODE { CLEAR, TRIGGER, WAIT, READ };
enum TOWER_MODE { INITIALIZING, WAITING, MOVING };
enum LED_MODE_GATE { OFF, ON };

ALTIMETER_MODE altimeterMode;
TOWER_MODE towerMode;
LED_MODE_GATE laserMode;

long lastDistance;
boolean lastButtonRead;

Servo servoH, servoV;

void setup() {
  Serial.begin(9600);

  towerMode = INITIALIZING;
  lastDistance = 0;

  pinMode(LASER_PIN, OUTPUT);
  pinMode(ALTIMETER_TRIGGER_PIN, OUTPUT);
  pinMode(SERVO_H, OUTPUT);
  pinMode(SERVO_V, OUTPUT);

  pinMode(ALTIMETER_ECHO_PIN, INPUT);
  pinMode(BUTTON_PIN, INPUT);

  SetLaserState(HIGH);
  lastButtonRead = LOW;
  laserMode = ON;

  servoH.attach(SERVO_H);
  servoV.attach(SERVO_V);
}

void loop() {

  boolean tempButtonRead = digitalRead(BUTTON_PIN);
  if (tempButtonRead == HIGH && lastButtonRead != HIGH)
  {
    NextLaserMode();
    Serial.println("Laser Mode Changed!");
  }
  lastButtonRead = tempButtonRead;


  switch (towerMode) {
    case INITIALIZING:
      {
        long distance = GetAltimeterDistance();
        lastDistance = distance;
        towerMode = WAITING;
      } break;
    case WAITING:
      {
        long distance = GetAltimeterDistance();
        if (abs(lastDistance - distance) >= CHANGE_IN_DISTANCE)
        {
          Serial.print("Gato a la vista! Distancia: ");
          Serial.println(abs(lastDistance - distance));

          Serial.println("MOVING . . .");
          towerMode = MOVING;
        }

        lastDistance = distance;
      } break;
    case MOVING:
      {
        int rotH = random(0, 180);
        int rotV = random(20, 160);

        servoH.write(rotH);
        servoV.write(rotV);

        if (servoH.read() == rotH && servoV.read() == rotV)
        {
          Serial.println("RESET!");
          towerMode = INITIALIZING;
        }

      } break;
  }

}

void GetAltitudeDifference()
{

}

void NextLaserMode()
{
  switch (laserMode) {
    case OFF: {
        laserMode = ON;
        SetLaserState(LOW);
      } break;
    case ON: {
        laserMode = OFF;
        SetLaserState(HIGH);
      } break;
  }
}

void SetLaserState(boolean state)
{
  digitalWrite(LASER_PIN, state);
}

long GetAltimeterDistance() {
  long duration, distance;
  digitalWrite(ALTIMETER_TRIGGER_PIN, LOW);
  delayMicroseconds(CLEAR_INTERVAL);
  digitalWrite(ALTIMETER_TRIGGER_PIN, HIGH);
  delayMicroseconds(TIME_INTERVAL);

  duration = pulseIn(ALTIMETER_ECHO_PIN, HIGH);
  distance = duration * TIME_INTERVAL / SOUND_SPEED / 2;

  return distance;
}
