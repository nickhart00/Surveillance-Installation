int switchState = 0;
int sensorPin = A0;
void setup() {
  pinMode(3, OUTPUT); //green
  pinMode(4, OUTPUT); //red
  pinMode(5, OUTPUT); //red
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
  int newVal = (map(sensorVal, 180, 630, 80, 10));
  //Serial.print(newVal);
  //Serial.println("cm");
  Serial.write(map(sensorVal, 180, 630, 80, 10));
  //Serial.write(switchState);
  //Serial.write(newVal);
  //if (switchState == LOW) {
   if (newVal > 60) {
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
