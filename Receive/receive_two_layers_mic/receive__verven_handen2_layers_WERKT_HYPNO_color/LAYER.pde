class Laag extends Layer {
int age;
import oscP5.*;
import netP5.*;

int sizeb =0;
  Laag(PApplet parent) {
    super(parent);
  }

  void setup() {
    
    smooth();
    colorMode(HSB);
  }

  void draw() {
    sizeb+=90;
    // fill(0, 0);
    background(0,0);
   // rect(0, 0, width, height);
    
    
     if (kinect1_handen == true && kinect2_handen == true && kinect3_handen == true) {
  //  println(kinect3_handen);
    
    int nrBlobs_handen = (xValues_handen.size());
    //    println("number of blobs  "+nrBlobs);
    // int nrBlobs = (nrKinect1 + nrKinect2 + nrKinect3);
    //println("nr of blobs in de void draw loop ="+nrBlobs);
if(nrBlobs_handen>0){
 
}
 // try {
     
      Assignhanden_.makeObjects(nrBlobs_handen, xValues_handen,yValues_handen, xSizes_handen, ySizes_handen);
 // }
   //catch(IndexOutOfBoundsException e) { 
     // println("An error occurred in handen class");
 // }
//    Assignobjects_.check_collision();
   
    xValues_handen.clear();
    yValues_handen.clear();

    xSizes_handen.clear();
    ySizes_handen.clear();
//println("all kinects where true RESET---------------------------");
  
    kinect1_handen=false;

    kinect2_handen=false;
    kinect2_handen=false;
    
  }
  
 int hand_amount = objects_list.size();
  for(int i =0; i< hand_amount; i++){
  
  Handen current_hand = (Handen) objects_list.get(i);
  noFill();
  stroke(255);
  strokeWeight(35);
  background(0);
  int handSize = current_hand.giveSizeHand();
 ellipse(current_hand.givexpos(),current_hand.giveypos(),handSize,handSize);
  
  }
//    fill(rcolor_global, gcolor_global, bcolor_global);
//    ellipse(xpos_global, ypos_global, sizeb_global, sizeb_global);
//
//    fill(rcolor_global, gcolor_global, bcolor_global, 75);
//    ellipse(xpos_global, ypos_global, sizeb_global+20, sizeb_global+20);
//   fill(255);

if(sizeb>1000){
sizeb=0;
}

    //ellipse(mouseX,mouseY,200,200);
  }
  
  void drawHands(){
  
  println("draw hands werkt");
  }
}


