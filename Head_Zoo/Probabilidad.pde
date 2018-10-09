

class Probabilidad{
  
  float []pb;
  
  Probabilidad(float... probabilidades){  
    pb = probabilidades;     
  }
  
  int Next(){
  
    float suma = 0;
    for(float p : pb )
        suma+=p;  
    float k = random(suma);
    
    suma = 0;
    int i = -1;
    while(suma < k)      
      suma += pb[++i];
        
    return i;
  }
  
  
}
