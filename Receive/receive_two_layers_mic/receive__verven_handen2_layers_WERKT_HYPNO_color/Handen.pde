class Handen {

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
  int sizeHand;

  int theColor = 0;
  color[] colors = {color(0,0,255), color(0,255,0), color(0),color(255,0,0), color(255), color(111,0,255),color(255, 255, 0),color(0, 255, 255),color(127,0,255),color(255,0,255),color(0,255,0)};
  
  int colorpicker;
  

  ArrayList particles;
  PVector origin;
  Timer collisionTimer;
  Timer mondriaanTimer;
   Timer reset;

  Handen(int xpos_, int ypos_) {
    particles = new ArrayList();              // Initialize the arraylist
    origin = new PVector(xpos, ypos);        // Store the origin point
    xpos = xpos_;
    ypos = ypos_;
    collisionTimer = new Timer(2000);
    mondriaanTimer = new Timer(1000);
    reset = new Timer(200000);
    
    colorpicker = round( random(0,(colors.length-1)));
    
    
    
  }
  void eigenleven() {
    //println("ik heb geen leven");

    xpos += xspeed*friction; // Increment x
    ypos += yspeed*friction; // Increment y

    fill( colors[colorpicker] );
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
    //background(0,0);
     if (reset.isFinished()){
      // background(0);
     reset.start();
     }

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

 
      if (nrObjects_ <= 3) {
        sizeb = 50;
      }
      if (nrObjects_ >= 4 && nrObjects_ <= 6) {
        sizeb = 40;
      }
      if (nrObjects_ >= 7 && nrObjects_ <= 10) {
        sizeb = 30;
      }   
      if (nrObjects_ >= 11 && nrObjects_ <= 20) {
       // println("pietje");
        sizeb = 20;
      }    
      if (nrObjects_ >= 21) {
        sizeb = 10;
      }

    //    println("xpos ellipse = "+xpos);
    //    println("ypos ellipse = "+ypos);
    // Draw the shape
    noStroke();
    ellipseMode(CENTER);
    //laag1.drawHands();
    
   // rcolor_global = rcolor;
  //gcolor_global =   gcolor ;
     //bcolor_global= bcolor;
     xpos_global = xpos;
    ypos_global = ypos ;
    sizeb_global = sizeb;

//    fill(rcolor, gcolor, bcolor);
//    ellipse(xpos, ypos, sizeb, sizeb);
//
//    fill(rcolor, gcolor, bcolor, 75);
//    ellipse(xpos, ypos, sizeb+20, sizeb+20);

    //    rect(215, 215, 240, 250);
    //    rect(695, 215, 210, 250);
    //    rect(1140, 215, 240, 250);
  }

  int givexpos() {
    return (int) xpos;
  }
  int giveSizeHand(){
  
  sizeHand+=100;
  if(sizeHand>5000){
  
  sizeHand =0;
  }
  return sizeHand;
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
    //particles.add(new Particle(new PVector(xpos, ypos), 15, rcolor, gcolor, bcolor));
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

