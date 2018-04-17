int switchState = 0;
int sensorPin = A0;
void setup() {
  pinMode(3, OUTPUT); //green
  pinMode(4, OUTPUT); //red
  //pinMode(5, OUTPUT); //red
  pinMode(2, INPUT); //button
  Serial.begin(9600);
}

void loop() {
  switchState = digitalRead(2);
  int sensorVal = analogRead(sensorPin);
  //Serial.print(" The state is ");
  //Serial.println(switchState);
  //Serial.print(" The proximity value is: ");
  //Serial.println(sensorVal);
  //Serial.write(sensorVal);
  int newVal = (map(sensorVal, 0, 1024, 6, 254)); // maps to range 6in - 254in (min and max range)
  Serial.print(newVal);
  Serial.println("in");
  //Serial.write(map(sensorVal, 0, 1024, 6, 254));
  //Serial.write(switchState);
  //Serial.write(newVal);
  //if (switchState == LOW) {
   if (newVal > 12 && newVal < 36) {   /////between 12in and 36in turn light green
    delay(250);
    digitalWrite(3, HIGH); //green
    digitalWrite(4, LOW); //red
    //digitalWrite(5, LOW); //red
  } else {
    digitalWrite(3, LOW); // green
    digitalWrite(4, HIGH); //red
    //digitalWrite(5, LOW); //red
    delay(250);
    // digitalWrite(4, LOW); //red
    //  digitalWrite(5, HIGH); //red
    //delay(250);

  }

}
