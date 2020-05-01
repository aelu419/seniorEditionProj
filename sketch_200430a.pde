ArrayList<spine> spines; // n rows and l+1 columns
ArrayList<ArrayList<Pivot>> dots;

float rMaster = 12500;
float ranMaster = .75;

float n = 60; //number of spines
float l = 69; //number of layers

float MapRot[] = {0.28, 0.5, .1};

float w = 12500; // its the width of the canvas, which is cropped by the actual image
float h = 13500;

PGraphics pg;

int notSavedYet = 0;

void setup(){
  size(595, 842, P3D);
  
  spines = new ArrayList(20);
  dots = new ArrayList((int)(n*l));
  for (int i = 0; i < n; i++){
    float ang = i / n * 2 * PI + random(0.065);
    spines.add(new spine(ang));
    ArrayList<Pivot> content = new ArrayList((int)l);
    for(int j = 0; j < l; j++){
      float r = rMaster * (j + 1) / l + random(ranMaster);
      //if(j != 0)
        content.add(spines.get(i).getPos(r));
      //else
        //content.add(spines.get(i).getPos(r, true));
    }
    dots.add(content);

  }
  //finish off the loop by adding an extra spine
  dots.add(dots.get(0));
  
  pg = createGraphics(5953, 8419, P3D);
  pg.smooth(4);
  
}

void draw(){
  if(notSavedYet>2)
    return;
  else if (notSavedYet ==2){
    saveImage();
    return;
  }
  else{
    saveImage();
  }
  
  pg.beginDraw();
  pg.background(255);
  //pg.lights();
  //pg.background(255,255,255);
  
  //lights();
  
  rectMode(CENTER);
  fill(100,100,100);
  /*
  for(ArrayList<PVector> i : dots){
    for(PVector p : i){
      pushMatrix();
    
      rotateX(MapRot[0]);
      rotateY(MapRot[1]);
      rotateZ(MapRot[2]);
    
      translate(p.x+w/2, p.y+h/2, p.z);
      //rect(0, 0, 10, 10);
    
      popMatrix();
    }
  }*/

  //faces
  for (int i = 0; i < n; i++){
    Pivot temp = dots.get(i).get(0);
    Pivot temp1 = dots.get(i+1).get(0);
    for(int j = 1; j < l; j++){
      Pivot curr = dots.get(i).get(j);
      Pivot curr1 = dots.get(i+1).get(j);
      quad2(temp, temp1, curr1, curr);

      temp = curr;
      temp1 = curr1;
    }
  }
  
  //circular, gradient
  for (int i = 0; i < l; i++){
    Pivot temp = dots.get(0).get(i);
    for(int j = 1; j < n+1; j++){ //+1 accomodates for the extra spine
      Pivot curr = dots.get(j).get(i);
      line2gr(temp, curr);
      temp = curr;
    }
  }
  //circular, constant
  for (int i = 0; i < l; i++){
    Pivot temp = dots.get(0).get(i);
    for(int j = 1; j < n+1; j++){ //+1 accomodates for the extra spine
      Pivot curr = dots.get(j).get(i);
      line2const(temp, curr);
      temp = curr;
    }
  }
  
  //ray-like
  for (int i = 0; i < n; i++){
    Pivot temp = dots.get(i).get(0);
    for(int j = 1; j < l; j++){
      Pivot curr = dots.get(i).get(j);
      //line2 (temp, curr);
      temp = curr;
    }
  }
  pg.endDraw();
  
  image(pg, 0, 0, width, height);
  //PImage result = pg.get(0, 0, pg.width, pg.height);
  
  //noLoop();
}

void saveImage(){
  if(notSavedYet <= 1){
    pg.save("sample-"+notSavedYet+".png");
    notSavedYet ++;
  }
}

color ranCol(float r){
  float white = r / rMaster * 80 + 70;
  int R = (int)white + (int)random(255-white);
  int G = (int)white + (int)random(255-white);
  int B = (int)white + (int)random(255-white);
  int a = 255;
  
  return color(R, G, B, a);
}

void line2(Pivot temp, Pivot curr){
  pg.pushMatrix();
      
      pg.rotateX(MapRot[0]);
      pg.rotateY(MapRot[1]);
      pg.rotateZ(MapRot[2]);
      
      float r = sqrt(temp.x*temp.x + temp.y*temp.y + temp.z*temp.z);
      float str = 30 * sqrt(r / rMaster);
      pg.strokeWeight(str);
      
      pg.beginShape(LINES);
      
      //stroke(255,255,255);
      //line(temp.x+w/2, temp.y+h/2, temp.z, curr.x+w/2, curr.y+h/2, curr.z);
      pg.stroke(avgCol(temp, curr));
      //pg.stroke(temp.R, temp.G, temp.B, 255); 
      pg.vertex(w/2 + temp.x,  h/2+temp.y,  temp.z);
      //pg.stroke(curr.R, curr.G, curr.B, 255); 
      pg.vertex(w/2 + curr.x,  h/2+curr.y,  curr.z);
      
      pg.endShape();
      
      pg.popMatrix();
}

void line2gr(Pivot temp, Pivot curr){
  pg.pushMatrix();
      
      pg.rotateX(MapRot[0]);
      pg.rotateY(MapRot[1]);
      pg.rotateZ(MapRot[2]);
      
      float r = sqrt(temp.x*temp.x + temp.y*temp.y + temp.z*temp.z);
      float str = 30 * sqrt(r / rMaster);
      pg.strokeWeight(str);
      
      pg.beginShape(LINES);
      
      //stroke(255,255,255);
      //line(temp.x+w/2, temp.y+h/2, temp.z, curr.x+w/2, curr.y+h/2, curr.z);
 
      pg.stroke(temp.R, temp.G, temp.B, 215); 
      pg.vertex(w/2 + temp.x,  h/2+temp.y,  temp.z);
      pg.stroke(curr.R, curr.G, curr.B, 215); 
      pg.vertex(w/2 + curr.x,  h/2+curr.y,  curr.z);
      
      pg.endShape();
      
      pg.popMatrix();
}

void line2const(Pivot temp, Pivot curr){
  pg.pushMatrix();
      
      pg.rotateX(MapRot[0]);
      pg.rotateY(MapRot[1]);
      pg.rotateZ(MapRot[2]);
      
      float r = sqrt(temp.x*temp.x + temp.y*temp.y + temp.z*temp.z);
      float str = 30 * sqrt(r / rMaster);
      pg.strokeWeight(str);
      
      pg.beginShape(LINES);
      
      //stroke(255,255,255);
      //line(temp.x+w/2, temp.y+h/2, temp.z, curr.x+w/2, curr.y+h/2, curr.z);
      color avg = avgCol(temp, curr);
      pg.stroke(red(avg), green(avg), blue(avg), 40);
      //pg.stroke(temp.R, temp.G, temp.B, 255); 
      pg.vertex(w/2 + temp.x,  h/2+temp.y,  temp.z);
      //pg.stroke(curr.R, curr.G, curr.B, 255); 
      pg.vertex(w/2 + curr.x,  h/2+curr.y,  curr.z);
      
      pg.endShape();
      
      pg.popMatrix();
}

void quad2(Pivot temp, Pivot temp1, Pivot curr1, Pivot curr){
  pg.pushMatrix();
      
      pg.rotateX(MapRot[0]);
      pg.rotateY(MapRot[1]);
      pg.rotateZ(MapRot[2]);
      
      //pg.strokeWeight(20);
      
      pg.beginShape(QUADS);
      
      //stroke(255,255,255);
      //line(temp.x+w/2, temp.y+h/2, temp.z, curr.x+w/2, curr.y+h/2, curr.z);
      
      pg.fill(avgCol(temp, temp1, curr1, curr));
      pg.stroke(avgCol(temp, temp1, curr1, curr));
      //pg.fill(avgCol(temp, temp1));
      
      //pg.fill(temp.R, temp.G, temp.B, temp.a); 
      pg.vertex(w/2 + temp.x,  h/2+temp.y,  temp.z);
      //pg.fill(temp1.R, temp1.G, temp1.B, temp1.a); 
      pg.vertex(w/2 + temp1.x,  h/2+temp1.y,  temp1.z);
      
      //pg.fill(avgCol(curr1, curr));
      //pg.fill(curr1.R, curr1.G, curr1.B, curr1.a); 
      pg.vertex(w/2 + curr1.x,  h/2+curr1.y,  curr1.z);
      //pg.fill(curr.R, curr.G, curr.B, curr.a); 
      pg.vertex(w/2 + curr.x,  h/2+curr.y,  curr.z);
      
      pg.endShape();
      
      pg.popMatrix();
}

color avgCol(Pivot p1, Pivot p2, Pivot p3, Pivot p4){
  return color(
    (p1.R + p2.R + p3.R + p4.R)/4,
    (p1.G + p2.G + p3.G + p4.G)/4,
    (p1.B + p2.B + p3.B + p4.B)/4,
    (p1.a + p2.a + p3.a + p4.a)/4
  );
  
}

color avgCol(Pivot p1, Pivot p2){
  return color(
    (p1.R + p2.R)/2,
    (p1.G + p2.G)/2,
    (p1.B + p2.B)/2,
    (p1.a + p2.a)/2
  );
  
}

class Pivot{
  float x, y, z;
  int R, G, B, a;
  color col;
  
  Pivot(float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
    
    col = ranCol(sqrt(x*x + y*y + z*z));
    
    //https://processing.org/reference/rightshift.html
    a = (col >> 24) & 0xFF;
    R = (col >> 16) & 0xFF;  // Faster way of getting red(argb)
    G = (col >> 8) & 0xFF;   // Faster way of getting green(argb)
    B = col & 0xFF;          // Faster way of getting blue(argb)
  }
  Pivot(float x, float y, float z, boolean b){
    this.x = x;
    this.y = y;
    this.z = z;
    
    if (!b)
      col = ranCol(sqrt(x*x + y*y + z*z));
    else
      col = color(0,0,0);
  }
  
}

class spine{
  
  float theta = 0;
  float ZInitial = 17000;
  
  spine(float t){
    theta = t;
  }
  
  Pivot getPos(float r){
    return new Pivot(getX(r), getY(r), getZ(r));
  }
  
  Pivot getPos(float r, boolean b){
    return new Pivot(getX(r), getY(r), getZ(r), b);
  }
  
  float getZ(float r){
    return ZInitial / (sqrt(r) + 1);
  }
  
  float getX(float r){
    return r * cos(theta) + random(ranMaster) + random(ranMaster) * pow(r, 0.6);
  }
  
  float getY(float r){
    return r * sin(theta) + random(ranMaster) + random(ranMaster) * pow(r, 0.6);
  }
  
}
