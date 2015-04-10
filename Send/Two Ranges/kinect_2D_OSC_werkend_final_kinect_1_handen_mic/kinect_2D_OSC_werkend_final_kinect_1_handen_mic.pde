

String ipToSendTo = "192.168.0.178";
String ipToSendTo2 = "192.168.0.181";
String ipToSendTo3 = "192.168.0.193";
String ipToSendTo4 = "192.168.0.176";
String ipToSendTo5 = "192.168.0.198";
//---------------------------------------------------------
//
// author: thomas diewald
// date: 06.09.2011
//
// example how to use diewald_CV_kit.blobdetection.
// 
// this example needs to have the dlibs.freenect library installed!
//
// download: 
//  1) http://thomasdiewald.com/blog/?p=109
//  2) http://thomasdiewald.com/processing/libraries/dLibs_freenect/
//
// -------------------------------------------------------
// interaction:
//
// dragged mouse - drag a rectangle to define the detection area
//
// key 'UP'   - lower resolution
// key 'DOWN' - higher resolution
// key 'b'   - draw boundingsboxes of blobs
// key 'f'   - fill blobs
//
//---------------------------------------------------------

import diewald_CV_kit.libraryinfo.*;
import diewald_CV_kit.utility.*;
import diewald_CV_kit.blobdetection.*;

import dLibs.freenect.*;
import dLibs.freenect.constants.*;
import dLibs.freenect.interfaces.*;

import ddf.minim.*;
Minim minim;
AudioInput in;

PFont font;

//-------------------------------------------------------------------
// kinect
Kinect kinect_;                     
KinectFrameVideo kinect_video_;     
KinectFrameDepth kinect_depth_;     
KinectTilt kinect_tilt_;

// get width/height --> actually its always 640 x 480
int size_x = VIDEO_FORMAT._RGB_.getWidth(); 
int size_y = VIDEO_FORMAT._RGB_.getHeight(); 
PImage video_frame_, depth_frame_;  // images

//-------------------------------------------------------------------
// blob detection 
BlobDetector blob_detector;
BoundingBox detection_area;
BlobDetector blob_detector2;
BoundingBox detection_area2;
int detection_resolution = 1;
boolean draw_blobs_boundingsbox  = true;
boolean draw_filled_blobs        = true;

//-------------------------------------------------------------------
//OSC
import oscP5.*;
import netP5.*;

OscP5 oscP5;

NetAddress myRemoteLocation;
NetAddress myRemoteLocation2;
NetAddress myRemoteLocation3;
NetAddress myRemoteLocation4;
NetAddress myRemoteLocation5;

int mic_gevoeligheid= 1000;

public void setup() {
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress(ipToSendTo, 12000);
  myRemoteLocation2 = new NetAddress(ipToSendTo2, 12000);
  myRemoteLocation3 = new NetAddress(ipToSendTo3, 12000);
  myRemoteLocation4 = new NetAddress(ipToSendTo4, 12000);
  myRemoteLocation5 = new NetAddress(ipToSendTo5, 12000);

  size(size_x, size_y*2);

 minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, mic_gevoeligheid);
  //--------------------------------------------------------------------------
  // KINECT STUFF - initialization
  kinect_ = new Kinect(0);  //create a main kinect instance with index 0

    kinect_video_ = new KinectFrameVideo(VIDEO_FORMAT._RGB_  );      // create a video instance, RGB
  kinect_depth_ = new KinectFrameDepth(DEPTH_FORMAT._11BIT_);      // create a depth instance
  kinect_tilt_  = new KinectTilt();                                // create a Tilt instance

  kinect_video_.setFrameRate(30);
  kinect_depth_.setFrameRate(30);


  kinect_video_.connect(kinect_);  // connect the created video instance to the main kinect
  kinect_depth_.connect(kinect_);  // connect the created depth instance to the main kinect
  kinect_tilt_ .connect(kinect_);  // connect Tilt to Kinect

  kinect_tilt_.setTiltDegrees(10);  // set tilt degrees

  // create a PImage for video/depth
  video_frame_ = createImage(VIDEO_FORMAT._RGB_  .getWidth(), VIDEO_FORMAT._RGB_     .getHeight(), RGB);
  depth_frame_ = createImage(DEPTH_FORMAT._11BIT_.getWidth(), DEPTH_FORMAT._11BIT_   .getHeight(), RGB);


  //--------------------------------------------------------------------------
  // BLOB DETECTION STUFF - initialization
  blob_detector = new BlobDetector(size_x, size_y);
  blob_detector.setResolution(detection_resolution);
  blob_detector.computeContours(true);
  blob_detector.computeBlobPixels(!true);
  blob_detector.setMinMaxPixels(10*10, size_x*size_y);

  blob_detector.setBLOBable(new BLOBable_Kinect_2D(this).setKinectDepth(kinect_depth_));

  detection_area = new BoundingBox(0, 0, size_x, size_y);
  blob_detector.setDetectingArea(detection_area);
  
   // BLOB DETECTION STUFF - initialization SECOND AREA
  blob_detector2 = new BlobDetector(size_x, size_y);
  blob_detector2.setResolution(detection_resolution);
  blob_detector2.computeContours(true);
  blob_detector2.computeBlobPixels(!true);
  blob_detector2.setMinMaxPixels(10*10, size_x*size_y);
  
  blob_detector2.setBLOBable(new BLOBable_Kinect_2D_2(this).setKinectDepth(kinect_depth_));

  detection_area2 = new BoundingBox(0, 0, size_x, size_y);
  blob_detector2.setDetectingArea(detection_area2);


  //--------------------------------------------------------------------------
  //  FONT, FRAMERATE, ...
  font = createFont("Calibri", 14);
  textFont(font);
  frameRate(30);
}



public void draw() {
     OscMessage micMessage = new OscMessage("/microphone");
  float microphone=abs(in.left.get(i)*mic_gevoeligheid);
  micMessage.add(microphone);
  assignPixels( video_frame_, kinect_video_);
  assignPixels( depth_frame_, kinect_depth_);


  image(depth_frame_, 0, 0);
  image(video_frame_, 0, size_y);


  // draw the detection-area
  stroke(0, 0, 0);
  strokeWeight(1);
  noFill();
  rect(detection_area.xMin(), detection_area.yMin(), detection_area.xSize()-1, detection_area.ySize()-1);
  //handen
  rect(detection_area2.xMin(), detection_area2.yMin(), detection_area2.xSize()-1, detection_area2.ySize()-1);

  // set resolution - improves speed a lot
  blob_detector.setResolution(detection_resolution);
  //handen
  blob_detector2.setResolution(detection_resolution);


  blob_detector.update();
    blob_detector2.update();

  // maak een lijstje van de blobs
  ArrayList<Blob> blob_list = blob_detector.getBlobs();
  ArrayList<Blob> blob_list2 = blob_detector2.getBlobs();
  //println("blob_list size= "+blob_list.size());

  OscMessage blobMessage = new OscMessage("/kinect_1");
   OscMessage handMessage = new OscMessage("/kinect_1_handen");

   
   
   
   handMessage.add(blob_list2.size());
   //-------------------------------------------------------------------------------------handen for loop
   for (int blob_idx = 0; blob_idx < blob_list2.size(); blob_idx++ ) {
     
     
    
    Blob blob = blob_list2.get(blob_idx);
    //println("blob id = "+blob_idx);
    
    handMessage.add(blob_idx);

    ArrayList<Contour> contour_list2 = blob.getContours();

 
    for (int contour_idx = 0; contour_idx < contour_list2.size(); contour_idx++ ) {
      Contour contour2 = contour_list2.get(contour_idx);
      BoundingBox bb = contour2.getBoundingBox();

      // draw the outer contours
      if ( contour_idx == 0) {

        if ( draw_blobs_boundingsbox ) {
          drawBoundingBox(bb, color(0), 2);
          fill(0);
          text("blob["+blob_idx+"]", bb.xMin(), bb.yMin()- textDescent()*2);
          handMessage.add(bb.xSize());
          handMessage.add(bb.ySize());
          handMessage.add(bb.xMin() + bb.xSize()/2);
          handMessage.add(bb.yMin() + bb.ySize()/2);

         
          
        }

        drawContour(contour2.getPixels(), color(255), color(0, 150), draw_filled_blobs, 2);
      } 
      else {
        // draw the inner contours, if they have more than 20 vertices
        //          if( contour.getPixels().size() > 20){
        //            drawContour(contour.getPixels(), color(255, 150,0), color(0, 100), false, 1);
        //          }
      }
    }
  }
  
  
  blobMessage.add(blob_list.size());
  // per blob, doe hetvolgende:
  
  
  for (int blob_idx = 0; blob_idx < blob_list.size(); blob_idx++ ) {
    Blob blob = blob_list.get(blob_idx);
    //println("blob id = "+blob_idx);

    blobMessage.add(blob_idx);


    ArrayList<Contour> contour_list = blob.getContours();

    /* vanaf hier kun je per blob data naar vivian versturen, waarbij:
     -blob_idx   de blob is die op dit moment door de for loop gaat (dus het nummertje van de blob)
     -bb.xMin    de x value van de bounding box van de linkerbovenhoek van de blob is
     -bb.yMin    de y value van de bounding box van de linkerbovenhoek van de blob is
     -bb.xSize   de breedte van de bounding box van de blob is
     -bb.ySize   de hoogte van de bounding box van de blob is
     
     dus als je alleen t middelpunt van de blob naar vivian wil sturen:
     int xCenterBlob = bb.xMin + bb.xSize/2;
     int yCenterBlob = bb.yMin + bb.ySize/2;
     */
    for (int contour_idx = 0; contour_idx < contour_list.size(); contour_idx++ ) {
      Contour contour = contour_list.get(contour_idx);
      BoundingBox bb = contour.getBoundingBox();

      // draw the outer contours
      if ( contour_idx == 0) {

        if ( draw_blobs_boundingsbox ) {
          drawBoundingBox(bb, color(0), 2);
          fill(0);
          text("blob["+blob_idx+"]", bb.xMin(), bb.yMin()- textDescent()*2);

          blobMessage.add(bb.xSize());
          blobMessage.add(bb.ySize());
          blobMessage.add(bb.xMin() + bb.xSize()/2);
          blobMessage.add(bb.yMin() + bb.ySize()/2);

println(bb.yMin());

          //println("my blob bundle= "+ blobBundle);
        }

        drawContour(contour.getPixels(), color(255), color(0, 150), draw_filled_blobs, 2);
      } 
      else {
        // draw the inner contours, if they have more than 20 vertices
        //          if( contour.getPixels().size() > 20){
        //            drawContour(contour.getPixels(), color(255, 150,0), color(0, 100), false, 1);
        //          }
      }
    }
  }

  // simple information about framerate, and number of detected blobs
  fill(0, 200); 
  noStroke();
  rect(0, 0, 150, 50);
  printlnNumberOfBlobs(blob_detector);
  printlnFPS();
  //blobBundle.add(blobMessage);
  oscP5.send(blobMessage, myRemoteLocation);
  oscP5.send(blobMessage, myRemoteLocation2);
  oscP5.send(blobMessage, myRemoteLocation3);
  oscP5.send(blobMessage, myRemoteLocation4);
  oscP5.send(blobMessage, myRemoteLocation5);
  
  oscP5.send(handMessage, myRemoteLocation);
  oscP5.send(handMessage, myRemoteLocation2);
  oscP5.send(handMessage, myRemoteLocation3);
  oscP5.send(handMessage, myRemoteLocation4);
  oscP5.send(handMessage, myRemoteLocation5);
  
  oscP5.send(micMessage, myRemoteLocation);
  oscP5.send(micMessage, myRemoteLocation2);
  oscP5.send(micMessage, myRemoteLocation3);
  oscP5.send(micMessage, myRemoteLocation4);
  oscP5.send(micMessage, myRemoteLocation5);
}





//-------------------------------------------------------------------
public void assignPixels(PImage img, Pixelable kinect_dev) {
  img.loadPixels();
  img.pixels = kinect_dev.getPixels();  // assign pixels of the kinect device to the image
  img.updatePixels();
}


//-------------------------------------------------------------------
//this is maybe not necessary, but is the proper way to close everything
public void dispose() {
  Kinect.shutDown(); 
  super.dispose();
}

