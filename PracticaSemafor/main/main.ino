#define PIN_GREEN_CAR 2
#define PIN_ORANGE_CAR 3
#define PIN_RED_CAR 4
#define PIN_GREEN_PED 5
#define PIN_RED_PED 6
#define PIN_BUTTON 7

enum SemaphorStates {GREEN, ORANGE, RED};
enum Modes {NORMAL, FORCED};

class Timer
{
  private:
    int currentTime;
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
};

Timer timer;
SemaphorStates semStateCar, semStatePed;
Modes mode;

// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin 2 as an output.
  pinMode(PIN_GREEN_CAR, OUTPUT);
  pinMode(PIN_ORANGE_CAR, OUTPUT);
  pinMode(PIN_RED_CAR, OUTPUT);
  pinMode(PIN_GREEN_PED, OUTPUT);
  pinMode(PIN_RED_PED, OUTPUT);
  pinMode(PIN_BUTTON, INPUT);
  timer = Timer();

  //digitalWrite(PIN_GREEN_PED, HIGH);
}

// the loop function runs over and over again forever
void loop() {
  if(digitalRead(PIN_BUTTON) == HIGH)digitalWrite(PIN_GREEN_CAR, HIGH);
  //do{digitalWrite(PIN_GREEN_CAR, HIGH);}while(false);
   //if(digitalRead(PIN_BUTTON) == LOW)digitalWrite(PIN_GREEN_CAR, HIGH);
}




