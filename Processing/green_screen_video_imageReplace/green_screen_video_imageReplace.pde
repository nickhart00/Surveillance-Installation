// Exercise 16-6: Instead of replacing the background with green pixels, replace it with another 
// image. What values work well for threshold and what values do not work at all? Try 
// controlling the threshold variable with the mouse.  

// Click the mouse to memorize a current background image
import gab.opencv.*;
import processing.video.*;

// Variable for capture device
Capture cam;
OpenCV opencv;
Movie mov1;
Movie backgroundReplace;

boolean playMov1;

// Saved background
PImage backgroundImage;

//PImage backgroundReplace;

// How different must a pixel be to be a foreground pixel
float threshold = 20;

void setup() {
  size(1920, 1080);

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
    cam = new Capture(this, 1920, 1080, cameras[15]);
    //cam = new Capture(this, 1920, 1080, 30); //old dependent on window
    cam.start();
  }
  mov1 = new Movie(this, "Break.mov");
  opencv = new OpenCV(this, 1920, 1080);

  opencv.startBackgroundSubtraction(5, 3, 0.5);

  mov1.loop();
  mov1.play();
  // Create an empty image the same size as the video
  backgroundImage = createImage(cam.width, cam.height, RGB);
}

// New frame available from camera
void captureEvent(Capture cam) {
  cam.read();
}

void movieEvent(Movie m) {
  m.read();
}
void draw() {
  image(mov1, 0, 0, width, height);  
  tint(255, 120);
  image(cam, 0, 0);  
  theGreenEffect();
}

/*void playMovie() {
  if (playMov1 == true) {
    mov1.play();
    backgroundReplace.play();
    //mov2.stop();
    //mov3.stop();
    image(mov1, 0, 0, width, height);
  } else {
    playMov1 = false;
    mov1.stop();
  }
}*/
void theGreenEffect() {
  // Map the threshold to mouse location
  threshold = map(mouseX, 0, width, 5, 50);

  // We are looking at the video's pixels, the memorized backgroundImage's pixels, as well as accessing the display pixels. 
  // So we must loadPixels() for all!
  loadPixels();

  mov1.loadPixels();
    tint(255, 120);
      cam.loadPixels(); 

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
        pixels[loc] = mov1.pixels[loc];
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
