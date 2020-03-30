/*
 * ProjectCAD.c
 *
 * Created: 10/03/2020 06:09:42 p. m.
 * Author: ALVARO AND DIEGO
 */

#include <io.h>

unsigned int numpasos = 0;
unsigned int prevS    = 0;
unsigned int prev     = 0;
unsigned int curre    = 0;
unsigned int entry    = 0;

void main(void)
{
while (1)
    {              
       while (i5 = 1){  // PASO DERECHO
               while(i6 =0){//Pulso continuo no activo   
                    if (i1 != 1){//Microswitch reposo   
                        if(i7 == 1){//Bloqueo de salida activado o tambi�n el de entrada
                              martillo = 1; 
                              delay_ms (10000);
                              martillo = 0;
                        }   
                        else{  
                            if (i2 == 1){//Microswitch giro derecho  
                                if (prevS == 0){ //Switch previo, detecta que ya pas�  o no por i3
                                    while(i2 == 1){//Mientras est� intentando entrar activa martillo  
                                       martillo = 1; 
                                       delay_ms (10000);
                                       martillo = 0;
                                    }
                                }
         
                            }
                            if(i3 == 1){ //Microswitch giro izquierdo
                                prevS  = 1;       
                        }      
                        martillo = 0;  
                              
                    }  
                       
                     if (i8==1){//MODO MULTIPULSO  
                       
                       
                         if(i4 == 1){//Se�al de paso
                           numpasos++;
                           
                           //DEFINICION DE RELOJ a 5s 
                           TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024  
                           TCNT1H= 0xEC; //Contador 65536 -60653  inicia en 60653 para contar 4883 veces , .001024 segundos por cuenta
                           TCNT1L= 0xED; //Se pone 60653 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
                           do{ 
                             if(i4 == 1){
                               if(numpasos > 5){ 
                                  break;
                               }                
                               else{
                                  numpasos++;
                                  TIFR1.TOV1=1;//Resetea la bandera de overflow 
                                  TCCR1B = 0x05; //Lo inicia de nuevo 
                               }
                                
                    
                             }       
                           }while(TIFR0.TOV0==0) //Mientras la bandera de overflow no sea 1
                           TCCR1B=0;       //Apagar timer
                            

                           
                          
                           for (i=0;i<numpasos;i++){ 
                                 TIFR1.TOV1=1;//Resetea la bandera de overflow
                                 TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024  
                                 TCNT1H= 0xEC; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 segundos por cuenta
                                 TCNT1L= 0xED; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
                                //TIENE 10 s para pasar
                                while(TIFR0.TOV0==0){//mientras la bandera de overflow no sea 1 
                                    if(i1 == 0 && i3 == 1){
                                       while(i3 == 1){//Mientras est� intentando entrar activa martillo  
                                           martillo = 1; 
                                           delay_ms (10000);
                                           martillo = 0;
                                       }
                                    }   
                                    
                                    if(i2 == 1){
                                        prev  = 1;
                                        if(i3 == 1)
                                            curre = 1; 
                                    }   
                                    
                                    if(prev == 1 && curre == 1 && i1 == 1){ 
                                       entry=1;
                                       break;
                                    }              
                                }
                                if(entry==0){ //Checa la bandera de si el usuario pas�  
                                    break;
                                }
                           } 
                           TCCR1B=0;       //Apagar timer
                           numpasos=0;
                         } 
                       }  
                    else{
                           if(i4==1){
                                TIFR1.TOV1=1;//Resetea la bandera de overflow
                                TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024  
                                TCNT1H= 0xEC; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 segundos por cuenta
                                TCNT1L= 0xED; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
                                //TIENE 10 s para pasar
                                
                                while(TIFR0.TOV0==0){//mientras la bandera de overflow no sea 1 
                                    if(i1 == 0 && i3 == 1){
                                       while(i3 == 1){//Mientras est� intentando entrar activa martillo  
                                           martillo = 1; 
                                           delay_ms (10000);
                                           martillo = 0;
                                       }
                                    }   
                                    
                                    if(i2 == 1){
                                        prev  = 1;
                                        if(i3 == 1)
                                            curre = 1; 
                                    }   
                                    
                                    if(prev == 1 && curre == 1 && i1 == 1){ 
                                       break;
                                    }              
                                }
                                TCCR1B=0;       //Apagar timer
                           } 
                           numpasos=0;
                         } 
                    }
               
               }          
              while (i4==1){
                                martillo= 0;
            
              }
              
        }   

       while (i5 == 0){ //PASO SENTIDO IZQUIERDO
               while(i6 ==0){ //Pulso continuo no activado   
                    if (i1 != 1){ //Microswitch no en reposo 
                        if(i7 == 1){ // Bloqueo sentido de salida
                             martillo = 1; 
                             delay_ms (10000);
                             martillo = 0;
                        }   
                        else{  
                            if (i3 == 1){ // Microswitch giro izq. 
                                if (prevS == 0){
                                    while(i3 == 1){
                                       martillo = 1; 
                                       delay_ms (10000);
                                       martillo = 0;
                                    }
                                }
         
                            }
                            if(i2 == 1){ //Microswitch giro derecho
                                prevS  = 1;       
                        }      
                        martillo = 0;  
                              
                    }
                       
                     if (i8 == 1){ //MODO MULTIPULSO AUTORIZADO 
                       
                       
                         if(i4 == 1){//Se�al de pulso
                           numpasos++; 
                           //DEFINICION DE RELOJ a 5s 
                           TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024  
                           TCNT1H= 0xEC; //Contador 65536 -60653  inicia en 60653 para contar 4883 veces , .001024 segundos por cuenta
                           TCNT1L= 0xED; //Se pone 60653 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
                           do{ 
                             if(i4 == 1){ // se�al de paso
                               if(numpasos > 5){ 
                                  break;
                               }                
                               else{
                                  numpaso++; 
                                  TIFR1.TOV1=1;//Resetea la bandera de overflow 
                                  TCCR1B = 0x05; //Lo inicia de nuevo 
                               }
                             }       
                           }while(TIFR0.TOV0==0) //Mientras la bandera de overflow no sea 1 
                            TCCR1B=0;       //Apagar timer
                            
                          
                           for (i=0;i<numpasos;i++){  
                                 TIFR1.TOV1=1;//Resetea la bandera de overflow
                                 TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024  
                                 TCNT1H= 0xEC; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 segundos por cuenta
                                 TCNT1L= 0xED; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
                                //TIENE 10 s para pasar
                                
                                while(TIFR0.TOV0==0){//mientras la bandera de overflow no sea 1  
                                    if(i1 == 0 && i2 == 1){
                                       while(i2 == 1){//Mientras est� intentando entrar activa martillo  
                                           martillo = 1; 
                                           delay_ms (10000);
                                           martillo = 0;
                                       }
                                    }   
                                    
                                    if(i3 == 1){
                                        prev  = 1;
                                        if(i2 == 1)
                                            curre = 1; 
                                    }   
                                    
                                    if(prev == 1 && curre == 1 && i1 == 1){ 
                                       entry=1;
                                       break;
                                    }              
                                }
                                if(entry==0){   
                                    break;
                                }
                           }
                           TCCR1B=0;       //Apagar timer 
                           numpasos=0;
                         } 
                       }  
                    else{
                           if(i4 == 0){ //se�al de paso
                                 TIFR1.TOV1=1;//Resetea la bandera de overflow
                                 TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024  
                                 TCNT1H= 0xEC; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 segundos por cuenta
                                 TCNT1L= 0xED; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
                                //TIENE 10 s para pasar
                                
                                while(TIFR0.TOV0==0){//mientras la bandera de overflow no sea 1 
                                    if(i1 == 0 && i2 == 1){
                                       while(i2 == 1){//Mientras est� intentando entrar activa martillo  
                                           martillo = 1; 
                                           delay_ms (10000);
                                           martillo = 0;
                                       }
                                    }   
                                    
                                    if(i3 == 1){
                                        prev  = 1;
                                        if(i2 == 1)
                                            curre = 1; 
                                    }   
                                    
                                    if(prev == 1 && curre == 1 && i1 == 1){ 
                                       break;
                                    }              
                                }
                           } 
                           TCCR1B=0;       //Apagar timer
                           numpasos=0;
                         } 
                    }
               }          
              while (i4 == 1){ //se�al de paso
                                martillo=0;
              }
              
        }   
}
}    
 
 
 
 
 //#include <io.h>
//  DDRD = 0x0F; //DipSwitch entrada
//  PORTD=0xF0; //Pull up en bit 7 a 4 
//  unsigned char C1; //Numero de pasos autorizados
//  unsigned char acceso = 1; // Bandera de acceso 
