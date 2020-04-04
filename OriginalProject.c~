/*
 * ProjectCAD.c
 *
 * Created: 10/03/2020 06:09:42 p. m.
 * Author: ALVARO AND DIEGO
 */

#include <io.h>
#include <delay.h>

unsigned int numpasos = 0;
unsigned int prevS    = 0;
unsigned int prev     = 0;
unsigned int curre    = 0;
unsigned int entry    = 0;
unsigned int i = 0;

//ENTRADAS
//PIND.2 PushButton Señal de paso
//PIND.4 DipSwitch Sentido paso derecho  
//PIND.5 Dipswitch Entrada pulso continuo 
//PIND.6 Dipswitch Bloqueo Sentido Salida
//PIND.7 Dipswitch Autorización Multipulsos
//PINC.2 Microswitch Posición Reposo 
//PINC.3 Microswitch Giro Derecho
//PINC.4 Microswitch Giro Izquierdo

//SALIDAS
//PINC.1 Bloqueo electroimán (Salida para solenoide)

void main(void)
{

DDRD  = 0x0B; //DipSwitch entrada y push 
PORTD = 0xF4; //Pull up para dipswitches y pushbutton
DDRC  = 0x02; //Salida solenoide y microswitches entrada
PORTC = 0x1C; //Pull up en microswitches 

while (1)
    {              
       while (PIND.4 == 1){  // PASO DERECHO
               while(PIND.5 == 0){//Pulso continuo no activo   
                    if (PINC.2 != 1){//Microswitch reposo   
                        if(PIND.6 == 1){//Bloqueo de salida activado o también el de entrada
                              PORTC.1 = 1; //Activa martillo 
                              delay_ms (5000);
                              PORTC.1 = 0; //Desactiva martillo
                        }   
                        else{  
                            if (PINC.3 == 1){//Microswitch giro derecho  
                                if (prevS == 0){ //Switch previo, detecta que ya pasó  o no por PINC.4
                                    while(PINC.3 == 1){//Mientras esté intentando entrar activa martillo  
                                       PORTC.1 = 1; //Activa martillo 
                                       delay_ms (5000);
                                       PORTC.1 = 0; //Desactiva martillo
                                    }
                                }
         
                            }
                            if(PINC.4 == 1){ //Microswitch giro izquierdo
                                prevS  = 1;       
                        }      
                        PORTC.1 = 0; //Martillo desactivado
                              
                    }  
                       
                     if (PIND.7 == 1){//MODO MULTIPULSO  
                       
                       
                         if(PIND.2 == 1){//Señal de paso
                           numpasos++;
                           
                           //DEFINICION DE RELOJ a 5s 
                           TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024  
                           TCNT1H= 0xEC; //Contador 65536 -60653  inicia en 60653 para contar 4883 veces , .001024 segundos por cuenta
                           TCNT1L= 0xED; //Se pone 60653 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
                           do{ 
                             if(PIND.2 == 1){ // Señal de paso
                               if(numpasos > 5){ 
                                  break;
                               }                
                               else{
                                  numpasos++;
                                  TIFR1.TOV1=1;//Resetea la bandera de overflow 
                                  TCCR1B = 0x05; //Lo inicia de nuevo 
                               }
                                
                    
                             }       
                           }while(TIFR0.TOV0==0); //Mientras la bandera de overflow no sea 1     
                           
                           TCCR1B=0;       //Apagar timer
                                 
                           for (i=0;i<numpasos;i++){ 
                                 TIFR1.TOV1=1;//Resetea la bandera de overflow
                                 TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024  
                                 TCNT1H= 0xD9; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 segundos por cuenta
                                 TCNT1L= 0xD9; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
                                //TIENE 10 s para pasar
                                while(TIFR0.TOV0==0){//mientras la bandera de overflow no sea 1 
                                    if(PINC.2 == 0 && PINC.4 == 1){
                                       while(PINC.4 == 1){//Mientras esté intentando entrar activa martillo  
                                            PORTC.1 = 1; //Activa martillo 
                                            delay_ms (5000);
                                            PORTC.1 = 0; //Desactiva martillo
                                       }
                                    }   
                                    
                                    if(PINC.3 == 1){
                                        prev  = 1;
                                        if(PINC.4 == 1)
                                            curre = 1; 
                                    }   
                                    
                                    if(prev == 1 && curre == 1 && PINC.2 == 1){ 
                                       entry=1;
                                       break;
                                    }              
                                }
                                if(entry == 0){ //Checa la bandera de si el usuario pasó  
                                    break;
                                }
                           } 
                           TCCR1B=0;       //Apagar timer
                           numpasos=0;
                         } 
                       }  
                    else{
                           if(PIND.2==1){ //Señal de paso
                                TIFR1.TOV1=1;//Resetea la bandera de overflow
                                TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024  
                                TCNT1H= 0xD9; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 segundos por cuenta
                                TCNT1L= 0xD9; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
                                //TIENE 10 s para pasar
                                
                                while(TIFR0.TOV0==0){//mientras la bandera de overflow no sea 1 
                                    if(PINC.2 == 0 && PINC.4 == 1){
                                       while(PINC.4 == 1){//Mientras esté intentando entrar activa martillo  
                                            PORTC.1 = 1; //Activa martillo 
                                            delay_ms (5000);
                                            PORTC.1 = 0; //Desactiva martillo
                                       }
                                    }   
                                    
                                    if(PINC.3 == 1){
                                        prev  = 1;
                                        if(PINC.4 == 1)
                                            curre = 1; 
                                    }   
                                    
                                    if(prev == 1 && curre == 1 && PINC.2 == 1){ 
                                       break;
                                    }              
                                }
                                TCCR1B=0;       //Apagar timer
                           } 
                           numpasos=0;
                         } 
                    }
               
               }          
              while (PIND.2==1){ //Mientras señal de pulso activada
                    PORTC.1 = 0; //Martillo desactivado
              }
              
        }   

       while (PIND.4 == 0){ //PASO SENTIDO IZQUIERDO
               while(PIND.5 ==0){ //Pulso continuo no activado   
                    if (PINC.2 != 1){ //Microswitch no en reposo 
                        if(PIND.6 == 1){ // Bloqueo sentido de salida
                            PORTC.1 = 1; //Activa martillo 
                            delay_ms (5000);
                            PORTC.1 = 0; //Desactiva martillo
                        }   
                        else{  
                            if (PINC.4 == 1){ // Microswitch giro izq. 
                                if (prevS == 0){
                                    while(PINC.4 == 1){
                                            PORTC.1 = 1; //Activa martillo 
                                            delay_ms (5000);
                                            PORTC.1 = 0; //Desactiva martillo
                                    }
                                }
         
                            }
                            if(PINC.3 == 1){ //Microswitch giro derecho
                                prevS  = 1;       
                        }      
                        PORTC.1 = 0; //Martillo  
                              
                    }
                       
                     if (PIND.7 == 1){ //MODO MULTIPULSO AUTORIZADO 
                       
                       
                         if(PIND.2 == 1){//Señal de pulso
                           numpasos++; 
                           //DEFINICION DE RELOJ a 5s 
                           TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024  
                           TCNT1H= 0xEC; //Contador 65536 -60653  inicia en 60653 para contar 4883 veces , .001024 segundos por cuenta
                           TCNT1L= 0xED; //Se pone 60653 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
                           do{ 
                             if(PIND.2 == 1){ // señal de paso
                               if(numpasos > 5){ 
                                  break;
                               }                
                               else{
                                  numpasos++; 
                                  TIFR1.TOV1=1;//Resetea la bandera de overflow 
                                  TCCR1B = 0x05; //Lo inicia de nuevo 
                               }
                             }       
                           }while(TIFR0.TOV0==0); //Mientras la bandera de overflow no sea 1 
                            TCCR1B=0;       //Apagar timer
                            
                          
                           for (i=0;i<numpasos;i++){  
                                 TIFR1.TOV1=1;//Resetea la bandera de overflow
                                 TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024  
                                 TCNT1H= 0xD9; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 segundos por cuenta
                                 TCNT1L= 0xD9; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
                                //TIENE 10 s para pasar
                                
                                while(TIFR0.TOV0==0){//mientras la bandera de overflow no sea 1  
                                    if(PINC.2 == 0 && PINC.3 == 1){
                                       while(PINC.3 == 1){//Mientras esté intentando entrar activa martillo  
                                            PORTC.1 = 1; //Activa martillo 
                                            delay_ms (5000);
                                            PORTC.1 = 0; //Desactiva martillo
                                       }
                                    }   
                                    
                                    if(PINC.4 == 1){
                                        prev  = 1;
                                        if(PINC.3 == 1)
                                            curre = 1; 
                                    }   
                                    
                                    if(prev == 1 && curre == 1 && PINC.2 == 1){ 
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
                           if(PIND.2 == 0){ //señal de paso
                                 TIFR1.TOV1=1;//Resetea la bandera de overflow
                                 TCCR1B= 0x05; //Enciende timer 1 en modo normal con prescalador CK/1024  
                                 TCNT1H= 0xD9; //Contador 65536 - 55769 inicia en 55769 para contar 9767 veces , .001024 segundos por cuenta
                                 TCNT1L= 0xD9; //Se pone 55769 dividido en los 8MSB para TCNT1H y los 8LSB para TCNT1L
                                //TIENE 10 s para pasar
                                
                                while(TIFR0.TOV0==0){//mientras la bandera de overflow no sea 1 
                                    if(PINC.2 == 0 && PINC.3 == 1){
                                       while(PINC.3 == 1){//Mientras esté intentando entrar activa martillo  
                                            PORTC.1 = 1; //Activa martillo 
                                            delay_ms (5000);
                                            PORTC.1 = 0; //Desactiva martillo
                                       }
                                    }   
                                    
                                    if(PINC.4 == 1){
                                        prev  = 1;
                                        if(PINC.3 == 1)
                                            curre = 1; 
                                    }   
                                    
                                    if(prev == 1 && curre == 1 && PINC.2 == 1){ 
                                       break;
                                    }              
                                }
                           } 
                           TCCR1B=0;       //Apagar timer
                           numpasos=0;
                         } 
                    }
               }          
              while (PIND.2 == 1){ //Señal de paso
                                PORTC.1=0;
              }
              
        }   
}
}