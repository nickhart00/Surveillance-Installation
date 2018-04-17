import processing.video.*;
import processing.serial.*;


Serial myPort;

Movie mov1;
Movie mov2;
Movie mov3;

int data;
boolean playMov1;
boolean playMov2;
boolean playMov3;

void setup() {
  String portName = Serial.list()[1];
  println(Serial.list());
  myPort = new Serial(this, portName, 9600);
  size(640, 360);
  background(0);
  mov1 = new Movie(this, "station.mov");
  mov2 = new Movie(this, "tyler-2.mov");
  mov3 = new Movie(this, "station.mov");
}

void movieEvent(Movie m) {
  m.read();
}

void draw() {
  if (myPort.available() > 0) {
    data = myPort.read();
  }
  if (data > 15) {
    playMov1 = true;
  } else {
    playMov1 = false;
    mov1.stop();
    //rect(0, 0, width/2, height/2);
    //fill(0);
    println(data);
  }

  if (playMov1 == true) {
    mov1.play();
    mov2.stop();
    mov3.stop();
    image(mov1, 0, 0, width/2, height/2);
  } else if (playMov2 == true) {
    mov2.play();
    mov1.stop();
    mov3.stop();
    image(mov2, 0, 0, width/2, height/2);
  } else if (playMov3 == true) {
    mov3.play();
    mov1.stop();
    mov2.stop();
    image(mov3, 0, 0, width/2, height/2);
  }
}

void keyPressed() {
  if (key == 'q' ) {  
    playMov1 = true;
  } else if (key == 'w' ) {
    playMov2 = true;
  } else if (key == 'e' ) {
    playMov3 = true;
  }
}

void keyReleased() {
  if (key == 'q' ) {  
    playMov1 = false;
  } else if (key == 'w' ) {
    playMov2 = false;
  } else if (key == 'e' ) {
    playMov3 = false;
  }
}
