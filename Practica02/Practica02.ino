#define PIN_LED 2
#define BUTTON 12
bool activate = false;
int prevState = LOW;
int currState = LOW;

int execTime = 0;

class Timer
{
  public:
    int currentTime;
    Timer(){currentTime = 0;}
    bool Ready(int t)
    {
      if(millis()-currentTime >= t)
      {
        currentTime = millis();
        return true;
      }

      return false;
      
      
    }
};
Timer t1;
Timer t2;
Timer t3;

// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin 2 as an output.
  pinMode(PIN_LED, OUTPUT);
  pinMode(BUTTON, INPUT);

}

// the loop function runs over and over again forever
void loop() {
  currState = digitalRead(BUTTON);

  if (currState == HIGH && currState != prevState) {
    activate = !activate;
  }

  prevState = currState;


  if (activate) {
    //int timer
    if(t1.Ready(100))
    digitalWrite(PIN_LED, HIGH);     // turn the LED on (HIGH is the voltage level)
    //millis(1000);
    if(t2.Ready(200))// wait for a second
    digitalWrite(PIN_LED, LOW);      // turn the LED off by making the voltage LOW
    //millis(1000);                    // wait for a second

  } else {}
}



