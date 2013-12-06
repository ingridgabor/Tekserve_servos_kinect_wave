/* Derived from Ingrid Gabor's thesis project "Light Waves" at ITP 2013. Adaptation of Dan Shiffman's openkinect library's "Average Point Tracking". Uses Kinect tracking to control
movement of servo motors, connected through the Adafruit 16-Channel 12-bit PWM/Servo Driver interface found at http://www.adafruit.com/products/815#Learn
Use Adafruit's tutorial for assmebling and hooking up the driver to Arduino & servos: http://learn.adafruit.com/16-channel-pwm-servo-driver/overview 
(Much thanks to Tom Igoe for help with programming during thesis studies).

Notes:
Processing 1.5 only. Higher versions have problem with openKinect. Doesnt display kinect image and run motors at the same time. Dan Shiffman is working on updates.
RXTX error message? try typing the following in your command line interface: 'sudo mkdir -p/var/lock' 'sudo chmod 777/var/lock'.
Also, check again that the following file permissions are 'Read & Write' (777): 'var/lock', 'var/spool/uucp'.
Middle servo was overheating and buffer code didn't work. changed code 'int angle = (int)v3.x/7' to '7' to buffer motion of servos. 640/7 = 91 degrees of motion (out of 120 total).
Middle servo gets the most tension. must decrease range of motion by dividing by 2.
*/

import processing.serial.*;
import org.openkinect.*;                  // kinect code
import org.openkinect.processing.*;       // kinect code
Serial myPort;

// Showing how we can form all the kinect stuff out to a separate class
KinectTracker tracker;                    // kinect code
// Kinect Library object
Kinect kinect; // kinect code
int savedTime;
int totalTime = 1000;


void setup() {
  size(640,520);
   // size(300,520);
  //size(640,520);    
  savedTime = millis();
  
  kinect = new Kinect(this);              // kinect code
  tracker = new KinectTracker();          // kinect code
 // frameRate(100);                       // kinect code
 
  println(Serial.list());
  myPort = new Serial(this, "/dev/tty.usbmodem1421", 9600);
}

void draw() {
  background(255);
  
  if (myPort.available() > 0 ) {
    print((char)myPort.read());
    
    PVector v3 = tracker.getLerpedPos();              // kinect-servo addition
    int angle = (int)v3.x/7;  // change denominator value here to buffer motion of servos. 640/7 = 91 degrees of motion (out of 120 total).
    if (angle > 100) {angle = 100;} // buffer on both ends
    if (angle < 20) {angle = 20;} 
/* 
// test with one servo at 8 -----------------------------------
      int servoNumber=8;           //test with one servo at 8
      myPort.write("s" + servoNumber + "," + angle + "\n");  // test with one servo at 8
// ------------------------------------------------------------


 
// neutral state for all servos -------------------------------
    for (int servoNumber = 8; servoNumber < 15; servoNumber++) {
    myPort.write("s" + servoNumber + "," + 60 + "\n");}
// ------------------------------------------------------------



// with timer -------------------------------------------------
    int passedTime = millis() - savedTime; // Calculate how much time has passed
    if (passedTime > totalTime) // Has one second passed?
    {
      for (int servoNumber = 8; servoNumber < 10; servoNumber++) {
      myPort.write("s" + servoNumber + "," + ((120-angle)-30) + "\n");
      angle = angle -10;
    
      if (angle > 120) {
        angle = 120;
      }
    }
    savedTime = millis(); // save the current time to restart the timer
// ------------------------------------------------------------
*/
    


// ----------------- ~~ begin servos code ~~ ----------------------------------
// ----------------------------------------------------------------------------

// servo 8 (top left, from behind).--------------------------------------------
    for (int servoNumber = 8; servoNumber < 9; servoNumber++) {    
      myPort.write("s" + servoNumber + "," + ((120-angle)-10) + "\n");  // if middle servo is (angle), 8 is (120-angle) to do opposite motion.  
    }
// ----------------------------------------------------------------------------

// servo 9 (2nd from top left, from behind).-----------------------------------
      for (int servoNumber = 9; servoNumber < 10; servoNumber++) {       
      myPort.write("s" + servoNumber + "," + ((120-angle)-20) + "\n");  // if middle servo is (angle), 9 is (120-angle) to do opposite motion.  
      }
// ----------------------------------------------------------------------------

// servo 10 (bottom left, from behind).----------------------------------------
      for (int servoNumber = 10; servoNumber < 11; servoNumber++) {        
      myPort.write("s" + servoNumber + "," + (angle+10) + "\n");  // if middle servo is (angle), 10 is (angle) to do opposite motion. 
      }
// ----------------------------------------------------------------------------

// servo 11 (middle).----------------------------------------------------------
    for (int servoNumber = 11; servoNumber < 12; servoNumber++) {   
      myPort.write("s" + servoNumber + "," + (angle/2) + "\n"); // middle servo gets the most tension. must decrease range of motion by dividing by 2.
    } 
// ----------------------------------------------------------------------------


// servo 12 (top right, from behind).------------------------------------------
      for (int servoNumber = 12; servoNumber < 13; servoNumber++) {      
      myPort.write("s" + servoNumber + "," + angle + "\n");   // if middle servo is (angle), 12 is (120-angle) to do opposite motion.
      }
// ----------------------------------------------------------------------------

// servo 13 (top right, from behind).------------------------------------------
      for (int servoNumber = 13; servoNumber < 14; servoNumber++) {      
      myPort.write("s" + servoNumber + "," + ((120-angle)-20) + "\n");   // if middle servo is (angle), 13 is (angle) to do opposite motion.
      }
// ----------------------------------------------------------------------------

// servo 14 (top right, from behind).------------------------------------------
      for (int servoNumber = 14; servoNumber < 15; servoNumber++) {   
      myPort.write("s" + servoNumber + "," + ((120-angle)-20) + "\n");   // if middle servo is (angle), 14 is (angle) to do opposite motion.
      }
// ----------------------------------------------------------------------------

 
  delay(110);  // lower numbers make motors twitch. higher numbers make motion more choppy.
  }
// ----------------- ~~ end servos code ~~ ----------------------------------

 //------------------------------------------ begin kinect code
            
  // Run the tracking analysis
  tracker.track();
  // Show the image
  tracker.display();

  // Let's draw the raw location
  PVector v1 = tracker.getPos();
  fill(50,100,250,200);
  noStroke();
  ellipse(v1.x,v1.y,20,20);

  // Let's draw the "lerped" location
  PVector v2 = tracker.getLerpedPos();
  fill(100,250,50,200);
  noStroke();
  ellipse(v2.x,v2.y,20,20);

  // Display some info
  int t = tracker.getThreshold();
  fill(0);
  text("threshold: " + t + "    " +  "framerate: " + (int)frameRate + "    " + "UP increase threshold, DOWN decrease threshold",10,500);  
  //------------------------------------------ end kinect code
} 

//------------------------------------------ begin kinect code
void keyPressed() {
  int t = tracker.getThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      t+=10;
      tracker.setThreshold(t);
    } 
    else if (keyCode == DOWN) {
      t-=10;
      tracker.setThreshold(t);
    }
  }
}

void stop() {
  tracker.quit();
  super.stop();
}
//------------------------------------------ end kinect code

/* 
void keyReleased() {
  int angle = mouseX/4;
  int servoNumber=8;
  myPort.write("s" + servoNumber + "," + angle + "\n");
 
  for (int servoNumber = 8; servoNumber < 9; servoNumber++) {
    myPort.write("s" + servoNumber + "," + angle + "\n");
    angle = angle + 10;
  }
}*/
  

