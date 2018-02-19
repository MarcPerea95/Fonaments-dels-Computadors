#define TAG_ON '1'
#define TAG_OFF '0'
#define PIN_LED 2
#define BAUD_READ 9600


// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin 2 as an output.
  pinMode(PIN_LED, OUTPUT);
  Serial.begin(BAUD_READ);
}

// the loop function runs over and over again forever
void loop() {
  int buff;
  boolean activate = false;

  if (Serial.available() > 0)
  {
    buff = Serial.read();
    if (buff == TAG_OFF) activate = false;
    else if (buff == TAG_ON) activate = true;
  }

  if (activate) {
    digitalWrite(PIN_LED, HIGH);   // turn the LED on (HIGH is the voltage level)
    delay(1000);             // wait for a second
    digitalWrite(PIN_LED, LOW);    // turn the LED off by making the voltage LOW
    delay(1000);             // wait for a second

  } else {}
}
