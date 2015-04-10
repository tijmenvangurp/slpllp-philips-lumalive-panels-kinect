public final class Assignhanden {
  
  int startIsDone = 0;
  int nrBlobs;

  ArrayList xposObj;
  ArrayList yposObj;
  ArrayList sizeB;

  int nrObjects =0;
  int connectedBlob;
 
  // Constructor
  Assignhanden() {
    // maak nieuwe arraylist voor het aantal blobs wat er is
    xposObj = new ArrayList();
    yposObj = new ArrayList();
    sizeB = new ArrayList(); 
  }

  public final void makeObjects(int nrBlobs_, ArrayList xValues_, ArrayList yValues_, ArrayList xSizes_, ArrayList ySizes_) {
   
    int diffinNr = nrBlobs_ - nrObjects;
    if (diffinNr > 0) {
      // Mmore blobs than Objects, make more Objects
      for (int i=0; i < diffinNr; i++) {

        int current_xValue = (Integer) xValues_.get(i);
        int current_yValue = (Integer) yValues_.get(i);

        objects_list.add(new Handen(current_xValue, current_yValue));
      }
    } 
    else if (diffinNr < 0) {
      //less blobs than Objects, remove Objects
      for (int i=0; i < abs(diffinNr); i++) {
        objects_list.remove(objects_list.size()-1);
      }
    }
    nrObjects = objects_list.size();
    
    nrBlobs = nrBlobs_;
//    println("ik zie "+nrBlobs+" Handen");
//   println("number of blobs = "+nrBlobs_+" number of objects = "+nrObjects);

    drawObjects(nrBlobs, xValues_, yValues_, xSizes_, ySizes_);
//    println("xValues: "+xValues_);
//    println("yValues: "+yValues_);
//    println("xSizes: "+xSizes_);
//    println("ySizes: "+ySizes_);
    
    
    check_collision();
  }

  public final void drawObjects(int nrBlobs,ArrayList xValues_, ArrayList yValues_, ArrayList xSizes_, ArrayList ySizes_) {
    
    ArrayList storeBlobs;
   
    int hand_amount = xValues_.size();
//     println("nr of bolbs"+nrBlobs+"hand amount"+hand_amount);
    storeBlobs = new ArrayList();

    storeBlobs.clear();

    ConnectXblobject();
    ConnectYblobject();

    for ( int i = 0; i < nrBlobs+10; i++) {
      storeBlobs.add(0);
    }

    //    println("drawObjects uitgevoerd");
    //if(nrObjects != 0){
    for ( int i=0 ; i <(nrObjects); i++) { 
      Handen current_hand = (Handen) objects_list.get(i);
      //      if (nrObjects != xValues_.size()) {
      //        println(" BREAK BREAK ---------------------------------------------------------------------------");
      //        break;
      //      }
      //       for (int j= 0; j< blobAmount; j++) {
      if (nrBlobs != 0){
      int nearestBlob = mindistBlob(i, storeBlobs, xValues_ , yValues_);

//       println("nearestblob = "+nearestBlob);

        if (storeBlobs.size()!=0) {
          storeBlobs.remove(nearestBlob);

          storeBlobs.add(nearestBlob, 1);

          current_hand.display((Integer) xValues_.get(nearestBlob), (Integer) yValues_.get(nearestBlob), (Integer) xSizes_.get(nearestBlob), (Integer) ySizes_.get(nearestBlob), nrObjects);
          
        
          //      }
        }
      }
      

      
    }
    kinect1_handen=false;
    kinect2_handen=false;
    kinect3_handen=false;

    kinect1 = false;
    kinect2 = false;
    kinect3 = false;
    //}
  }

  void check_collision() {
    int ix, jx, iy, jy;
    int sizeB1;
    int sizeB2;
    xposObj.clear();
    yposObj.clear();
    sizeB.clear();


    for ( int i=0 ; i <nrObjects; i++) { 
      Handen currentObject = (Handen) objects_list.get(i);  

      xposObj.add(currentObject.givexpos());
      yposObj.add(currentObject.giveypos());
      sizeB.add(currentObject.sizeB());
      
    }


    for (int i =0; i < nrObjects ; i++) {

      for (int j =0; j < nrObjects ; j++) {
        ix = (Integer) xposObj.get(i);
        jx = (Integer) xposObj.get(j);
        iy = (Integer) yposObj.get(i);
        jy = (Integer) yposObj.get(j);
        
        sizeB1 = (Integer) sizeB.get(i);
        sizeB2 = (Integer) sizeB.get(j);
        
        collide_dist = (sizeB1/2)+(sizeB2/2);
        

        int distance = round( dist(ix, iy, jx, jy) );
        
        if ( i != j && distance <= collide_dist) {  //verander waarde om botsafstand te bepalen
          //botsing
          //i != j  kijt of die niet zichzelf heeft 
          // stelling van pythagoras
          // <= collide_dist) { collide_dist is global variable die aangeeft vanaf wanneer collide moet gebeuren
          Handen currentObject_1 = (Handen) objects_list.get(i);  
          Handen currentObject_2 = (Handen) objects_list.get(j);  

          // hier object.collide(); of object.explode(); etc
          currentObject_1.collide();
          currentObject_2.collide();
          //          println("Blob number "+i+" bumbed against blob number "+j);
          //          println("BOOOOOOOOOOOOOOOOOOOOOOOOTSSS");

          if (connect==2) {
            currentObject_1.connect(ix, iy, jx, jy);
          }

          if (connect!=2) {
            connect++;
          }
          else {
            connect-=3;
          }
        }
      }
    }
  }

  void ConnectXblobject() {
    xposObj.clear();
    for ( int i=0 ; i <objects_list.size(); i++) { 
      Handen current_object = (Handen) objects_list.get(i);  
      xposObj.add(current_object.givexpos());
    }
  }

  void ConnectYblobject() {
    yposObj.clear();
    for ( int i=0 ; i <objects_list.size(); i++) { 
      Handen currentObject = (Handen) objects_list.get(i);  
      yposObj.add(currentObject.giveypos());
    }
  }
  //  int mindistObject(int BlobID) {
  //
  //    int smallestdist = 10000;
  //    // for this BLoB ID, get the xValue of the BLob
  //    int xValueBlob  = (Integer) xValues.get(BlobID);
  //    //and the y value of the blob
  //    int yValueBlob  = (Integer) yValues.get(BlobID);
  //    // check distance between current blob and all objects
  //    for (int i = 0; i < nrObjects ; i++) {
  //      int xValueObject = (Integer) xposObj.get(i);
  //      int yValueObject = (Integer) yposObj.get(i);
  //
  //
  //      int distance = round(dist(xValueBlob, yValueBlob, xValueObject, yValueObject));
  //
  //      if (distance <= smallestdist) {
  //        smallestdist = distance;
  //        connectedobject = i;
  //      }
  //    }
  //
  //    // return the object wich is closets to the blob
  //    return (int) connectedobject;
  //  }  
  int mindistBlob(int ObjectID, ArrayList ConnectedBlobs, ArrayList xValues_, ArrayList yValues_) {
    //println("number of blobs = "+ConnectedBlobs.size()+" number of objects = "+xposObj.size());
//println("ObjectID"+ObjectID);
    int smallestdist = 100000;
    // for this Object ID, get the xValue of the Objec
    int xValueObject = (Integer) xposObj.get(ObjectID);
    //and the y value of the blob

    int yValueObject = (Integer) yposObj.get(ObjectID);
    // check distance between current Object and all Blobs(people)
    if (nrBlobs>=0) {

      for (int i = 0; i < nrBlobs ; i++) {
//        println("xValues handen"+xValues_handen);
        int yValueBlob  = (Integer) yValues_.get(i);
        int xValueBlob  = (Integer) xValues_.get(i);
//        println("connected blobs amount ="+ConnectedBlobs.size());
        int connectedblobi = (Integer) ConnectedBlobs.get(i);

        int distance = round(dist(xValueBlob, yValueBlob, xValueObject, yValueObject));
        if (distance <= smallestdist && connectedblobi==0) {
          smallestdist = distance;
          connectedBlob = i;
        }
      }
    }
    else {
      connectedBlob =  10000;
    }
    // return the object wich is closets to the blob
    return (int) connectedBlob;
  }
}

