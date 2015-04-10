class Laag extends Layer {
int age;
import oscP5.*;
import netP5.*;

int sizeb =0;
int square_amount = 5;

float maxmice =0;
float maxmice_save;
float delaylevel;
int max_delay =150;
int mic_gevoeligheid= 1000;
int max_delaylevel = 200;
int r_background = round (random(255));
int g_background = round (random(255));
int b_background = round (random(255));
float maxmice_decrease = 20;


  Laag(PApplet parent) {
    super(parent);
  }

  void setup() {
    
    smooth();
    colorMode(HSB);
  }

  void draw() {
    
    sizeb+=90;
    background(0,0);
    noStroke();
    //fill(random(255));
    
   
   // rect(0,0,width/square_amount,height/((square_amount*height)/width));
    //rect(random(square_amount)*(width/square_amount),0,width/square_amount,height/((square_amount*height)/width));
    
    if (mic >maxmice) {


      float colorlevelr = map (mic, 0, 400, 0, r);
      float colorlevelg = map (mic, 0, 400, 0, g_);
      float colorlevelb = map (mic, 0, 400, 0, b);
      float strokelvel = map (mic, 0, mic_gevoeligheid, 0, 35);
      
      stroke(colorlevelr, colorlevelg, colorlevelb);
      strokeWeight(20);
      //line(0,255,width,height);
      strokeWeight(strokelvel);
      println("mic= "+mic);
      line(random(width), random(height), random(width), random(height));
      line(random(width), random(height), random(width), random(height));
      line(random(width), random(height), random(width), random(height));
      line(random(width), random(height), random(width), random(height));
      stroke(255, 0, 0);
      line(random(width), random(height), random(width), random(height));
      line(random(width), random(height), random(width), random(height));
      line(random(width), random(height), random(width), random(height));
      fill(255,0,0);
      rect(random(width), random(height),mic, mic);
      noFill();
      stroke(colorlevelr,colorlevelg,colorlevelb);
      ellipse(random(width), random(height), mic, mic);
      ellipse(random(width), random(height), mic, mic);
      ellipse(random(width), random(height), mic, mic);
      ellipse(random(width), random(height), mic, mic);
      fill(colorlevelr,colorlevelg,colorlevelb);
      ellipse(random(width), random(height), mic-100, mic-100);
      ellipse(random(width), random(height), mic-100, mic-100);
      ellipse(random(width), random(height), mic-100, mic-100);
      ellipse(random(width), random(height), mic-100, mic-100);
      ellipse(random(width), random(height), mic-100, mic-100);
      ellipse(random(width), random(height), mic-100, mic-100);
      //delay(10);
    
      
      if(mic >950){
      delay(100);
      }
      if(mic >800){
      background(colorlevelr,colorlevelg,colorlevelb);
      }
      //delay(10);
    }
    if (mic>maxmice) {
      maxmice = mic;
      println("maxmice new = "+maxmice+" maxmice old "+maxmice_save);
      if (maxmice > maxmice_save) {
        delaylevel = maxmice-maxmice_save;
      }
      println("delaylevel = "+ delaylevel);
      if (delaylevel>max_delaylevel) {
      

        fill(random(255),random(255),random(255));
        //rect(0,0,width,height);
        int  delaylevel_int = round(delaylevel);
        if (delaylevel_int >max_delay) {
          
         r_background = round (random(255));
         g_background = round (random(255));
         b_background = round (random(255));
         
         //background(r_background,g_background,b_background);
         delaylevel_int= max_delay;
        }
        delay(round(random(500,100)));
      }
        maxmice_save =maxmice;
    } 
    else {

      if (maxmice > 100) {
        maxmice -= maxmice_decrease;
        // println("");
        //println("range moet iets omlaag");
      }
    }
     
        
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
   print("i = "+i+"hand amount= "+hand_amount );  
      Handen current_hand = (Handen) objects_list.get(i);
      
       int handSize = current_hand.giveSizeHand();
       stroke(0,0,255);
       ellipse(current_hand.givexpos(),current_hand.giveypos(),handSize,handSize);
       ellipse(current_hand.givexpos()-10,current_hand.giveypos()-10,handSize,handSize);
      
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
  }
  
}


