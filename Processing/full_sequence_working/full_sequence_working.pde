import processing.serial.*;
import processing.video.*;

boolean recording = false;
boolean recordImages = false;
boolean imagesLoaded = false;
boolean videoOver = false;
int exportCounter = 0;
int recordingLength = 75;
int numFrames = 75;  // The number of frames in the animation
int currentFrame = 0;
PImage[] images = new PImage[numFrames];
int previousTime;
int waitTwenty = 20000;

Capture cam;
Serial myPort;
Movie mov1;

//background environment videos
//Movie bgMov1;
//Movie bgMov2;
//Movie bgMov3;

//index for the video recording stored
int index = 0;
//variable for data from arduino sensor
int sensorVal;
//switch storage of the train video
boolean playMov1;
boolean playRecorded;

// Saved background for greenscreen (needs to be array of others
PImage backgroundImage;
PImage backgroundReplace;

// How different must a pixel be to be a foreground pixel
float threshold = 20;


void setup() {
  /* //arduino serial reading
   String portName = Serial.list()[1];
   println(Serial.list());
   myPort = new Serial(this, portName, 9600);*/
  size(1920, 1080);
  frameRate(15);

  mov1 = new Movie(this, "station.mov");

  //background environment videos
  //bgMov1 = new Movie(this, "station.mov");
  //bgMov2 = new Movie(this, "tyler-2.mov");
  //bgMov3 = new Movie(this, "station.mov");

  //checks for active cameras and picks desired one
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      print("the camera is " + i + " ");
      println(cameras[i]);
    }

    // The camera can be initialized directly using an 
    // element from the array returned by list():
    //needed to hard code the dimensions to HD
    //camera[i] must change when changing computers
    //cam = new Capture(this, 1920, 1080, cameras[30]);
    cam = new Capture(this, cameras[30]);
    //cam = new Capture(this, width, height, 30); //old dependent on window
    cam.start();
  }

  // Create an empty image the same size as the video for greenscreening
  //backgroundImage = createImage(cam.width, cam.height, RGB);
  //backgroundReplace = loadImage("beach-1.jpg");


    //load images
    for (int i = 0; i < numFrames; i++) {
      String imageName = "video/" + "person" + index + "_" + nf (i, 4) + ".jpg";
      images[i] = loadImage(imageName);
    }

}
//neccessary to play stored videos
void movieEvent(Movie m) {
  m.read();
}
// New frame available from camera
//neccessary to show live recordings
void captureEvent(Capture cam) {
  cam.read();
}

void draw() {
  //  if (myPort.available() > 0) {
  //    sensorVal = myPort.read();
  //  }
  //  if (sensorVal > 60 && sensorVal < 90) {
  timerSequence();
  //  }
  //theGreenEffect();

  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0);
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
}

void keyPressed ()
{
  if (key == 'c')
  {
    recordImages = true;
    exportCounter = 0;
  }
  if (key == 's')
  {
    imagesLoaded = true;
  }
    if (key == 'a')
  {
    playRecorded();
  }
}
void timerSequence() {


  //start video recording
  if (recordImages == true) {
    saveFrame ("video/" + "person" + index + "_" + nf (exportCounter, 4) + ".jpg");
    exportCounter += 1;
    println ("recording image " +  exportCounter + " of " + recordingLength + " frames");
    if (exportCounter == recordingLength) {
      recordImages = false;
      println ("done recording");
    }
  }

  //delay(1000);

  videoOver = true;
  println(videoOver);
  if (videoOver == true) {
    rect(0, 0, width, height);
    fill(0);
    resetCounters();
  }




  /* 
   
   
   
   
   THIS WILL POTENTIALLY PLAY BACKGROUND VIDEOS
   // if sensorVal show/start movie else show black
   if (timeUp == true) {
   playMov1 = true;
   } else {
   playMov1 = false;
   mov1.stop();
   rect(0, 0, width, height);
   fill(0);
   println(sensorVal);
   }
   if (playMov1 == true) {
   mov1.play();
   //mov2.stop();
   //mov3.stop();
   image(mov1, 0, 0, width, height);
   } 
   
   
   
   */
}

void playRecorded() {
  //play images


  currentFrame = (currentFrame+1) % numFrames;  // Use % to cycle through frames
  int offset = 0;
  image(images[(currentFrame+offset) % numFrames], 0, 0);


  /* //fun images tile
   int offset = 0;
   for (int x = -100; x < width; x += images[0].width) { 
   image(images[(currentFrame+offset) % numFrames], x, -20);
   offset+=2;
   image(images[(currentFrame+offset) % numFrames], x, height/2);
   offset+=2;
   }*/
}


void resetCounters() {

  //index++;
}
