class Laag extends Layer {
int age;
import oscP5.*;
import netP5.*;

int sizeb =0;
  Laag(PApplet parent) {
    super(parent);
  }


Minim minim;
AudioInput in;
float xm=0;
float ym=0;
int maxmice_counter =0;
float micLevel=0;
float microphone;
float maxmice_save;
float delaylevel;
int max_delay =50;
float maxmice =0;
import ddf.minim.*;

import oscP5.*;
import netP5.*;
OscP5 oscP5;




  void setup() {
    
    smooth();
    colorMode(HSB);
    
    minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 256);
  
   oscP5 = new OscP5(this, 8001);
  }

  void draw() {
    sizeb+=90;
    background(0,0);
        
    if (kinect1_handen == true && kinect2_handen == true && kinect3_handen == true) {
     
    int nrBlobs_handen = (xValues_handen.size());
    // println("number of blobs  "+nrBlobs);
    // int nrBlobs = (nrKinect1 + nrKinect2 + nrKinect3);
    // println("nr of blobs in de void draw loop ="+nrBlobs);
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
  
    kinect1_handen=false;
    kinect2_handen=false;
    kinect3_handen=false; //---
    
  }
  
 int hand_amount = objects_list.size();
  noFill();
      stroke(255);
      strokeWeight(35);
   for(int i = 0; i < hand_amount; i++){
//   print("i = "+i+"hand amount= "+hand_amount );  
      Handen current_hand = (Handen) objects_list.get(i);
      
       int handSize = current_hand.giveSizeHand();
       ellipse(current_hand.givexpos(),current_hand.giveypos(),handSize,handSize);
      
      if(hand_amount > 1&& i< hand_amount-1){
      Handen current_hand2 = (Handen) objects_list.get(i+1);
     
      line(current_hand.givexpos(),current_hand.giveypos(),current_hand2.givexpos(),current_hand2.giveypos());
      
      }
  }
 
  
  
//    fill(rcolor_global, gcolor_global, bcolor_global);
//    ellipse(xpos_global, ypos_global, sizeb_global, sizeb_global);
//
//    fill(rcolor_global, gcolor_global, bcolor_global, 75);
//    ellipse(xpos_global, ypos_global, sizeb_global+20, sizeb_global+20);
//    fill(255);

  if(sizeb>1000){
    sizeb=0;
  }
    //ellipse(mouseX,mouseY,200,200);
  
  
  
    xm+=random(10);
  ym+=random(10);
  if (xm>width ||ym>height) {
    xm = random(width);
    ym = random(height);
  }
  for (int i=0; i<256;i++) {

    float microphone=abs(in.left.get(i)*255);
    noStroke();
    smooth();
    if (microphone > micLevel) {
      fill(255, 255, 255);
      //ellipse(random(x,x+30),random(y,y+30),microphone,microphone);
      fill(255, 0, 0);
      //ellipse(random(x,x+30),random(y,y+30),microphone,microphone);
      fill(255, 255, 255);
      //
    }

    if (microphone >maxmice-10) {


      float colorlevel = map (microphone, 0, 255, 0, 255);
      float strokelvel = map (microphone, 0, 255, 0, 50);
      stroke(colorlevel, 255, 0);
      strokeWeight(20);
      //line(0,255,width,height);
      strokeWeight(strokelvel);
      line(random(width), random(height), random(width), random(height));
      noFill();
      stroke(colorlevel);
      ellipse(random(width), random(height), microphone, microphone);
      //delay(10);
    }


    if (microphone>maxmice) {
      maxmice = microphone;
      println("maxmice new = "+maxmice+" maxmice old "+maxmice_save);
      if (maxmice > maxmice_save) {
        delaylevel = maxmice-maxmice_save;
      }
      println("delaylevel = "+ delaylevel);
      if (delaylevel>100) {
        int  delaylevel_int = round(delaylevel);
        if (delaylevel_int >max_delay) {
          delaylevel_int= max_delay;
        }
        delay(delaylevel_int*2);
      }
      maxmice_save =maxmice;
    } 
    else {

      if (maxmice > 30) {
        maxmice -=6;
        // println("");
        //println("range moet iets omlaag");
      }
      // counter for how long microphone was not maxmice
    }
    if (i >50) {
      break;
    }
    //println("microphone =" +microphone);
    //println("maxmice =" +maxmice);
  }
  //delay(10);
  }
  
}

//void oscEvent(OscMessage theOscMessage) {
//
//
//
//  if (theOscMessage.checkAddrPattern("/mic")==true) {
//    micLevel = theOscMessage.get(0).floatValue();
//    println("miclevel= "+micLevel);
//  }
//}
