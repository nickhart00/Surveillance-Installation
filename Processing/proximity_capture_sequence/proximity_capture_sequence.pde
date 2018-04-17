void setup() {
}

void draw() {
  timerSequence();
}

void timerSequence() {
  boolean timeUp = false; //sets 10sec time switch false
  println(timeUp);
  int t = 0; //10 sec counter int
  int timePassed = 10; //stores the number for 10s passing
  boolean oneMinuteChecker = false; //sets one minute timer switch to false
  int tMin = 0; //one min counter int

  //if sensorVal == true (reading)
  //start 10s timer and video recording

  while (t < 10) {   //begin counting to 10s
    t ++;
    println("seconds up to 10: " + t);
    delay(1000);
  }

  timeUp = true;  //10s have passed
  println(timeUp);
  t = timePassed; //store the value of timepassed 10s.. essentially same as timeUp=true
  println("10 seconds have passed");

  //immediately after 10sec
  //push video recording to video projection
  //if sensorVal == true (reading) 
  //then people are here and loop video

  //else if sensorVal == false (no reading)
  //then people have left and begin 1min countdown

  while (tMin < 60) { //begin 1min counter if no people
    tMin ++;
    println("seconds up to 1min: " + tMin);
    delay(1000);
  }
  oneMinuteChecker = true; //one minute has passed and space is open
  println("one minute has passed"); 


  if (oneMinuteChecker == true) { 
    //if sensor == true 
    //then people are active and begin scanning
    //else init waiting screen
  }
}
