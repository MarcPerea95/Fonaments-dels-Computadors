#define PIN_LED 2
#define BUTTON 12


// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin 2 as an output.
  pinMode(PIN_LED, OUTPUT);
  pinMode(BUTTON, INPUT);

}

// the loop function runs over and over again forever
void loop() {
  boolean activate = false;
  if (digitalRead(BUTTON) == HIGH){
    activate = !activate;
  }

  if (activate) {
    digitalWrite(PIN_LED, HIGH);   // turn the LED on (HIGH is the voltage level)
    delay(1000);             // wait for a second
    digitalWrite(PIN_LED, LOW);    // turn the LED off by making the voltage LOW
    delay(1000);       // wait for a second

  } else {}
}
