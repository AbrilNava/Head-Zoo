class Avatar{
    
  CabezaTipo tipo;
  CabezaEstado estado;
  
  PGraphics imagen;    
  Avatar(CabezaTipo tipo){
    SetSeleccion(tipo,CabezaEstado.NORMAL);    
  }  
  private void crearavatar(){  
    imagen = createGraphics(256,256);
    imagen.beginDraw();
    
    int i=0,j=0;
    
     switch(tipo){
        case TREX:
          imagen.fill(255,0,0);
          i=0;
        break;
        case ALIEN:
           imagen.fill(0,255,0);
           i=1;
        break;
        case CARACOL:
            imagen.fill(0,0,255);
            i=2;
        break;            
        case GATO:
            imagen.fill(255,0,255);
            i=3;
        break;
        case RANA:
            imagen.fill(0,255,255);
            i=4;
        break;
        case CHIVA:
            imagen.fill(255,255,0);
            i=5;
        break;
      }
       switch(estado){
        case NORMAL:         
           j=0;
        break;
        case SALTANDO:           
           j=1;
        break;
        case MUERTA:            
           j=2;
        break;            
       }
      
      //imagen.rect(0,0,imagen.width,imagen.height);
      imagen.image(imagenes[i][j],0,0,imagen.width,imagen.height);
      imagen.endDraw();
          
  }  
  void display(float x,float y,float w,float h){
      image(imagen,x,y,w,h);              
  }
  
  void SetSeleccion(CabezaTipo tipo,CabezaEstado estado){
    this.tipo = tipo;
    this.estado = estado;
    crearavatar();
  }  
  
}
