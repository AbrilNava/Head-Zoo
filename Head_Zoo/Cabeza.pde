
enum CabezaTipo{
  TREX,ALIEN,CARACOL,GATO,RANA,CHIVA
}
enum CabezaEstado{
  NORMAL,SALTANDO,MUERTA
}

class Cabeza{
  
  Vec2 p,s;
  Body b;
  Avatar avatar;
  boolean piso,saltando;
  CabezaTipo tp;
  float vs;
  float t;
  
  Cabeza(Vec2 posicion,Vec2 size, float vsalto,CabezaTipo tipo){
    p = posicion;
    s = size;
    vs = vsalto;
    piso = false;
    saltando = false;
    tp = tipo;
    
    avatar = new Avatar(tipo);
    
    PolygonShape sd = new PolygonShape();    

    float box2dW = box.scalarPixelsToWorld(s.x/2);
    float box2dH = box.scalarPixelsToWorld(s.y/2);
    sd.setAsBox(box2dW, box2dH);

    FixtureDef fd = new FixtureDef();
    
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

  void IniciarSalto(){
    saltando = true;
    
  }
  void FinalizarSalto(){
    saltando = false;
  }

  void Saltando(){
    
    if(!saltando)
        return;    
        
    if(!piso){          
      if((frameCount-t)/frameRate < 2){
        b.setLinearVelocity(b.getLinearVelocity().add(new Vec2(0,vs * 0.018)));
      }      
    }
    else{      
      t = frameCount;
      b.setLinearVelocity(new Vec2(b.getLinearVelocity().x,vs));      
      SetPiso(false);      
    }
    
    float v = b.getLinearVelocity().y;
    b.setAngularVelocity(v/vs * 10);
    
  }
  void SetPiso(boolean piso){    
    this.piso = piso;
    if(!piso){
      avatar.SetSeleccion(tp,CabezaEstado.SALTANDO);
      Sonido();
    }
    else
      avatar.SetSeleccion(tp,CabezaEstado.NORMAL);      
  }
  void ClearVelocidadX(){
    b.setLinearVelocity(new Vec2(0,b.getLinearVelocity().y));
  }
  void Sonido(){
  
     switch(tp){
     
        case TREX:
          audios[0].rewind();
          audios[0].play();
        break;
        case ALIEN: 
          audios[1].rewind();
          audios[1].play();        
        break;
        case CARACOL: 
          audios[2].rewind();
          audios[2].play();        
        break;
        case GATO:         
          audios[3].rewind();
          audios[3].play();        
        break;
        case RANA:         
          audios[4].rewind();
          audios[4].play();        
        break;
        case CHIVA:      
          audios[5].rewind();
          audios[5].play();        
        break;
        
      }  
    
  }
  
  void Combinar(CabezaTipo tipo){
  
    switch(tp){
      case TREX:
      
      switch(tipo){
        case TREX:
        break;
        case ALIEN: 
        break;
        case CARACOL: 
        break;
        case GATO:           
        break;
        case RANA:        
          tp = CabezaTipo.GATO;        
        break;
        case CHIVA:
          tp = CabezaTipo.CARACOL;
        break;
      }
      
      break;
      case ALIEN:
      
      switch(tipo){
        case TREX:
        break;
        case ALIEN: 
        break;
        case CARACOL: 
        break;
        case GATO: 
        break;
        case RANA:
        break;
        case CHIVA:
        break;
      }
      
      break;
      case CARACOL:
      
      switch(tipo){
        case TREX:
        break;
        case ALIEN: 
        break;
        case CARACOL: 
        break;
        case GATO: 
        break;
        case RANA:
        break;
        case CHIVA:
        break;
      }
      
      break;
      case GATO:
      
      switch(tipo){
        case TREX:
        break;
        case ALIEN: 
        break;
        case CARACOL: 
        break;
        case GATO: 
        break;
        case RANA:
        break;
        case CHIVA:
        break;
      }
      
      break;
      case RANA:
      
      switch(tipo){
        case TREX:
        break;
        case ALIEN: 
        break;
        case CARACOL: 
        break;
        case GATO: 
        break;
        case RANA:
        break;
        case CHIVA:
        break;
      }
      
      break;
      case CHIVA:
      
      switch(tipo){
        case TREX:
        break;
        case ALIEN: 
        break;
        case CARACOL: 
        break;
        case GATO: 
        break;
        case RANA:
        break;
        case CHIVA:
        break;
      }
      
      break;
    }
    
    tp = tipo;
    avatar.SetSeleccion(tp,(piso)?CabezaEstado.NORMAL:CabezaEstado.SALTANDO);
    
  }
  
  
}