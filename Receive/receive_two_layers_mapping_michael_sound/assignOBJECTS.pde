public final class Assignobjects {
  int nrEndlessObjects = 0;
  int startIsDone = 0;
  int nrBlobs;

  int rcolor;
  int gcolor;
  int bcolor;

  ArrayList<Objects> objects_list;
  ArrayList xposObj;
  ArrayList yposObj;
    ArrayList sizeB;

  int nrObjects =0;

  int connectedobject;
  int connectedBlob;

  //constructor
  Assignobjects() {
    objects_list = new ArrayList();
    xposObj = new ArrayList();
    yposObj = new ArrayList();
    sizeB = new ArrayList();
    //maak nieuwe arraylist voor het aantal blobs wat er is
  }

  public final void makeObjects(int nrBlobs_, ArrayList xValues_, ArrayList yValues_, ArrayList xSizes_, ArrayList ySizes_) {
    //make endless objects only once:
    if (startIsDone == 0) {
      for (int i=1; i<=nrEndlessObjects; i++) {
        int endlessX = (int) random(width);
        int endlessY = (int) random(height);
        objects_list.add(new Objects(endlessX, endlessY));
        println("endlesobject"+i);
      }
      startIsDone=1;
    }
    nrObjects = objects_list.size();
    //println("makeobjects");

    int diffinNr = (nrBlobs_+nrEndlessObjects) - nrObjects;
    if (diffinNr > 0) {
      //more blobs than Objects, make more Objects
      for (int i=0; i < diffinNr; i++) {

        int listsizex = nrObjects-nrEndlessObjects;
        int listsizey = nrObjects-nrEndlessObjects;

        int current_xValue = (Integer) xValues_.get(listsizex);
        int current_yValue = (Integer) yValues_.get(listsizey);



        objects_list.add(new Objects(current_xValue, current_yValue));
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
//    println("number of blobs = "+nrBlobs_+" number of objects = "+nrObjects);

    drawObjects(xValues_, yValues_, xSizes_, ySizes_);
    check_collision();
  }

  public final void drawObjects(ArrayList xValues_, ArrayList yValues_, ArrayList xSizes_, ArrayList ySizes_) {
    ArrayList storeBlobs;
    int blobAmount = xValues_.size();
    storeBlobs = new ArrayList();

    storeBlobs.clear();

    ConnectXblobject();
    ConnectYblobject();

    for ( int i = 0; i < blobAmount; i++) {
      storeBlobs.add(0);
    }

    //    println("drawObjects uitgevoerd");
    //if(nrObjects != 0){
    for ( int i=0 ; i <(nrObjects); i++) { 
      Objects current_object = (Objects) objects_list.get(i);
      //      if (nrObjects != xValues_.size()) {
      //        println(" BREAK BREAK ---------------------------------------------------------------------------");
      //        break;
      //      }
      //       for (int j= 0; j< blobAmount; j++) {
      if (nrBlobs != 0){
      int nearestBlob = mindistBlob(i, storeBlobs);

//        println("nearestblob = "+nearestBlob);

        if (storeBlobs.size()!=0) {
          storeBlobs.remove(nearestBlob);

          storeBlobs.add(nearestBlob, 1);

//          println("storeBlobs = "+storeBlobs);
          
          current_object.display((Integer) xValues_.get(nearestBlob), (Integer) yValues_.get(nearestBlob), (Integer) xSizes_.get(nearestBlob), (Integer) ySizes_.get(nearestBlob), nrObjects);
          //      }
        }
      }
      else {
        current_object.eigenleven();
      }

      
    }
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
      Objects currentObject = (Objects) objects_list.get(i);  

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
          Objects currentObject_1 = (Objects) objects_list.get(i);  
          Objects currentObject_2 = (Objects) objects_list.get(j);  

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
      Objects current_object = (Objects) objects_list.get(i);  
      xposObj.add(current_object.givexpos());
    }
  }

  void ConnectYblobject() {
    yposObj.clear();
    for ( int i=0 ; i <objects_list.size(); i++) { 
      Objects currentObject = (Objects) objects_list.get(i);  
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
  int mindistBlob(int ObjectID, ArrayList ConnectedBlobs) {
//    println("number of blobs = "+ConnectedBlobs.size()+" number of objects = "+xposObj.size());

    int smallestdist = 100000;
    // for this Object ID, get the xValue of the Objec
    int xValueObject = (Integer) xposObj.get(ObjectID);
    //and the y value of the blob

    int yValueObject = (Integer) yposObj.get(ObjectID);
    // check distance between current Object and all Blobs(people)
    if (nrBlobs>=0) {

      for (int i = 0; i < nrBlobs ; i++) {
        int yValueBlob  = (Integer) yValues.get(i);
        int xValueBlob  = (Integer) xValues.get(i);
        int connectedblobi  = (Integer) ConnectedBlobs.get(i);

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

