import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import ddf.minim.*;

Minim gestor;
AudioPlayer musica_fondo;
AudioPlayer []audios;

enum Estado{
  SELECCION,INICIO,JUGANDO,FINAL
}

Box2DProcessing box;
Cabeza cabeza;
Estado estado;
Avatar avatar;

Mensaje inicio,
        instruccion,
        titulo,
        nombre,
        puntaje;

PImage  []fondo;
PImage  [][]imagenes;
String  []imagenesnombre = {"TREX","ALIEN","CARACOL","GATO","RANA","CHIVA"};
String  []imagenesestado = {"NORMAL","SALTANDO","MUERTA"};

ArrayList<Plataforma> plataformas;
ArrayList<CabezaItem> items;

int espacios = 0;
float altura = 0;

int seleccion = 0;
Avatar []avatarseleccion;

int score = 0,
    bestscore = 0;

void setup(){
  size(720,480);
  smooth();
  
  box = new Box2DProcessing(this);
  box.createWorld();
  box.listenForCollisions();
  
  fondo = new PImage[3];
  
  fondo[0] = loadImage("data/FONDOSELECCION.png");
  fondo[0].resize(width,height);
  
  fondo[1] = loadImage("data/FONDO.png");
  fondo[1].resize(width,height);
  
  fondo[2] = loadImage("data/FONDOFIN.png");
  fondo[2].resize(width,height);
  
  imagenes = new PImage[6][3];
  for(int i=0;i<imagenesnombre.length;i++)
    for(int j=0;j<imagenesestado.length;j++){
        imagenes[i][j] = loadImage("data/"+imagenesnombre[i]+imagenesestado[j]+".png");
        imagenes[i][j].resize(256,256);
    }  
      
    Minim gestor;
    gestor= new Minim(this);
    
    AudioPlayer musica_fondo;    
    
    musica_fondo= gestor.loadFile("data/MUSICAFONDO.mp3");
    musica_fondo.setGain(-10);
    musica_fondo.loop();
    
    audios = new AudioPlayer[imagenesnombre.length];        
    
    for(int i=0;i<audios.length;i++){    
      audios[i] = gestor.loadFile("data/"+imagenesnombre[i]+".mp3");
      audios[i].setGain(0);
    }
       
    avatarseleccion  = new Avatar[imagenesnombre.length];

    avatarseleccion[0] = new Avatar(CabezaTipo.TREX);
    avatarseleccion[1] = new Avatar(CabezaTipo.ALIEN);
    avatarseleccion[2] = new Avatar(CabezaTipo.CARACOL);
    avatarseleccion[3] = new Avatar(CabezaTipo.GATO);
    avatarseleccion[4] = new Avatar(CabezaTipo.RANA);
    avatarseleccion[5] = new Avatar(CabezaTipo.CHIVA);
       
    seleccion = 0;
       
    SeleccionSetup();  
   
}
void draw(){
  
  background(0);
  box.step();
  
  switch(estado){
    case SELECCION:
      SeleccionDraw();
    break;
    case INICIO:
      InicioDraw();
    break;
    case JUGANDO:
      JugandoDraw();
    break;
    case FINAL:
      FinalDraw();
    break;
  }
  
  
} 

void keyPressed(){
  
  switch(estado){  
    case SELECCION:
      SeleccionKey();
    break;
    case INICIO:
      InicioKey();
    break;
    case JUGANDO:
      JugandoKeyPressed();
    break;
    case FINAL:
      FinalKey();
    break;
  }
  
}

void keyReleased(){

    switch(estado){  
      case JUGANDO:
        JugandoKeyReleased();
      break;
    }
  
}
void beginContact(Contact cp) {

  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();

  if (o1.getClass() == Cabeza.class && o2.getClass() == Plataforma.class) {
    cabeza.SetPiso(true);
  }
  if (o1.getClass() == Cabeza.class && o2.getClass() == CabezaItem.class) {    
    cabeza.Combinar(((CabezaItem)o2).tp);
    score++;
    if(score > bestscore)
      bestscore = score;
    puntaje.Reiniciar("SCORE : " + score + "          MEJOR SCORE : " + bestscore);
    items.remove(o2);    
    cabeza.ClearVelocidadX();
  }
  
  
  if (o2.getClass() == Cabeza.class && o1.getClass() == Plataforma.class) {
    cabeza.SetPiso(true);
  }
  if (o2.getClass() == Cabeza.class && o1.getClass() == CabezaItem.class) {    
    cabeza.Combinar(((CabezaItem)o1).tp);
    score++;
    if(score > bestscore)
      bestscore = score;
    puntaje.Reiniciar("SCORE : " + score + "          MEJOR SCORE : " + bestscore);
    items.remove(o1);    
    cabeza.ClearVelocidadX();
  }
  
  
  if (o2.getClass() == CabezaItem.class) {
    CabezaItem i = (CabezaItem)o2;
    i.SetPiso(true);
  }
  if (o1.getClass() == CabezaItem.class) {
    CabezaItem i = (CabezaItem)o1;
    i.SetPiso(true);
  }

}


void endContact(Contact cp) {
  
}

//______________________________________________________________________________ESTADO_SELECCION

void SeleccionSetup(){  
  
  estado = Estado.SELECCION;  
  
  titulo   = new Mensaje("SELECCIONAR AVATAR",createFont("EraserDust", 32),25, color(255));
  instruccion = new Mensaje("PRESIONA [ESPACIO] PARA CONFIRMAR             PRESIONE [LEFT/RIGHT] PARA SELECCIONAR",createFont("Gill Sans MT", 14),12, color(255));
  nombre   = new Mensaje(imagenesnombre[seleccion],createFont("Gill Sans MT", 30),25, color(255));  
  
}
void SeleccionDraw(){
  
  image(fondo[0],0,0);
    
  float s = 128 + sin(0.2*frameCount)*32;    
  
  int k1 = seleccion-1,
      k2 = seleccion+1;
    
  if(k1 < 0)
    k1 = avatarseleccion.length-1;
  if(k2 > (avatarseleccion.length-1))
    k2 = 0;  
    
  tint(color(255,255,255,96));
  avatarseleccion[k1].display(width/4-(64+32),height/2-64,128,128);
  tint(color(255,255,255,255));
  avatarseleccion[seleccion].display(width/2-s/2,height/2-s/2,s,s);
  tint(color(255,255,255,96));
  avatarseleccion[k2].display(3*width/4-(64-32),height/2-64,128,128);
  tint(color(255,255,255,255));

  titulo.Display(width/4,height/16);
  instruccion.Display(width/32,height - 32);
  nombre.Display(width/2 - 40,height/2 + s/2 + 16);
  
}
void SeleccionKey(){  

  if(key == ' ')
     InicioSetup();
  if(keyCode == RIGHT){
      seleccion++;
      
      if(seleccion > avatarseleccion.length-1)
        seleccion = 0;
      if(seleccion < 0) 
        seleccion = avatarseleccion.length-1;
      
      nombre.Reiniciar(imagenesnombre[seleccion]);
  }
  if(keyCode == LEFT){
      seleccion--;
      
      if(seleccion > avatarseleccion.length-1)
        seleccion = 0;
      if(seleccion < 0) 
        seleccion = avatarseleccion.length-1;
      
      nombre.Reiniciar(imagenesnombre[seleccion]);
  }
  
  
  
}


//______________________________________________________________________________ESTADO_INICIO

void InicioSetup(){
  
  altura = height + height/32;
  CabezaTipo tipo = CabezaTipo.RANA;
  score = 0;
  
  estado = Estado.INICIO;
  
       switch(seleccion){
        case 0:
        tipo = CabezaTipo.TREX;
        break;
        case 1:
        tipo = CabezaTipo.ALIEN; 
        break;
        case 2:
        tipo = CabezaTipo.CARACOL; 
        break;
        case 3:
        tipo = CabezaTipo.GATO; 
        break;
        case 4:
        tipo = CabezaTipo.RANA;
        break;
        case 5:
        tipo = CabezaTipo.CHIVA;
        break;
      }
  
  cabeza = new Cabeza(new Vec2(width/4 + 32,height/2), new Vec2(32,32), 17, tipo);  
  plataformas = new ArrayList<Plataforma>();  
  for(int i=0;i<4;i++)
      plataformas.add(new Plataforma(new Vec2(width/8 + i*width/4,  altura + GeneracionOffset(new Vec2(0,altura))*0.5 ), new Vec2(width/4,7*height/8), PlataformaTipo.CENTRAL));
  items = new ArrayList<CabezaItem>();
  
  
  inicio  = new Mensaje("PRESIONA [ESPACIO] PARA INICIAR",createFont("Gill Sans MT", 18),14, color(255));
  puntaje = new Mensaje("SCORE : " + score + "          MEJOR SCORE : " + bestscore,createFont("Gill Sans MT", 18),14, color(255));
  
}
void InicioDraw(){
  
  image(fondo[1],0,0);
  
  for(Plataforma p : plataformas)
    p.display();
  
  cabeza.display();
  inicio.Display(width/2,height/2 - height/4);
  puntaje.Display(width/4, height/128);
  
}
void InicioKey(){  
  if(key==' ')
      JugandoSetup();        
}


//______________________________________________________________________________ESTADO_JUGANDO

void JugandoSetup(){
  estado = Estado.JUGANDO;
  for(Plataforma p : plataformas)
    p.SetVelocidad(10);    
  instruccion = new Mensaje("MANTEN PRESIONADO [ESPACIO] PARA SALTAR MAS ALTO",createFont("Gill Sans MT", 18),14, color(255));
    puntaje = new Mensaje("SCORE : " + score + "          MEJOR SCORE : " + bestscore,createFont("Gill Sans MT", 18),14, color(255));
} 
void JugandoDraw(){
  image(fondo[1],0,0);
   
  for(Plataforma p : plataformas)
    p.display();
  for(CabezaItem i : items)
    i.display();    
    
  cabeza.display();

  instruccion.Display(width/8,height - 32);
  puntaje.Display(width/4, height/128);
  
  Generar();
  Destruir();  
    
}

void GenerarItems(){

    Plataforma p = plataformas.get(plataformas.size()-1);
  
}
void Generar(){

  Plataforma p = plataformas.get(plataformas.size()-1);
  PlataformaTipo t = p.t;
  float v          = p.v;
  
  Vec2 pos = box.getBodyPixelCoord(p.b);   
  if( !( (pos.x + p.s.x/2) <= width) )
    return;
    
  if(t == PlataformaTipo.CENTRAL){     
      Probabilidad pb = new Probabilidad(55,45);
      int k = pb.Next();               
      if(k == 0)
         plataformas.add(new Plataforma(pos.add(new Vec2(p.s.x,GeneracionOffset(pos))), p.s, PlataformaTipo.CENTRAL));
      else if(k==1)
        plataformas.add(new Plataforma(pos.add(new Vec2(p.s.x,GeneracionOffset(pos))), p.s, PlataformaTipo.FINAL));                   
  }
  else if(t == PlataformaTipo.INICIO){
       
      plataformas.add(new Plataforma(pos.add(new Vec2(p.s.x,GeneracionOffset(pos))), p.s, PlataformaTipo.CENTRAL));      
  }
  else if(t == PlataformaTipo.FINAL){      
      plataformas.add(new Plataforma(pos.add(new Vec2(p.s.x,0)), p.s, PlataformaTipo.ESPACIO));
      espacios++;
  }  
  else if(t == PlataformaTipo.ESPACIO){
      Probabilidad pb;
      int k = 0;
      if(espacios == 1){
        pb = new Probabilidad(70,30);
        k = pb.Next();
      }
      else{        
        k = 1;
      }      
            
      if(k == 0){
        plataformas.add(new Plataforma(pos.add(new Vec2(p.s.x,0)), p.s, PlataformaTipo.ESPACIO));
        espacios++;
      }
      else if(k==1){
        plataformas.add(new Plataforma(pos.add(new Vec2(p.s.x,GeneracionOffset(pos))), p.s, PlataformaTipo.INICIO));
        espacios = 0;
      }
      
  }
  
     p = plataformas.get(plataformas.size()-1);
     p.SetVelocidad(v);     
     
     if(p.t == PlataformaTipo.ESPACIO)
       return;     
     pos = box.getBodyPixelCoord(p.b);
     
     Probabilidad pi = new Probabilidad(30,70);
     if(pi.Next() == 0){
         
       Probabilidad at = new Probabilidad(10,5,25,25,40,30);
       CabezaTipo tipo = CabezaTipo.RANA;
       int tp = at.Next();
       
       switch(tp){
        case 0:
        tipo = CabezaTipo.TREX;
        break;
        case 1:
        tipo = CabezaTipo.ALIEN; 
        break;
        case 2:
        tipo = CabezaTipo.CARACOL; 
        break;
        case 3:
        tipo = CabezaTipo.GATO; 
        break;
        case 4:
        tipo = CabezaTipo.RANA;
        break;
        case 5:
        tipo = CabezaTipo.CHIVA;
        break;
      }
     
      
        items.add(new CabezaItem( pos.add(new Vec2(0,-p.s.y)), new Vec2(32,32), tipo, 30));
        CabezaItem i = items.get(items.size()-1);
        i.SetVelocidad(v);      
       
     }
   
}

float GeneracionOffset(Vec2 pos){

      float r = 0;
        Probabilidad pr = new Probabilidad(20,80);
        float k = pr.Next();        
        if(k == 1){
          if((pos.y+height/16) < altura)
            r = random(0,height/4);
          if((pos.y-height/16) > altura)
            r = random(-height/4,0);
          else 
            r = random(-height/8,height/8);
        }        
      return r;

}
void Destruir(){
  
  Plataforma p = plataformas.get(0);    
  Vec2 pos = box.getBodyPixelCoord(p.b);   
  if( !((pos.x+p.s.x) > 0)){      
    box.destroyBody(p.b);
    plataformas.remove(0);
  }
    
  if(items.size() > 0){  
    CabezaItem i = items.get(0);  
    pos = box.getBodyPixelCoord(i.b);   
    if( !((pos.x+i.s.x) > 0))      {    
      box.destroyBody(i.b);
      items.remove(0);  
    }
  }
  
  pos = box.getBodyPixelCoord(cabeza.b);
  if((pos.x+cabeza.s.x/2) < 0 || (pos.y-cabeza.s.y/2) > height){
    box.destroyBody(cabeza.b);
    FinalSetup();  
  }
  
}
void JugandoKeyPressed(){  
  if(key==' ')
      cabeza.IniciarSalto();        
}
void JugandoKeyReleased(){  
  if(key==' ')
      cabeza.FinalizarSalto();        
}

  //______________________________________________________________________________ESTADO_FINAL
  
void FinalSetup(){
  
  estado = Estado.FINAL;

      
  
  for(Plataforma p : plataformas)
    box.destroyBody(p.b); 
  for(CabezaItem i : items)
    box.destroyBody(i.b);
  
  plataformas.clear();
  items.clear(); 


  avatar = new Avatar(cabeza.tp);
  avatar.SetSeleccion(cabeza.tp,CabezaEstado.MUERTA);
  

  titulo   = new Mensaje(" GAME OVER",createFont("EraserDust", 32),25, color(255));
  instruccion = new Mensaje("PRESIONA [ESPACIO] PARA REINICIAR",createFont("Gill Sans MT", 18),14, color(255));
  puntaje = new Mensaje("SCORE : " + score + "          MEJOR SCORE : " + bestscore,createFont("Gill Sans MT", 18),14, color(255));

  
} 
void FinalDraw(){

  image(fondo[2],0,0);  
 
  titulo.Display(width/4+40,height/16);
  puntaje.Display(width/4+40,height/4);
  instruccion.Display(width/4,height - 32);
  
  float s = 128 + sin(0.2*frameCount)*32;  
  avatar.display(width/2-s/2,height/2-s/2,s,s);
  
}
void FinalKey(){  
  if(key==' ')
      SeleccionSetup();      
}
