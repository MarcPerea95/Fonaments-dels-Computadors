#define PIN_GREEN_CAR 2
#define PIN_ORANGE_CAR 3
#define PIN_RED_CAR 4
#define PIN_GREEN_PED 5
#define PIN_RED_PED 6
#define PIN_BUTTON 7

enum SemaphorStates {SETUP, S1, S1F, S2, S3, S4, S5};
enum Modes {NORMAL, FORCED};

class Timer
{
  private:
    long currentTime;
  public:
    Timer() {
      currentTime = millis();
    }
    bool Ready(int t)
    {
      if (millis() - currentTime >= t)
      {
        currentTime = millis();
        return true;
      }
      else {
        return false;
      }
    }
    float Remaining(int t)
    {
      return t - (millis() - currentTime);
    }
};

Timer timer;
SemaphorStates semState;
Modes mode;

// the setup function runs once when you press reset or power the board
void setup() {
  Serial.begin(9600);
  // initialize digital pin 2 as an output.
  pinMode(PIN_GREEN_CAR, OUTPUT);
  pinMode(PIN_ORANGE_CAR, OUTPUT);
  pinMode(PIN_RED_CAR, OUTPUT);
  pinMode(PIN_GREEN_PED, OUTPUT);
  pinMode(PIN_RED_PED, OUTPUT);
  pinMode(PIN_BUTTON, INPUT);


  digitalWrite(PIN_GREEN_CAR, HIGH);
  digitalWrite(PIN_RED_PED, HIGH);
  timer = Timer();
  semState = S1;

  //digitalWrite(PIN_GREEN_PED, HIGH);
}

// the loop function runs over and over again forever
void loop() {
  Serial.println(semState);

  
  Serial.flush();

  switch (semState) {
    case S1:
      {
        Serial.println(timer.Remaining(20000));
        bool pushedButton = digitalRead(PIN_BUTTON);
        if (pushedButton && timer.Remaining(20000) >= 5000)
        {
          semState = S1F;
          timer = Timer();
        }
        else if (timer.Ready(20000)) {
          semState = S2;
          digitalWrite(PIN_GREEN_CAR, LOW);
          digitalWrite(PIN_ORANGE_CAR, HIGH);
          timer = Timer();
        }
      } break;
    case S1F:
      {
        if (timer.Ready(5000))
        {
          semState = S2;
          digitalWrite(PIN_GREEN_CAR, LOW);
          digitalWrite(PIN_ORANGE_CAR, HIGH);
          timer = Timer();
        }
      } break;
    case S2:
      {
        if (timer.Ready(3000)) {
          semState = S3;
          digitalWrite(PIN_RED_CAR, HIGH);
          digitalWrite(PIN_ORANGE_CAR, LOW);
          timer = Timer();
        }
      } break;
    case S3:
      {
        if (timer.Ready(1000)) {
          semState = S4;
          timer = Timer();
          digitalWrite(PIN_GREEN_PED, HIGH);
          digitalWrite(PIN_RED_PED, LOW);

        }
      } break;
    case S4:
      {
        if (timer.Ready(10000)) {
          semState = S5;
          digitalWrite(PIN_GREEN_PED, LOW);
          digitalWrite(PIN_RED_PED, HIGH);
          timer = Timer();
        }
      } break;
    case S5:
      {
        if (timer.Ready(1000)) {
          semState = S1;
          timer = Timer();
          digitalWrite(PIN_RED_CAR, LOW);
          digitalWrite(PIN_GREEN_CAR, HIGH);
        }
      } break;

  }
}




