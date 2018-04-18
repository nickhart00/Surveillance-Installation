import processing.serial.*;
import processing.video.*;
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.KeyEvent;

Robot robot;

boolean recordImages = false;
boolean imagesLoaded = false;
boolean imagesPlaying = false;
boolean endInitScreen = false;
boolean countdown = false;
boolean waitText = false;
boolean theReset = false;
boolean videoOver = false;
boolean sensorStarted = false;
int exportCounter = 0;
int cycleCounter = 0;
int recordingLength = 75;
int numFrames = 75;  // The number of frames in the animation
int uiNumFrames = 480;  // The number of frames in the animation
int currentFrame = 0;
PImage[] images = new PImage[numFrames];
PImage[] uiImages = new PImage[numFrames];
PImage initScreen;
int millis;
int newTime;

int wait;
PFont f;
PFont f1;
int decrementing = 71;

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
int myVal;
//switch storage of the train video
boolean playMov1;
boolean playRecorded;

// Saved background for greenscreen (needs to be array of others
PImage backgroundImage;
PImage backgroundReplace;

// How different must a pixel be to be a foreground pixel
float threshold = 20;


void setup() {
  f = loadFont("SansSerif-48.vlw");
  f1 = loadFont("SansSerif-48.vlw");
  initScreen = loadImage("init_screen.jpg");
  ///arduino serial reading
  String portName = Serial.list()[1];
  println(Serial.list());
  delay(1000);
  myPort = new Serial(this, portName, 9600);
  size(1920, 1080);
  frameRate(15);

  //Let's get a Robot...
  try { 
    robot = new Robot();
  } 
  catch (AWTException e) {
    e.printStackTrace();
    exit();
  }

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
    cam = new Capture(this, cameras[16]);
    //cam = new Capture(this, width, height, 30); //old dependent on window
    cam.start();
  }

  // Create an empty image the same size as the video for greenscreening
  backgroundImage = createImage(1920, 1080, RGB);
  float randomNum = random(-1, 1);
  int imagePicked;
  if (randomNum > 0) {
    imagePicked = 1;
  } else {
    imagePicked = 0;
  }
  String bgImageChosen = "background_" + imagePicked + ".jpg";
  backgroundReplace = loadImage(bgImageChosen);
  println(bgImageChosen);

  //backgroundReplace = loadImage("facebook-tile.jpg");

  //load ui
  for (int i = 0; i < numFrames; i++) {
    String imageName = "video/" + "person" + 0 + "_" + nf (i, 4) + ".jpg";
    images[i] = loadImage(imageName);
  }


  //load ui imagesin
  for (int i = 0; i < numFrames; i++) {
    String imageName = "ui/" + "UI_" + nf (i, 5) + ".png";
    uiImages[i] = loadImage(imageName);
  }
  //index++;
}
//neccessary to play stored videos
void movieEvent(Movie m) {
  m.read();
}
// New frame available from camera
//neccessary to show live recordings
void captureEvent(Capture cam) {
  cam.read();

  exportCounter = 0;
}

void imageCapture() {
  // ------------ STEP 001 CAPTURE

  println ("recordImages is now true");
  println ("started image recording");
  countdown = true;
  //start video recording
  for (int i = 0; i < recordingLength; i++) {
    saveFrame ("video/" + "person" + 0 + "_" + nf (i, 4) + ".jpg");
    exportCounter += 1;
    println ("recording image " +  i + " of " + recordingLength + " frames");
  }
  if (exportCounter == recordingLength) {
    countdown = false;
    delay(1000);
    println ("done recording");
    recordImages = false;
    println ("recordImages is now false");
    println("now restarting");

    delay(2000);
    //theReset = true;
    theReset();
  }
}


void theReset() {

  // ------------ STEP 002 RESET
  //if (theReset == true) {
  setup();
  println ("reset complete");
  //}
  theReset = false;
  delay(2000);
  imagesPlaying = true;
  println ("started image playing");
  //}
}
void draw() {

  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0);
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);

  //if (!endInitScreen) {
  // image(initScreen, 0, 0);
  //}



  if (myPort.available() > 0) {
    sensorVal = myPort.read();
    println(sensorVal);
  }

  if (sensorVal > 5 && sensorVal < 35) {
    myVal = 20;
    println("my val is " + myVal);
    if (myVal == 20) {
      //recordImages = true;
      timerSequence();
      myVal -= 1;
    }
    millis = millis();
    endInitScreen = true;
    delay(100);
    //Press the space key

    newTime = millis() - millis;
    /*if (newTime < 1000) {
     //recordImages = !recordImages;
     println(newTime);
     robot.keyPress(KeyEvent.VK_SPACE);
     //If we want a delay here, that gets a little bit more complicated...
     robot.keyRelease(KeyEvent.VK_SPACE);              
     }*/
  }
  theGreenEffect();



  //timerSequence();


  /*
  // ------------ STEP 001 CAPTURE
   if (recordImages == true)
   { 
   println ("recordImages is now true");
   println ("started image recording");
   countdown = true;
   //start video recording
   saveFrame ("video/" + "person" + 0 + "_" + nf (exportCounter, 4) + ".jpg");
   exportCounter += 1;
   println ("recording image " +  exportCounter + " of " + recordingLength + " frames");
   if (exportCounter == recordingLength) {
   countdown = false;
   delay(1000);
   println ("done recording");
   recordImages = false;
   println ("recordImages is now false");
   println("now restarting");
   
   delay(2000);
   theReset = true;
   }
   }
   
   */

  /*
  // ------------ STEP 002 RESET
   if (theReset == true) {
   setup();
   println ("reset complete");
   //}
   theReset = false;
   delay(2000);
   imagesPlaying = true;
   println ("started image playing");
   }
   */

  // ------------ STEP 003 PLAY RECORDiING
  if (imagesPlaying == true) {

    int offset = 0;
    //play images
    currentFrame = (currentFrame+1) % numFrames;  // Use % to cycle through frames
    image(images[(currentFrame+offset) % numFrames], 0, 0);
    println("image no:" + currentFrame);
    //fun images tile

    /*for (int x = -100; x < width; x += images[0].width) { 
     image(images[(currentFrame+offset) % numFrames], x, -20);
     offset+=2;
     image(images[(currentFrame+offset) % numFrames], x, height/2);
     offset+=2;
     }*/
    cycleCounter++;
    if (cycleCounter > (75*5)) {
      println ("done cyclying video");
      imagesPlaying = false;
      println ("imagesPlaying is now false");
      cycleCounter = 0;
    }
  }


  if (countdown == true) {
    playUI();
  }
}

void playUI() {

  int offset = 0;
  //play images
  currentFrame = (currentFrame+1) % numFrames;  // Use % to cycle through frames
  image(uiImages[(currentFrame+offset) % numFrames], 0, 0);
}


void timerSequence() {
  sensorStarted = true;
  if ( sensorStarted == true) {
    imageCapture();
    println ("recordImages is now true");
    exportCounter = 0;
    println ("started image recording");
  }
    sensorStarted = false;
}

/*
void keyPressed() {
 if (key == ' ') {
 endInitScreen = true;
 timerSequence();
 }
 }*/




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

//}



void theGreenEffect() {
  // Map the threshold to mouse location
  threshold = map(mouseX, 0, width, 5, 50);

  // We are looking at the video's pixels, the memorized backgroundImage's pixels, as well as accessing the display pixels. 
  // So we must loadPixels() for all!
  loadPixels();
  cam.loadPixels(); 
  backgroundImage.loadPixels();

  // Begin loop to walk through every pixel
  for (int x = 0; x < cam.width; x ++ ) {
    for (int y = 0; y < cam.height; y ++ ) {
      int loc = x + y*cam.width; // Step 1, what is the 1D pixel location
      color fgColor = cam.pixels[loc]; // Step 2, what is the foreground color

      // Step 3, what is the background color
      color bgColor = backgroundImage.pixels[loc];

      // Step 4, compare the foreground and background color
      float r1 = red(fgColor);
      float g1 = green(fgColor);
      float b1 = blue(fgColor);
      float r2 = red(bgColor);
      float g2 = green(bgColor);
      float b2 = blue(bgColor);
      float diff = dist(r1, g1, b1, r2, g2, b2);

      // Step 5, Is the foreground color different from the background color
      if (diff > threshold) {
        // If so, display the foreground color
        pixels[loc] = fgColor;
      } else {
        // If not, display green
        //pixels[loc] = color(0, 255, 0);
        // If not, display the beach scene
        pixels[loc] = backgroundReplace.pixels[loc];
      }
    }
  }
  updatePixels();
}

void mousePressed() {
  // Copying the current frame of video into the backgroundImage object
  // Note copy takes 5 arguments:
  // The source image
  // x,y,width, and height of region to be copied from the source
  // x,y,width, and height of copy destination
  backgroundImage.copy(cam, 0, 0, cam.width, cam.height, 0, 0, cam.width, cam.height);
  backgroundImage.updatePixels();
}
