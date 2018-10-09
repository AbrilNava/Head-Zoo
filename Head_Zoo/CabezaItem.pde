
class CabezaItem{

  Vec2 p,s;
  Body b;
  Avatar avatar;
  CabezaTipo tp;
  boolean piso,saltando;
  float vs,v;  
  
  CabezaItem(Vec2 posicion,Vec2 size,CabezaTipo tipo,float vsalto){
    
    p = posicion;
    s = size;
    vs = vsalto;
    tp = tipo;
    piso = false;
    saltando = false;
    
    avatar = new Avatar(tipo);
    avatar.SetSeleccion(tipo,CabezaEstado.SALTANDO);
    
    PolygonShape sd = new PolygonShape();    

    float box2dW = box.scalarPixelsToWorld(s.x/2);
    float box2dH = box.scalarPixelsToWorld(s.y/2);
    sd.setAsBox(box2dW, box2dH);

    FixtureDef fd = new FixtureDef();
 
    fd.isSensor    = true;
    fd.shape       = sd;    
    fd.density     = 1;
    fd.friction    = 0;
    fd.restitution = 0;

    BodyDef bd = new BodyDef();
    
    bd.type = BodyType.DYNAMIC;          
    bd.position.set(box.coordPixelsToWorld(p.x,p.y));
    
    b = box.createBody(bd);
    b.createFixture(fd);
    b.setGravityScale(2);
    b.setUserData(this);
       
  }
 
  void SetVelocidad(float velocidad){
    v = velocidad;
    b.setLinearVelocity(new Vec2(-velocidad,0));
  }
 
  void display() {
    
    Vec2 pos = box.getBodyPixelCoord(b);    
    float a = b.getAngle();

    rectMode(CENTER);
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(-a);
    avatar.display(0-s.x/2,0-s.y/2,s.x,s.y);
    popMatrix();
  
    Saltando();    
      
}
  
  void Saltando(){
           
    if(piso){            
      b.setLinearVelocity(new Vec2(b.getLinearVelocity().x,vs));      
      SetPiso(false);      
    }    
    float v = b.getLinearVelocity().y;
    b.setAngularVelocity(v/vs * 10);
    
  }
  void SetPiso(boolean piso){
    this.piso = piso;
  }
  
}
