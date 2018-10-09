
enum PlataformaTipo{
  INICIO,CENTRAL,FINAL,ESPACIO
}

class Plataforma{

  Vec2 p,s;
  Body b;
  PlataformaTipo t;
  float v;
  
  Plataforma(Vec2 posicion,Vec2 size,PlataformaTipo tipo)   {
    p = posicion;
    s = size;   
    t = tipo;
    v=0;
    
   
    PolygonShape sd = new PolygonShape();    

    float box2dW = box.scalarPixelsToWorld(s.x/2);
    float box2dH = box.scalarPixelsToWorld(s.y/2);
    if(tipo == PlataformaTipo.ESPACIO){
      box2dW=0;
      box2dH=0;
    }
    
    sd.setAsBox(box2dW, box2dH);

    

    FixtureDef fd = new FixtureDef();
    

    fd.shape       = sd;
    
    fd.density     = 0;
    fd.friction    = 0;
    fd.restitution = 0;    

    BodyDef bd = new BodyDef();
    
    bd.type = BodyType.KINEMATIC;          
    bd.position.set(box.coordPixelsToWorld(p.x,p.y));
    
    b = box.createBody(bd);
    b.createFixture(fd);
    b.setUserData(this);    
  }
 
 void SetVelocidad(float velocidad){
   v = velocidad;
   b.setLinearVelocity(new Vec2(-velocidad,0));
 }
 
  void display() {
    
    if(t == PlataformaTipo.ESPACIO)
      return;
    
    Vec2 pos = box.getBodyPixelCoord(b);    
    float a = b.getAngle();

    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    
    noStroke();
    //color plataforma linea
    fill(70);    
    rect(0, -10, s.x, s.y);
    //color plataforma
    fill(10);    
    rect(0,  10, s.x, s.y - 10);
 
    popMatrix();
  }

  
  
}
