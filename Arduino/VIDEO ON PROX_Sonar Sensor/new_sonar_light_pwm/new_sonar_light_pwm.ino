const int pwPin1 = 3;
long  sensor1, pulse1;
long  theVal;
int switchState = 0;

void setup () {

  Serial.begin(9600);
  pinMode(pwPin1, INPUT);
  pinMode(4, OUTPUT); //green
  pinMode(5, OUTPUT); //red
}


void read_sensor () {

  pulse1 = pulseIn(pwPin1, HIGH);
  //pulse1 = pulseIn(pwPin1, HIGH);
  sensor1 = pulse1 / 147;
}

void print_range () {

  //Serial.print("S1");
  //Serial.print(" = ");
  //Serial.print(sensor1);
  //Serial.println("in");
  Serial.write(sensor1);

}

void light_switch () {

  if (sensor1 > 5 && sensor1 < 35) {   /////between 12in and 24in turn light green
    delay(100);
    digitalWrite(4, HIGH); //green
    digitalWrite(5, LOW); //red
  } else {
    digitalWrite(4, LOW); // green
    digitalWrite(5, HIGH); //red
    delay(100);
  }

}


void loop() {

  read_sensor();
  print_range();
  light_switch();
  delay(100);

}
