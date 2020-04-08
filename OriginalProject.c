/*
 * ProjectCAD.c
 *
 * Created: 10/03/2020 06:09:42 p. m.
 * Author: ALVARO AND DIEGO   
 *
 * VERSION 3.0
 *
 */

#include <io.h>
#include <delay.h>



unsigned int numpasos = 0;
unsigned int prev     = 0;
unsigned int curre    = 0;
unsigned int entry    = 0;
unsigned int i = 0;
unsigned int validation = 0;


//ENTRADAS
//PIND.2 PushButton Se�al de paso
//PIND.4 DipSwitch Sentido paso derecho  
//PIND.5 Dipswitch Entrada pulso continuo 
//PIND.6 Dipswitch Bloqueo Sentido Salida
//PIND.7 Dipswitch Autorizaci�n Multipulsos
//PINC.2 Microswitch Posici�n Reposo 
//PINC.3 Microswitch Giro Derecho
//PINC.4 Microswitch Giro Izquierdo

//SALIDAS
//PINC.5 Bloqueo electroim�n (Salida para solenoide)



void main(void)
{

DDRD  = 0x00; //DipSwitch entrada y push 
PORTD = 0xF4; //Pull up para dipswitches y pushbutton
DDRC  = 0x20; //Salida solenoide y microswitches entrada
PORTC = 0x1C; //Pull up en microswitches 

TCNT1H= 0xEC; //Contador 65536 -60653  inicia en 60653 para contar 4883 veces , .001024 segundos por cuenta
TCNT1L= 0xED; //Se pone 60653 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
  

while (1)
    {              
       while (PIND.4 == 0){  // PASO SENTIDO DERECHO
        if (PINC.2 != 0){//Microswitch reposo //salio de reposo   
                        if(PIND.6 == 0){//Bloqueo de salida activado o tambi�n el de entrada
                              PORTC.5 = 1; //Activa martillo 
                              delay_ms (200);
                              PORTC.5 = 0; //Desactiva martillo
                        }   
                        else{
                               while(PINC.3 == 0){//Mientras est� intentando entrar activa martillo  
                                    PORTC.5 = 1; //Activa martillo 
                                    delay_ms (200);
                                    PORTC.5 = 0; //Desactiva martillo
                               }
                          
                        }  
                    }   
               while(PIND.5 == 1 && PIND.4 == 0){//Pulso continuo no activo y Paso sentido derecho   
                    if (PINC.2 != 0){//Microswitch reposo salio de reposo   
                        if(PIND.6 == 0){//Bloqueo de salida activado o tambi�n el de entrada
                              PORTC.5 = 1; //Activa martillo  
                              delay_ms (200);
                              PORTC.5 = 0; //Desactiva martillo
                        }   
                        else{
                               while(PINC.3 == 0){//Mientras est� intentando entrar activa martillo  
                                    PORTC.5 = 1; //Activa martillo 
                                    delay_ms (200);
                                    PORTC.5 = 0; //Desactiva martillo
                               }
                          
                        }  
                    }   
                     if (PIND.7 == 0){//MODO MULTIPULSO  
                       
                        if(PIND.2 == 1)
                           validation = 1; 
                        if(PIND.2 == 0 && validation == 1){ // Se�al de paso
                           validation = 0;
                           numpasos++; 
                     
                          
                           
                          //DEFINICION DE RELOJ a 5s 
                           TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024  
                           
                           while(TIFR1.TOV1==0){ //Mientras la bandera de overflow no sea 1  
                                   
                             
                             if(numpasos == 5)
                                break;
                             
                             if(PINC.2 == 1 && PINC.3 == 0){ 
                                prev = 1;
                                break;
                             }
                             
                             if(PIND.2 == 1) // Se�al de paso 
                                validation = 1; 
                             if(PIND.2 == 0 && validation == 1){ // Se�al de paso
                               validation = 0;                
                               numpasos++;
                               TIFR1.TOV1=1;//Resetea la bandera de overflow
                               TCNT1H= 0xEC; //Contador 65536 -60653  inicia en 60653 para contar 4883 veces , .001024 segundos por cuenta
                               TCNT1L= 0xED; //Se pone 60653 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L 
                             }       
                           } 
                           TCCR1B=0;       //Apagar timer 1 

                           
                          
                           for (i=0;i<numpasos;i++){ 
                                 TIFR1.TOV1=1;//Resetea la bandera de overflow
                                 TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024  
                                 TCNT1H= 0xD9; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 segundos por cuenta
                                 TCNT1L= 0xD9; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
                                //TIENE 10 s para pasar
                                while(TIFR1.TOV1==0){//mientras la bandera de overflow no sea 1
                                    if(PINC.2 == 1 && PINC.4 == 0 && prev == 0){ // Para evitar que haga sentido opuesto
                                       while(PINC.4 == 0){//Mientras est� intentando entrar activa martillo  
                                            PORTC.5 = 1; //Activa martillo 
                                            delay_ms (200);
                                            PORTC.5 = 0; //Desactiva martillo
                                       }
                                    }   
                                      
                                    if(PINC.3 == 0)
                                        prev  = 1;

                                    if(PINC.4 == 0)
                                        curre = 1; 
                                          
                                    if(prev == 1 && curre == 1 && PINC.2 == 0){
                                       entry=1;
                                       prev = 0;
                                       curre = 0;
                                       break;
                                    }              
                                }
                                
                                if(entry == 0){ //Checa la bandera de si el usuario pas�  
                                    break;
                                }
                           } 
                           TCCR1B=0;       //Apagar timer
                           numpasos=0;
                         } 
                       }  
                    else{
                         if(PIND.2 == 1)
                           validation = 1; 
                         if(PIND.2 == 0 && validation == 1){ // Se�al de paso
                           validation = 0;
                           numpasos = 1; 
                           
                            
                             TIFR1.TOV1=1;//Resetea la bandera de overflow
                             TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024  
                             TCNT1H= 0xD9; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 segundos por cuenta
                             TCNT1L= 0xD9; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
                            //TIENE 10 s para pasar
                             while(TIFR1.TOV1==0){//mientras la bandera de overflow no sea 1 
                                if(PINC.2 == 1 && PINC.4 == 0 && prev == 0){ // Para evitar que haga sentido opuesto
                                   while(PINC.4 == 0){//Mientras est� intentando entrar activa martillo  
                                        PORTC.5 = 1; //Activa martillo 
                                        delay_ms (200);
                                        PORTC.5 = 0; //Desactiva martillo
                                   }
                                }   
                                          
                                if(PINC.3 == 0)
                                    prev  = 1;

                                if(PINC.4 == 0)
                                    curre = 1; 
                                           
                                        
                                if(prev == 1 && curre == 1 && PINC.2 == 0){
                                    entry=1;
                                    prev = 0;
                                    curre = 0;
                                    break;
                                }              
                            }     
                           TCCR1B=0;       //Apagar timer
                           numpasos=0;
                        }  
                    } 
               
               }                
              while (PIND.2 == 0){ //Mientras se�al de pulso activada 
                    
                   if(PINC.2 == 1 && PINC.4 == 0 && prev == 0 && PIND.6 == 0){ // Para evitar que haga sentido opuesto
                            while(PINC.4 == 0){//Mientras est� intentando entrar activa martillo  
                                PORTC.5 = 1; //Activa martillo 
                                delay_ms (200);
                                PORTC.5 = 0; //Desactiva martillo
                            }
                   }   
                                          
                   if(PINC.3 == 0)
                      prev  = 1;

                   if(PINC.4 == 0)
                      curre = 1; 
                                           
                                        
                   if(prev == 1 && curre == 1 && PINC.2 == 0){
                      prev = 0;
                      curre = 0;
                  }     
              }
              
        }   

       while (PIND.4 == 1){ //PASO SENTIDO IZQUIERDO
         if (PINC.2 != 0){//Microswitch reposo //salio de reposo   
                        if(PIND.6 == 0){//Bloqueo de salida activado o tambi�n el de entrada
                              PORTC.5 = 1; //Activa martillo 
                              delay_ms (200);
                              PORTC.5 = 0; //Desactiva martillo
                        }   
                        else{
                               while(PINC.4 == 0){//Mientras est� intentando entrar activa martillo  
                                    PORTC.5 = 1; //Activa martillo 
                                    delay_ms (200);
                                    PORTC.5 = 0; //Desactiva martillo
                               }
                          
                        }  
                    }   
               while(PIND.5 == 1 && PIND.4 == 1){//Pulso continuo no activo y Paso sentido izquierdo 
                    if (PINC.2 != 0){//Microswitch reposo salio de reposo   
                        if(PIND.6 == 0){//Bloqueo de salida activado o tambi�n el de entrada
                              PORTC.5 = 1; //Activa martillo  
                              delay_ms (200);
                              PORTC.5 = 0; //Desactiva martillo
                        }   
                        else{
                               while(PINC.4 == 0){//Mientras est� intentando entrar activa martillo  
                                    PORTC.5 = 1; //Activa martillo 
                                    delay_ms (200);
                                    PORTC.5 = 0; //Desactiva martillo
                               }
                          
                        }  
                    }   
                     if (PIND.7 == 0){//MODO MULTIPULSO  
                       
                        if(PIND.2 == 1)
                           validation = 1; 
                        if(PIND.2 == 0 && validation == 1){ // Se�al de paso
                           validation = 0;
                           numpasos++; 
                        
                           
                          //DEFINICION DE RELOJ a 5s 
                           TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024  
                           
                           while(TIFR1.TOV1==0){ //Mientras la bandera de overflow no sea 1  
                             if(PIND.2 == 1) // Se�al de paso 
                                validation = 1;   
                             
                             if(numpasos == 5)
                                break;
                             
                             if(PINC.2 == 1 && PINC.4 == 0){ 
                                prev = 1;
                                break;
                             }
                             
                             if(PIND.2 == 0 && validation == 1){ // Se�al de paso
                               validation = 0; 
                               numpasos++;
                               TIFR1.TOV1=1;//Resetea la bandera de overflow
                               TCNT1H= 0xEC; //Contador 65536 -60653  inicia en 60653 para contar 4883 veces , .001024 segundos por cuenta
                               TCNT1L= 0xED; //Se pone 60653 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L 
                             }       
                           } 
                           TCCR1B=0;       //Apagar timer 

                                                
                           for (i=0;i<numpasos;i++){ 
                                 TIFR1.TOV1=1;//Resetea la bandera de overflow
                                 TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024  
                                 TCNT1H= 0xD9; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 segundos por cuenta
                                 TCNT1L= 0xD9; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
                                //TIENE 10 s para pasar
                                while(TIFR1.TOV1==0){//mientras la bandera de overflow no sea 1
                                    if(PINC.2 == 1 && PINC.3 == 0 && prev == 0){ // Para evitar que haga sentido opuesto
                                       while(PINC.3 == 0){//Mientras est� intentando entrar activa martillo  
                                            PORTC.5 = 1; //Activa martillo 
                                            delay_ms (200);
                                            PORTC.5 = 0; //Desactiva martillo
                                       }
                                    }   
                                      
                                    if(PINC.4 == 0)
                                        prev  = 1;

                                    if(PINC.3 == 0)
                                        curre = 1; 
                                        
                                    if(prev == 1 && curre == 1 && PINC.2 == 0){
                                       entry=1;
                                       prev = 0;
                                       curre = 0;
                                       break;
                                    }              
                                }
                                
                                if(entry == 0){ //Checa la bandera de si el usuario pas�  
                                    break;
                                }
                           }
                           TCCR1B=0;       //Apagar timer
                           numpasos=0;
                         } 
                       }  
                    else{
                         if(PIND.2 == 1)
                           validation = 1; 
                         if(PIND.2 == 0 && validation == 1){ // Se�al de paso
                           validation = 0;
                           numpasos = 1; 
                            
                             TIFR1.TOV1=1;//Resetea la bandera de overflow
                             TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024  
                             TCNT1H= 0xD9; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 segundos por cuenta
                             TCNT1L= 0xD9; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
                            //TIENE 10 s para pasar
                             while(TIFR1.TOV1==0){//mientras la bandera de overflow no sea 1
                                if(PINC.2 == 1 && PINC.3 == 0 && prev == 0){ // Para evitar que haga sentido opuesto
                                   while(PINC.3 == 0){//Mientras est� intentando entrar activa martillo  
                                        PORTC.5 = 1; //Activa martillo 
                                        delay_ms (200);
                                        PORTC.5 = 0; //Desactiva martillo
                                   }
                                }   
                                          
                                if(PINC.4 == 0)
                                    prev  = 1;

                                if(PINC.3 == 0)
                                    curre = 1; 
                                           
                                        
                                if(prev == 1 && curre == 1 && PINC.2 == 0){
                                   entry=1;
                                   prev = 0;
                                   curre = 0;
                                   break;
                                }              
                            }
                                
                           TCCR1B=0;       //Apagar timer
                           numpasos=0;
                        }  
                    } 
               
               }          
              while (PIND.2==0){ //Mientras se�al de pulso activada
                    if(PINC.2 == 1 && PINC.3 == 0 && prev == 0 && PIND.6 == 0){ // Para evitar que haga sentido opuesto
                            while(PINC.3 == 0){//Mientras est� intentando entrar activa martillo  
                                PORTC.5 = 1; //Activa martillo 
                                delay_ms (200);
                                PORTC.5 = 0; //Desactiva martillo
                            }
                   }   
                                          
                   if(PINC.4 == 0)
                      prev  = 1;

                   if(PINC.3 == 0)
                      curre = 1; 
                                           
                                        
                   if(prev == 1 && curre == 1 && PINC.2 == 0){
                      prev = 0;
                      curre = 0;
                  }
              }
              
        }   
   }
}