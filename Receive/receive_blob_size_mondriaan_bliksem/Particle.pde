class Particle {
  PVector loc;
  PVector vel;
  PVector acc;
  float r;
  float timer;
  float friction = 0.96;
  int rcolor;
  int gcolor;
  int bcolor;  


  //Constructor 2 (I use this one)
  Particle(PVector l, float r_, int rcolor_, int gcolor_, int bcolor_) {
    acc = new PVector(0, 0, 0);
    vel = new PVector(random(-1, 1), random(-1, 1), 0);
    loc = l.get();
    loc.x = loc.x + random(-50, 50);
    loc.y = loc.y + random(-50, 50);
    r = r_;
    timer = 100.0;
    
    rcolor = rcolor_-20;
    gcolor = gcolor_-20;
    bcolor = bcolor_-20;
    
  }



  void run() {
    update();
    render();
  }

  void run(PVector a) {
    update(a.get());
    render();
  }

  // Methods to update location
  void update() {
    vel.add(acc);
    vel.mult(friction);
    loc.add(vel);
    timer -= 1.0;
  }

  void update(PVector a) {
    acc = a.get();
    vel.add(acc);
    vel.mult(friction);
    loc.add(vel);
    timer -= 1.0;
  }


  // Method to display
  void render() {
      fill(rcolor,gcolor,bcolor, timer*2);
    ellipseMode(CENTER);
    ellipse(loc.x, loc.y, r, r);
  }

  // Is the particle still useful?
  boolean dead() {
    if (timer <= 0.0) {
      return true;
    } 
    else {
      return false;
    }
  }

  // Reports where particle is
  float xloc() {
    return loc.x;
  }
  float yloc() {
    return loc.y;
  }
}

