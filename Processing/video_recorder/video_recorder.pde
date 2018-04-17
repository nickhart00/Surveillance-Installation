import com.hamoid.*;
import processing.video.*;

VideoExport videoExport;
boolean recording = false;

Capture cam;

int index = 0;

void setup() {
  size(400, 300);
  frameRate(30);

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
    cam = new Capture(this, cameras[15]);
    cam.start();
  }

  println("Press R to toggle recording");

  // videoExport = new VideoExport(this, "video" + index + ".mp4");
}

void draw() {

  if (cam.available() == true) {
    cam.read();
  }
  image(cam, 0, 0);
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);

  if (recording) {
    videoExport.saveFrame();
  }
}
void captureEvent(Capture cam) {
  cam.read();
}
void keyPressed() {
  if (key == 'r' || key == 'R') {
    recording = !recording;
    videoExport = new VideoExport(this, "video" + index + ".mp4");
    videoExport.startMovie();
    println("Recording is " + (recording ? "ON" : "OFF"));
  } else   if (key == 'a' || key == 'A') {
    index++;
    videoExport.endMovie();
    println("The video has been exported");
  } else if (key == 'q') {
  }
}
