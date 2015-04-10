class Objects {

  float intensecollide = 1.1;
  int sizeb;
  float xpos, ypos;

  boolean collide;
  int weebelAmount = 0;

  float xspeed = 0;
  float yspeed = 0;
  float xacc = 0;
  float yacc = 0;
  float dt = 0.2;
  float friction = 0.92; //number < 1 slowing movement

  int xstart;
  int ystart;

  int theColor = 0;
  color[] colors = { color(0,0,255), color(0,255,0), color(0), color(255,0,0), color(255), color(111,0,255),color(255, 255, 0),color(0, 255, 255),color(127,0,255),color(255,0,255),color(128,128,128),color(0,255,0)};
  
  int colorpicker;
  
  
  ArrayList particles;
  PVector origin;
  Timer collisionTimer;
  Timer mondriaanTimer;
   Timer reset;

  Objects(int xpos_, int ypos_) {
    particles = new ArrayList();              // Initialize the arraylist
    origin = new PVector(xpos, ypos);        // Store the origin point
    xpos = xpos_;
    ypos = ypos_;
    collisionTimer = new Timer(2000);
    mondriaanTimer = new Timer(1000);
    reset = new Timer(200000);
    
    colorpicker = round( random(0,(colors.length-1)));
    fill( colors[colorpicker] );
  }
  void eigenleven() {
    //println("ik heb geen leven");

    xpos += xspeed*friction; // Increment x
    ypos += yspeed*friction; // Increment y

    fill(colors[colorpicker]);
    ellipseMode(CENTER);
    rect(xpos, ypos, sizeb, sizeb);
    if (xpos > width || xpos < 0) {
      xspeed *= - 1;
    }

    // Check vertical edges
    if (ypos > height || ypos < 0) {
      yspeed *= - 1;
    }
  }
  void display(int x_, int y_, int xSize_, int ySize_, int nrObjects_) {
     if (reset.isFinished()){
      // background(0);
     reset.start();
     }
     
     
    // invert X
//    xpos = 1600-x_;
    int xPersonMapping =0;
    //    println("acceleratie = "+xacc);
    if (xacc <= -5) {
      xPersonMapping = -weebelAmount;
    }
    else {
      xPersonMapping = 0;
    }
    if (xacc >= 5) {
      xPersonMapping = weebelAmount;
    }
    else {
      xPersonMapping = 0;
    }
    //    println("personmapping ="+xPersonMapping);
    x_+= xPersonMapping;
    if (collide == true) {
      //wacht een paar seconde en reset speed
      if (collisionTimer.isFinished()) {
        xspeed /= intensecollide;
        yspeed /= intensecollide;
        collide = false;
      }
    }
    //remove to see other image
    //background(102);

    // Update the position of the shape
    xpos = xpos + xspeed * dt + xacc * dt * dt;
    xspeed = (xspeed) * friction + xacc * dt;
    xacc = dt*(x_ - xpos);
    //    println("xaccelartie = "+xacc);

    ypos = ypos + yspeed * dt + yacc * dt * dt;
    yspeed = (yspeed) * friction + yacc * dt;
    yacc = dt*(y_ - ypos);
    //     println("yaccelartie = "+yacc);

    if (xspeed*xspeed + yspeed*yspeed > 1000) {
      addParticle();
    }


    // Cycle through the ArrayList backwards b/c we are deleting
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = (Particle) particles.get(i);
      p.run(new PVector(0.05*dt*(x_ - p.xloc()), 0.05*dt*(y_ - p.yloc())));
      if (p.dead()) {
        particles.remove(i);
      }
    }
    //    println("xSize "+xSize_);
    if (ySize_ <= 300) {
      if (nrObjects_ <= 3) {
        sizeb = 100;
      }
      if (nrObjects_ >= 4 && nrObjects_ <= 6) {
        sizeb = 80;
      }
      if (nrObjects_ >= 7 && nrObjects_ <= 10) {
        sizeb = 60;
      }   
      if (nrObjects_ >= 11 && nrObjects_ <= 20) {
        println("pietje");
        sizeb = 40;
      }    
      if (nrObjects_ >= 21) {
        sizeb = 20;
      }
    }
    else {
      sizeb = 900;
      //      ypos -= 450;
    }

    if (xSize_ >= 300 && xpos>= 500 && xpos<= 1100 && mondriaanTimer.isFinished()) {
      mondriaanTimer.start();
      println("BLIKSEM BAMBAMBAM");      
      ArrayList mondriaan;
      mondriaan = new ArrayList();

      mondriaan.add(1);
      mondriaan.add(1);
      mondriaan.add(1);
      mondriaan.add(1);
      mondriaan.add(2);
      mondriaan.add(2);
      mondriaan.add(3);
      mondriaan.add(4);
      int rectangle[] = {
        490, 0, 200, 420, 0, 300, 200, 420, 0, 0, 420, 200, 360, 520, 420, 200, 1400, 0, 200, 420, 1180, 520, 420, 200, 820, 0, 420, 200, 910, 300, 200, 420
      };
      //      rectangle.a(215;210;240;250);
      //      rectangle.add(0;300;200;420);
      //      rectangle.add(0;0;420;200);
      //      rectangle.add(360;520;420;200);
      //      rectangle.add(1400;0;200;420);
      //      rectangle.add(1180;520;420;200);
      //      rectangle.add(820;0;420;200);
      //      rectangle.add(910;300;200;420);

      Collections.shuffle(mondriaan);

      for (int i = 0; i <= rectangle.length-1; i+=4) {
        int mondi =0;
        if (i==0) {
          mondi = (Integer)mondriaan.get(0);
        }
        if (i==4) {
          mondi = (Integer)mondriaan.get(1);
        }
        if (i==8) {
          mondi = (Integer)mondriaan.get(2);
        }
        if (i==12) {
          mondi = (Integer)mondriaan.get(3);
        }
        if (i==16) {
          mondi = (Integer)mondriaan.get(4);
        }
        if (i==20) {
          mondi = (Integer)mondriaan.get(5);
        }
        if (i==24) {
          mondi = (Integer)mondriaan.get(6);
        }
        if (i==28) {
          mondi = (Integer)mondriaan.get(7);
        }
        println("i = "+i);
        println(mondi);
        if (mondi == 1) {
          fill(255);
          int rect1 = rectangle[i];
          int rect2 = rectangle[i+1];
          int rect3 = rectangle[i+2];
          int rect4 = rectangle[i+3];
          rect(rect1, rect2, rect3, rect4);
          println("rect1= "+rect1);
        }  
        if (mondi == 2) {
          fill(0, 0, 255);
          int rect1 = rectangle[i];
          int rect2 = rectangle[i+1];
          int rect3 = rectangle[i+2];
          int rect4 = rectangle[i+3];
          rect(rect1, rect2, rect3, rect4);
        }  
        if (mondi == 3) {
          fill(255, 0, 0);
          int rect1 = rectangle[i];
          int rect2 = rectangle[i+1];
          int rect3 = rectangle[i+2];
          int rect4 = rectangle[i+3];
          rect(rect1, rect2, rect3, rect4);
        }  
        if (mondi == 4) {
          fill(255, 255, 0);
          int rect1 = rectangle[i];
          int rect2 = rectangle[i+1];
          int rect3 = rectangle[i+2];
          int rect4 = rectangle[i+3];
          rect(rect1, rect2, rect3, rect4);
        }
      }
      
    }
    if (xSize_ >= 300 && xpos<= 550) {
       background(0);

    }
    if (xSize_ >= 300 && xpos>= 1100) {
      background(0);
    }
    //    println("xpos ellipse = "+xpos);
    //    println("ypos ellipse = "+ypos);
    // Draw the shape
    noStroke();
    ellipseMode(CENTER);

    fill(colors[colorpicker]);
    ellipse(xpos, ypos, sizeb, sizeb);

    fill(colors[colorpicker], 75);
    ellipse(xpos, ypos, sizeb+20, sizeb+20);

    //    rect(215, 215, 240, 250);
    //    rect(695, 215, 210, 250);
    //    rect(1140, 215, 240, 250);
  }

  int givexpos() {
    return (int) xpos;
  }

  int giveypos() {
    return (int) ypos;
  }
  void collide() {
    collide =true;
    xspeed *= -intensecollide;
    yspeed *= -intensecollide;
    collisionTimer.start();
  }
  //adds particle with size depending on speed (no bigger than 15)
  void addParticle() {
    particles.add(new Particle(new PVector(xpos, ypos), 15, colors[colorpicker]));
  }


  void connect(int ix_, int iy_, int jx_, int jy_) {

    alph += 0.1;
    float a1 = jx_ +(ix_ - jx_)/6;
    float b1 = jy_ +(iy_ - jy_)/6;
    float a2 = jx_ +2*(ix_ - jx_)/6;
    float b2 = jy_ +2*(iy_ - jy_)/6; 
    float a3 = jx_ +3*(ix_ - jx_)/6;
    float b3 = jy_ +3*(iy_ - jy_)/6;   
    float a4 = jx_ +4*(ix_ - jx_)/6;
    float b4 = jy_ +4*(iy_ - jy_)/6;    
    float a5 = jx_ +5*(ix_ - jx_)/6;
    float b5 = jy_ +5*(iy_ - jy_)/6;

    //    println(a1);
    //    println(b1);

    fill(255, 255, 0);

    ellipse(a1+15*sin(alph), b1+15*cos(alph), 10, 10);
    ellipse(a2+15*sin(alph+2), b2+15*cos(alph*0.6), 8, 8);
    ellipse(a3+15*sin(alph*0.9), b3+15*cos(alph*0.9), 6, 6);
    ellipse(a4+15*sin(alph), b4+15*cos(alph*0.7), 8, 8);
    ellipse(a5+15*sin(alph*0.4), b5+15*cos(alph*1.1), 10, 10);
  }

  int sizeB() {
    return sizeb;
  }
}

