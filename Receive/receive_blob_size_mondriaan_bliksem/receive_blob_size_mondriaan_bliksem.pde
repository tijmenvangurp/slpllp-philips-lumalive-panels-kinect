

//-------------------------------------------------------------------
//OSC
import oscP5.*;
import netP5.*;
      PImage lightning;

OscP5 oscP5;
NetAddress myRemoteLocation;
ArrayList xValues ;
ArrayList yValues ;
ArrayList xSizes ;
ArrayList ySizes ;
Assignobjects Assignobjects_;

int nrKinect1= 0;
int nrKinect2= 0;
int nrKinect3= 0;

boolean kinect1 =false;
boolean kinect2= false;
boolean kinect3= false;
int collide_dist;
int minBlobSize = 30;
int connect;
float alph=0;

public void setup() {
  size(1600, 725);
  background(0);
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this, 12000);
  xValues = new ArrayList();
  yValues = new ArrayList();
  xSizes = new ArrayList();
  ySizes = new ArrayList();
  Assignobjects_ = new Assignobjects();
}



public void draw() {
  fill(0, 20);
  rect(0, 0, width, height);
  if (kinect1 == true &&  kinect2 == true &&  kinect3 == true) {
    int nrBlobs = (xValues.size());
    //    println("number of blobs  "+nrBlobs);
    // int nrBlobs = (nrKinect1 + nrKinect2 + nrKinect3);
    //println("nr of blobs in de void draw loop ="+nrBlobs);


    try {
      Assignobjects_.makeObjects(nrBlobs, xValues,yValues, xSizes, ySizes);
//      Assignobjects_.drawObjects();
    }
    catch(IndexOutOfBoundsException e) { 
      println("An error occurred");
    }
//    Assignobjects_.check_collision();

    xValues.clear();
    yValues.clear();

    xSizes.clear();
    ySizes.clear();
//println("all kinects where true RESET---------------------------");
    kinect1=false;
    kinect2=false;
    kinect3=false;
  }
}

void oscEvent(OscMessage theOscMessage) {
  //print(" addrpattern: "+theOscMessage.addrPattern()); 
  //print(" typetag: "+theOscMessage.typetag()); // typetag gets if it is a float or an int
  //with if(theOscMessage.checkTypetag("i")) you cab check if it is an int what you recieve, an f for float


  nrKinect1= 0;
  nrKinect2= 0;
  nrKinect3= 0;

  //println("osc event werkt kinect1 ="+kinect1);


  if (theOscMessage.checkAddrPattern("/kinect_1")==true) {

    //println("kinect 1 is true"); 

    // println("Kinect number _1_ is sending you a message!!");      
    // kijkt of er messages van Kinect nummer 1 doorkomen
    //println("id message komt door");
    int blob_amount =(theOscMessage.get(0).intValue());
      //  println("blob amount" +blob_amount);
      //blob amount is 0 when there are no blobs
      if(kinect1 == false){
    if (blob_amount == 0) {
//    println(" kinect 1 is true because there are no blobs");
      kinect1 = true;
    }}      

    if (blob_amount >= 1) {
      //kijken of er blobs zijn dan pas voor aantal blobs wat er zijn ID Xsize Ysize X en Y ophalen

      nrKinect1= blob_amount;

      for (int i = 1; i <= blob_amount*5; i += 5) {
        //        println("blobamount *5 = "+blob_amount*5);
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
       
//        //  kinect 1 hokje linksboven
//        if (blob_x_ >=1140 && blob_x_ <= 1260 && blob_y_ >= 210 && blob_y_ <= 335) {
//          blob_x_ = 1140;
//        }
//
//        //  kinect 1 hokje rechtsboven
//        if (blob_x_ >=1260 && blob_x_ <= 1380 && blob_y_ >= 210 && blob_y_ <= 335) {
//          blob_y_ = 210;
//        }
//
//        //  kinect 1 hokje linksonder
//        if (blob_x_ >=1140 && blob_x_ <= 1260 && blob_y_ >= 335 && blob_y_ <= 460) {
//          blob_y_ = 460;
//        }
//
//        //  kinect 1 hokje rechtsonder
//        if (blob_x_ >=1260 && blob_x_ <= 1380 && blob_y_ >= 335 && blob_y_ <= 460) {
//          blob_x_ = 1380;
//        }
       
        int blob_x = round(blob_x_);
        int blob_y = round(blob_y_);
//        println("blob x = "+blob_x);
//        println("blob y = "+blob_y);
        if (!kinect1) {
          
          if (blob_Xsize > minBlobSize) {
//            println("kinect 1 added blobs");
            ySizes.add(blob_Ysize);
            xValues.add(blob_x);
            yValues.add(blob_y);
            xSizes.add(blob_Xsize);
          }
          if (i == blob_amount || ((i-1)/5)+1 == blob_amount) {
            kinect1 = true;
//            println("Kinect 1 = true because there where "+xValues.size()+" blobs");
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
        
         println("ruwe xvalue = "+theOscMessage.get(i+3).intValue());
        println("ruwe yvalue = "+theOscMessage.get(i+4).intValue());
        // println("blob_x = "+blob_x);

        float blob_yf = height -(((theOscMessage.get(i+4).intValue()))*1.515);
                int blob_y_ = round(blob_yf);
//        //  kinect 2 hokje linksboven
//        if (blob_x_ >=695 && blob_x_ <= 815 && blob_y_ >= 210 && blob_y_ <= 335) {
//          blob_y_ = 210;
//        }
//
//        //  kinect 2 hokje rechtsboven
//        if (blob_x_ >=815 && blob_x_ <= 935 && blob_y_ >= 210 && blob_y_ <= 335) {
//          blob_x_ = 935;
//        }
//
//        //  kinect 2 hokje linksonder
//        if (blob_x_ >=695 && blob_x_ <= 815 && blob_y_ >= 335 && blob_y_ <= 460) {
//          blob_x_ = 695;
//        }
//
//        //  kinect 2 hokje rechtsonder
//        if (blob_x_ >=815 && blob_x_ <= 935 && blob_y_ >= 335 && blob_y_ <= 460) {
//          blob_y_ = 460;
//        }
        
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
}


// if(xSize > minBlobSize && ySize > minBlobSize){ hier nog checken of blob groot genoeg is voor de .add


