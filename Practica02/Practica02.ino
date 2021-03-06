#define SERIAL_TAG_ON '1'
#define SERIAL_TAG_OFF '0'
#define PIN_LED 2
#define BUTTON 12
#define BAUD_RATE 9600

enum States {STANDBY, WAIT, ON, OFF, EXIT};

bool activate = false;
bool ledOn = false;
int prevState = LOW;
int currState = LOW;

int execTime = 0;

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
States state;

// the setup function runs once when you press reset or power the board
void setup() {
  Serial.begin(BAUD_RATE);
  // initialize digital pin 2 as an output.
  pinMode(PIN_LED, OUTPUT);
  pinMode(BUTTON, INPUT);
  timer = Timer();
  state = WAIT;
  Serial.println("Enter: '1' for System ON | '0' for System OFF");
}

// the loop function runs over and over again forever
void loop() {
  int buff;
  if (Serial.available() > 0)
  {
    buff = Serial.read();
    if(buff == SERIAL_TAG_OFF)activate = false;
    else if(buff == SERIAL_TAG_ON)activate = true;
  }
  currState = digitalRead(BUTTON);

  if (currState == LOW && currState != prevState) {
    activate = !activate;
    ledOn = true;
    digitalWrite(PIN_LED, LOW);
    //timer = Timer();
  }
  prevState = currState;

  switch (state) {
    case STANDBY:
      if (activate)state = WAIT;
      break;
    case WAIT:
      if (!activate)
      {
        state = EXIT;
        break;
      }
      if (timer.Ready(1000))
      {
        if (!ledOn)state = ON;
        else state = OFF;
      }
      break;
    case ON:
      if (!activate)
      {
        state = EXIT;
        break;
      }
      digitalWrite(PIN_LED, HIGH);
      ledOn = true;
      state = WAIT;
      break;
    case OFF:
      if (!activate)
      {
        state = EXIT;
        break;
      }
      digitalWrite(PIN_LED, LOW);
      ledOn = false;
      state = WAIT;
      break;
    case EXIT:
      digitalWrite(PIN_LED, LOW);
      ledOn = false;
      timer = Timer();
      state = STANDBY;
      break;
  }

}



