

//-------------------------------------------------------------------
//OSC
import com.nootropic.processing.layers.*;
AppletLayers layers;
Laag laag1;

import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;

PImage lightning;

// Objecten 
ArrayList xValues ;
ArrayList yValues ;
ArrayList xSizes ;
ArrayList ySizes ;
Assignobjects Assignobjects_;

// Handen
ArrayList<Handen> objects_list;
ArrayList xValues_handen ;
ArrayList yValues_handen ;
ArrayList xSizes_handen ;
ArrayList ySizes_handen ;

Assignhanden Assignhanden_;

float r =255;
float g_ =255;
float b = 255;
//mic
float mic;

// Kinect
int nrKinect1= 0;
int nrKinect1_handen= 0;
int nrKinect2= 0;
int nrKinect2_handen= 0;
int nrKinect3= 0;
int nrKinect3_handen= 0;

boolean kinect1 =false;
boolean kinect1_handen =false;
boolean kinect2= false;
boolean kinect2_handen =false;
boolean kinect3= false;
boolean kinect3_handen =false;

int collide_dist;
int minBlobSize = 30;
int minHandSize = 10;
int connect;

float alph=0;

float xpos_global;
float ypos_global;
float sizeb_global;


public void setup() {
  objects_list = new ArrayList();
  size(1600, 725);
  background(0);
  
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);
  
  xValues = new ArrayList();
  yValues = new ArrayList();
  xSizes = new ArrayList();
  ySizes = new ArrayList();
  
  xValues_handen = new ArrayList();
  yValues_handen = new ArrayList();
  xSizes_handen = new ArrayList();
  ySizes_handen = new ArrayList();
  
  Assignobjects_ = new Assignobjects();
  Assignhanden_ = new Assignhanden();
  
  layers = new AppletLayers(this);
  Laag laag1 = new Laag(this);
  layers.addLayer(laag1);
}


public void draw() {
  fill(0, 0);
  //background(0,0);
  rect(0, 0, width, height);
  
  if (kinect1 == true && kinect2 == true && kinect3 == true) {
    int nrBlobs = (xValues.size());
  
  try {
     //Assignobjects_.makeObjects(nrBlobs, xValues,yValues, xSizes, ySizes);
     
   }
   catch(IndexOutOfBoundsException e) { 
      println("An error occurred in assignobjects");
  }
  //    Assignobjects_.check_collision();

    xValues.clear();
    yValues.clear();

    xSizes.clear();
    ySizes.clear();
    
    kinect1=false;
    kinect2=false;
    kinect3=false;
  }
  
}

void oscEvent(OscMessage theOscMessage) {
  nrKinect1= 0;
  nrKinect1_handen= 0;
  nrKinect2= 0;
  nrKinect2_handen= 0;
  nrKinect3= 0; 
  nrKinect3_handen= 0;

  if (theOscMessage.checkAddrPattern("/kinect_1")==true) {

    int blob_amount =(theOscMessage.get(0).intValue());
    if(kinect1 == false){
      if (blob_amount == 0) {
        // println(" kinect 1 is true because there are no blobs");
        kinect1 = true;
      }
    }      

    if (blob_amount >= 1) {
      //kijken of er blobs zijn dan pas voor aantal blobs wat er zijn ID Xsize Ysize X en Y ophalen
      nrKinect1= blob_amount;

      for (int i = 1; i <= blob_amount*5; i += 5) {
        // println("blobamount *5 = "+blob_amount*5);
        // println("number of blobs = "+blob_amount);
        int blob_id =(theOscMessage.get(i).intValue());
        // println("Blob ID = "+blob_id);

        int blob_Xsize =(theOscMessage.get(i+1).intValue());
        //println("blob_Xsize = "+blob_Xsize);

        int blob_Ysize =(theOscMessage.get(i+2).intValue());
        //println("blob_Ysize = "+blob_Ysize);
       
        float blob_xf = (533.333-((theOscMessage.get(i+3).intValue())/1.27))+1180;
        // println("blob_x = "+blob_x);
        int blob_x_ = round(blob_xf);
        float blob_yf = height -((theOscMessage.get(i+4).intValue())*1.515);
        int blob_y_ = round(blob_yf);
       
        //  kinect 1 hokje linksboven
        if (blob_x_ >=1140 && blob_x_ <= 1260 && blob_y_ >= 210 && blob_y_ <= 335) {
          blob_x_ = 1140;
        }

        //  kinect 1 hokje rechtsboven
        if (blob_x_ >=1260 && blob_x_ <= 1380 && blob_y_ >= 210 && blob_y_ <= 335) {
          blob_y_ = 210;
        }

        //  kinect 1 hokje linksonder
        if (blob_x_ >=1140 && blob_x_ <= 1260 && blob_y_ >= 335 && blob_y_ <= 460) {
          blob_y_ = 460;
        }

        //  kinect 1 hokje rechtsonder
        if (blob_x_ >=1260 && blob_x_ <= 1380 && blob_y_ >= 335 && blob_y_ <= 460) {
          blob_x_ = 1380;
        }
       
        int blob_x = round(blob_x_);
        int blob_y = round(blob_y_);
//        println("blob x = "+blob_x);
//        println("blob y = "+blob_y);
        if (!kinect1) {
          
          if (blob_Xsize > minBlobSize) {
            // println("kinect 1 added blobs");
            ySizes.add(blob_Ysize);
            xValues.add(blob_x);
            yValues.add(blob_y);
            xSizes.add(blob_Xsize);
          }
          
          if (i == blob_amount || ((i-1)/5)+1 == blob_amount) {
            kinect1 = true;
           // println("Kinect 1 = true because there where "+xValues.size()+" blobs");
          }
        }
      }
    }
  }


  if (theOscMessage.checkAddrPattern("/kinect_2")==true) {
  


    //println("kinect 1 is true"); 

    // println("Kinect number _1_ is sending you a message!!");      
    // kijkt of er messages van Kinect nummer 1 doorkomen
    //println("id message komt door");
    int blob_amount =(theOscMessage.get(0).intValue());
    //    println("blob amount" +blob_amount);
    if(kinect2 == false){
    if (blob_amount == 0) {
//      println(" kinect 2 is true because there are no blobs");
      kinect2 = true;
    }}      

    if (blob_amount >= 1) {
      //kijken of er blobs zijn dan pas voor aantal blobs wat er zijn ID Xsize Ysize X en Y ophalen

      nrKinect2= blob_amount;

      for (int i = 1; i <= blob_amount*5; i += 5) {
        //        println("blobamount *5 = "+blob_amount*5);
        // println("number of blobs = "+blob_amount);
        int blob_id =(theOscMessage.get(i).intValue());
        // println("Blob ID = "+blob_id);

        int blob_Xsize =(theOscMessage.get(i+1).intValue());
        //println("blob_Xsize = "+blob_Xsize);

        int blob_Ysize =(theOscMessage.get(i+2).intValue());
        //println("blob_Ysize = "+blob_Ysize);

        float blob_xf = (533.333-((theOscMessage.get(i+3).intValue())/1.27))+640;
        int blob_x_ = round(blob_xf);
        
//         println("ruwe xvalue = "+theOscMessage.get(i+3).intValue());
//        println("ruwe yvalue = "+theOscMessage.get(i+4).intValue());
        // println("blob_x = "+blob_x);

        float blob_yf = height -(((theOscMessage.get(i+4).intValue()))*1.515);
                int blob_y_ = round(blob_yf);
        //  kinect 2 hokje linksboven
        if (blob_x_ >=695 && blob_x_ <= 815 && blob_y_ >= 210 && blob_y_ <= 335) {
          blob_y_ = 210;
        }

        //  kinect 2 hokje rechtsboven
        if (blob_x_ >=815 && blob_x_ <= 935 && blob_y_ >= 210 && blob_y_ <= 335) {
          blob_x_ = 935;
        }

        //  kinect 2 hokje linksonder
        if (blob_x_ >=695 && blob_x_ <= 815 && blob_y_ >= 335 && blob_y_ <= 460) {
          blob_x_ = 695;
        }

        //  kinect 2 hokje rechtsonder
        if (blob_x_ >=815 && blob_x_ <= 935 && blob_y_ >= 335 && blob_y_ <= 460) {
          blob_y_ = 460;
        }
        
        int blob_x = round(blob_x_);
        int blob_y = round(blob_y_);
        
        if (!kinect2) {
          if (blob_Xsize > minBlobSize) { 
//    println("kinect 1 added blobs");        
            ySizes.add(blob_Ysize);
            xValues.add(blob_x);
            yValues.add(blob_y);
            xSizes.add(blob_Xsize);
          }
          if (i == blob_amount || ((i-1)/5)+1 == blob_amount) {
            kinect2 = true;
//            println("Kinect 2 = true because there where "+xValues.size()+" blobs");
          }
        }
      }
    }
  }



  if (theOscMessage.checkAddrPattern("/kinect_3")==true) {
//     println(" typetag: "+theOscMessage.typetag()); // typetag gets if it is a float or an int

    //println("kinect 1 is true"); 

    // println("Kinect number _1_ is sending you a message!!");      
    // kijkt of er messages van Kinect nummer 1 doorkomen
    //println("id message komt door");
    int blob_amount =(theOscMessage.get(0).intValue());
    //    println("blob amount" +blob_amount);
    if(kinect3 == false){
    if (blob_amount == 0) {
//      println(" kinect 3 is true because there are no blobs");
      kinect3 = true;
    } }     

    if (blob_amount >= 1) {
      //kijken of er blobs zijn dan pas voor aantal blobs wat er zijn ID Xsize Ysize X en Y ophalen

      nrKinect3= blob_amount;

      for (int i = 1; i <= blob_amount*5; i += 5) {
        //        println("blobamount *5 = "+blob_amount*5);
        // println("number of blobs = "+blob_amount);
        int blob_id =(theOscMessage.get(i).intValue());
        // println("Blob ID = "+blob_id);

        int blob_Xsize =(theOscMessage.get(i+1).intValue());
        //println("blob_Xsize = "+blob_Xsize);

        int blob_Ysize =(theOscMessage.get(i+2).intValue());
        //println("blob_Ysize = "+blob_Ysize);

        float blob_xf = (533.333-((theOscMessage.get(i+3).intValue())/1.27));
        int blob_x_ = round(blob_xf);
        // println("blob_x = "+blob_x);

        float blob_yf = height -(((theOscMessage.get(i+4).intValue()))*1.515);
        int blob_y_ = round(blob_yf);
       //  kinect 3 hokje linksboven
   //  kinect 3 hokje linksboven
        if (blob_x_ >=215 && blob_x_ <= 335 && blob_y_ >= 210 && blob_y_ <= 335) {
          blob_x_ = 215;
        }

        //  kinect 3 hokje rechtsboven
        if (blob_x_ >=335 && blob_x_ <= 455 && blob_y_ >= 210 && blob_y_ <= 335) {
          blob_y_ = 210;
        }

        //  kinect 3 hokje linksonder
        if (blob_x_ >=215 && blob_x_ <= 335 && blob_y_ >= 335 && blob_y_ <= 460) {
          blob_y_ = 460;
        }

        //  kinect 3 hokje rechtsonder
        if (blob_x_ >=335 && blob_x_ <= 455 && blob_y_ >= 335 && blob_y_ <= 460) {
          blob_x_ = 455;
        }


        int blob_x = round(blob_x_);
        int blob_y = round(blob_y_);
        
 
        
        if (!kinect3) {
          if (blob_Xsize > minBlobSize) { 
//            println("kinect 3 added blobs");        
            ySizes.add(blob_Ysize);
            xValues.add(blob_x);
            yValues.add(blob_y);
            xSizes.add(blob_Xsize);
          }
          if (i == blob_amount || ((i-1)/5)+1 == blob_amount) {
            kinect3 = true;
//            println("Kinect 3 = true because there where "+xValues.size()+"  blobs");
          }
        }
      }
    }
  }
  //--------------------------------------------------------------HANDEN
  
    if (theOscMessage.checkAddrPattern("/kinect_3_handen")==true) {
   //    println(" addrpattern: "+theOscMessage.addrPattern()); 
 // println(" typetag: "+theOscMessage.typetag()); // typetag gets if it is a float or an int
  //with if(theOscMessage.checkTypetag("i")) you cab check if it is an int what you recieve, an f for float

    
   //  println("Kinect number _1_handen is sending you a message!!");   // kijkt of er messages van Kinect nummer 1 doorkomen
    //println("id message komt door");
    int hand_amount = theOscMessage.get(0).intValue();
       //println("hand amount" +hand_amount);
    if(kinect3_handen == false){

    if (hand_amount == 0) {
     //println(" kinect 3 handen is true because there are no blobs");

      kinect3_handen = true;
    } }     

    if (hand_amount >= 1) {
      //kijken of er blobs zijn dan pas voor aantal blobs wat er zijn ID Xsize Ysize X en Y ophalen

      nrKinect3_handen = hand_amount;

      for (int i = 1; i <= hand_amount*5; i += 5) {
        // println("blobamount *5 = "+blob_amount*5);
        // println("number of blobs = "+blob_amount);
        int hand_id =(theOscMessage.get(i).intValue());
        // println("Blob ID = "+blob_id);

        int hand_Xsize =(theOscMessage.get(i+1).intValue());
        //println("blob_Xsize = "+blob_Xsize);

        int hand_Ysize =(theOscMessage.get(i+2).intValue());
        //println("blob_Ysize = "+blob_Ysize);

        float hand_xf = (533.333-((theOscMessage.get(i+3).intValue())/1.27));
        int hand_x_ = round(hand_xf);
        // println("blob_x = "+blob_x);

        float hand_yf = height -(((theOscMessage.get(i+4).intValue()))*1.515);
        int hand_y_ = round(hand_yf);
        
       
       
//   //  kinect 3 hokje linksboven
//        if (blob_x_ >=215 && blob_x_ <= 335 && blob_y_ >= 210 && blob_y_ <= 335) {
//          blob_x_ = 215;
//        }
//
//        //  kinect 3 hokje rechtsboven
//        if (blob_x_ >=335 && blob_x_ <= 455 && blob_y_ >= 210 && blob_y_ <= 335) {
//          blob_y_ = 210;
//        }
//
//        //  kinect 3 hokje linksonder
//        if (blob_x_ >=215 && blob_x_ <= 335 && blob_y_ >= 335 && blob_y_ <= 460) {
//          blob_y_ = 460;
//        }
//
//        //  kinect 3 hokje rechtsonder
//        if (blob_x_ >=335 && blob_x_ <= 455 && blob_y_ >= 335 && blob_y_ <= 460) {
//          blob_x_ = 455;
//        }


        int hand_x = round(hand_x_);
        int hand_y = round(hand_y_);
        
 
        
        if (!kinect3_handen) {
          if (hand_Xsize > minHandSize) { 
//            println("kinect 3 added blobs");        
            ySizes_handen.add(hand_Ysize);
            xValues_handen.add(hand_x);
            yValues_handen.add(hand_y);
            xSizes_handen.add(hand_Xsize);
          }
          if (i == hand_amount || ((i-1)/5)+1 == hand_amount) {
            
            kinect3_handen = true;
           //println("Kinect 3_ handen = true because there where "+xValues.size()+"  blobs");
          }
        }
      }
    }   
    
  }
   if (theOscMessage.checkAddrPattern("/kinect_2_handen")==true) {
   //    println(" addrpattern: "+theOscMessage.addrPattern()); 
 // println(" typetag: "+theOscMessage.typetag()); // typetag gets if it is a float or an int
  //with if(theOscMessage.checkTypetag("i")) you cab check if it is an int what you recieve, an f for float

    //println("kinect 1 is true"); 

   //  println("Kinect number _1_handen is sending you a message!!");   // kijkt of er messages van Kinect nummer 1 doorkomen
    //println("id message komt door");
    int hand_amount = theOscMessage.get(0).intValue();
       //println("" +hand_amount);
    if(kinect2_handen == false){
    if (hand_amount == 0) {
  //println(" kinect 2  handen is true because there are no blobs");
      kinect2_handen = true;
    } }     

    if (hand_amount >= 1) {
      //kijken of er blobs zijn dan pas voor aantal blobs wat er zijn ID Xsize Ysize X en Y ophalen

      nrKinect2_handen = hand_amount;

      for (int i = 1; i <= hand_amount*5; i += 5) {
        // println("blobamount *5 = "+blob_amount*5);
        // println("number of blobs = "+blob_amount);
        int hand_id =(theOscMessage.get(i).intValue());
        // println("Blob ID = "+blob_id);

        int hand_Xsize =(theOscMessage.get(i+1).intValue());
        //println("blob_Xsize = "+blob_Xsize);

        int hand_Ysize =(theOscMessage.get(i+2).intValue());
        //println("blob_Ysize = "+blob_Ysize);

        float hand_xf = (533.333-((theOscMessage.get(i+3).intValue())/1.27))+640;
        int hand_x_ = round(hand_xf);
        // println("blob_x = "+blob_x);

        float hand_yf = height -(((theOscMessage.get(i+4).intValue()))*1.515);
        int hand_y_ = round(hand_yf);
        
       
       
//   //  kinect 3 hokje linksboven
//        if (blob_x_ >=215 && blob_x_ <= 335 && blob_y_ >= 210 && blob_y_ <= 335) {
//          blob_x_ = 215;
//        }
//
//        //  kinect 3 hokje rechtsboven
//        if (blob_x_ >=335 && blob_x_ <= 455 && blob_y_ >= 210 && blob_y_ <= 335) {
//          blob_y_ = 210;
//        }
//
//        //  kinect 3 hokje linksonder
//        if (blob_x_ >=215 && blob_x_ <= 335 && blob_y_ >= 335 && blob_y_ <= 460) {
//          blob_y_ = 460;
//        }
//
//        //  kinect 3 hokje rechtsonder
//        if (blob_x_ >=335 && blob_x_ <= 455 && blob_y_ >= 335 && blob_y_ <= 460) {
//          blob_x_ = 455;
//        }


        int hand_x = round(hand_x_);
        int hand_y = round(hand_y_);
        
 
        
        if (!kinect2_handen) {
          if (hand_Xsize > minHandSize) { 
//            println("kinect 3 added blobs");        
            ySizes_handen.add(hand_Ysize);
            xValues_handen.add(hand_x);
            yValues_handen.add(hand_y);
            xSizes_handen.add(hand_Xsize);
          }
          if (i == hand_amount || ((i-1)/5)+1 == hand_amount) {
            kinect2_handen = true;
         //println("Kinect 2 handen = true because there where "+xValues.size()+"  blobs");
          }
        }
      }
    }   
    
  }
   if (theOscMessage.checkAddrPattern("/kinect_1_handen")==true) {
   //    println(" addrpattern: "+theOscMessage.addrPattern()); 
 // println(" typetag: "+theOscMessage.typetag()); // typetag gets if it is a float or an int
  //with if(theOscMessage.checkTypetag("i")) you cab check if it is an int what you recieve, an f for float

    //println("kinect 1 is true"); 

   //  println("Kinect number _1_handen is sending you a message!!");   // kijkt of er messages van Kinect nummer 1 doorkomen
    //println("id message komt door");
    int hand_amount = theOscMessage.get(0).intValue();
      // println("hand amount" +hand_amount);
    if(kinect1_handen == false){
    if (hand_amount == 0) {
     //println(" kinect 1 handen is true because there are no blobs");
      kinect1_handen = true;
    } }     

    if (hand_amount >= 1) {
      //kijken of er blobs zijn dan pas voor aantal blobs wat er zijn ID Xsize Ysize X en Y ophalen

      nrKinect1_handen = hand_amount;

      for (int i = 1; i <= hand_amount*5; i += 5) {
        // println("blobamount *5 = "+blob_amount*5);
        // println("number of blobs = "+blob_amount);
        int hand_id =(theOscMessage.get(i).intValue());
        // println("Blob ID = "+blob_id);

        int hand_Xsize =(theOscMessage.get(i+1).intValue());
        //println("blob_Xsize = "+blob_Xsize);

        int hand_Ysize =(theOscMessage.get(i+2).intValue());
        //println("blob_Ysize = "+blob_Ysize);

        float hand_xf = (533.333-((theOscMessage.get(i+3).intValue())/1.27))+1180;
        int hand_x_ = round(hand_xf);
        // println("blob_x = "+blob_x);

        float hand_yf = height -(((theOscMessage.get(i+4).intValue()))*1.515);
        int hand_y_ = round(hand_yf);
        
       
       
//   //  kinect 3 hokje linksboven
//        if (blob_x_ >=215 && blob_x_ <= 335 && blob_y_ >= 210 && blob_y_ <= 335) {
//          blob_x_ = 215;
//        }
//
//        //  kinect 3 hokje rechtsboven
//        if (blob_x_ >=335 && blob_x_ <= 455 && blob_y_ >= 210 && blob_y_ <= 335) {
//          blob_y_ = 210;
//        }
//
//        //  kinect 3 hokje linksonder
//        if (blob_x_ >=215 && blob_x_ <= 335 && blob_y_ >= 335 && blob_y_ <= 460) {
//          blob_y_ = 460;
//        }
//
//        //  kinect 3 hokje rechtsonder
//        if (blob_x_ >=335 && blob_x_ <= 455 && blob_y_ >= 335 && blob_y_ <= 460) {
//          blob_x_ = 455;
//        }


        int hand_x = round(hand_x_);
        int hand_y = round(hand_y_);
        
 
        
        if (!kinect1_handen) {
          if (hand_Xsize > minHandSize) { 
//            println("kinect 3 added blobs");        
            ySizes_handen.add(hand_Ysize);
            xValues_handen.add(hand_x);
            yValues_handen.add(hand_y);
            xSizes_handen.add(hand_Xsize);
          }
          if (i == hand_amount || ((i-1)/5)+1 == hand_amount) {
            kinect1_handen = true;
           //println("Kinect 1 handen = true because there where "+xValues.size()+"  blobs");
          }
        }
      }
    }   
    
  }
  if (theOscMessage.checkAddrPattern("/microphone")==true) {
     mic =(theOscMessage.get(0).floatValue());
     //println(mic);
    }
    if (theOscMessage.checkAddrPattern("/r")==true) {
    r = theOscMessage.get(0).floatValue();
    println("r= "+r);
  }
  if (theOscMessage.checkAddrPattern("/g")==true) {
    g_ = theOscMessage.get(0).floatValue();
    println("g= "+g_);
  }
  if (theOscMessage.checkAddrPattern("/b")==true) {
    b = theOscMessage.get(0).floatValue();
    println("b= "+b);
}
}

// if(xSize > minBlobSize && ySize > minBlobSize){ hier nog checken of blob groot genoeg is voor de .add
void paint(java.awt.Graphics g) {
  if (layers != null) {
    layers.paint(this);
  } 
  else {
    super.paint(g);
  }
}

