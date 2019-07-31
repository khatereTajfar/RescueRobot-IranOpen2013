#include <mega16.h>
#include <stdio.h>
#define R1 PORTB.0
#define R2 PORTB.1
#define L1 PORTB.5
#define L2 PORTB.4
#define ELB PORTB.6
#define ELP PORTB.7
#define KCHB PINC.0
#define KCHP PINC.1
#define KRB PINC.2
#define KRP PINC.3
#define ENR PIND.6
#define ENCH PIND.7

#define DCL PORTD.0
#define DOP PORTD.1
#define MASDOUM PINC.6
#define KB PINC.4
#define KP PINC.5
#define LCD PORTB.3=0
#define MOTOR PORTB.3=1

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>

#include <delay.h>

#define ADC_VREF_TYPE 0x00
eeprom int rast90;
eeprom int chap90;
     unsigned int timer=0;
void stop (void);

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}

// Declare your global variables here
void bazoo (void)
{
L1=0;L2=0;R1=0;R2=0;
delay_ms(2000);
ELB=1;ELP=0;
while(KB==1);
ELB=0;ELP=0;
DCL=0;DOP=1;
delay_ms(1000);
DCL=0;DOP=0;
}
         
int cnt,num;
void r_90 (unsigned int i)   //in tabe be jaye encodere moteghayyere i(moteghayyere delaye) toye tabe right_90 tanzim mishe  
    {                        //adade rast_90 (moteghayyere eeprom tabe right_90) har chi shod be hamun andaze delay ijad mishe 
     MOTOR;
     L1=1;L2=0;R1=0;R2=1;
     delay_ms(i);            //in dasture delaye 
    }

void l_90 (unsigned int j)    //in tabe moshabehe tabe r_90 ast
    {
     MOTOR;
     L1=0;L2=1;R1=1;R2=0;
     delay_ms(j);
    }
    
void rast_gard (void)
    {
     L1=1;L2=0;R1=0;R2=1;
     r_90(rast90);
     stop();
     for(cnt=0;cnt<=18;cnt++)
     {
      L1=0;L2=0;R1=1;R2=0;
      delay_ms(350);
      L1=1;L2=0;R1=1;R2=0;
      delay_ms(25);
      if(PINA!=0)
          {
           L1=1;L2=0;R1=1;R2=0;
           delay_ms(250);
           L1=1;L2=0;R1=0;R2=1;
           delay_ms(400);
           break;
          }
     }
     stop();
     //L1=1;L2=0;R1=0;R2=1;
     //en_chap(rast90);
    }
    
void chap_gard (void)
    {
     L1=0;L2=1;R1=1;R2=0;
     l_90(chap90);
     stop();
     for(num=0;num<=18;num++)
     {
      L1=1;L2=0;R1=0;R2=0;
      delay_ms(350);
      L1=1;L2=0;R1=1;R2=0;
      delay_ms(25);
      if (PINA!=0)
          {
           L1=1;L2=0;R1=1;R2=0;
           delay_ms(250);
           L1=0;L2=1;R1=1;R2=0;
           delay_ms(700);
           break;
          }
     }
     stop();
     //L1=0;L2=1;R1=1;R2=0;
     //en_chap(chap90);
    } 
      
int dis_j , dis_chp, dis_rp, dis_chb, dis_rb;
void ultra_sonicb (void)
    {
    DDRD.5=1;
    PORTD.5=1;
    delay_us(20);
    PORTD.5=0;
    DDRD.5=0;
    while (PIND.5==0 );
    TCNT1=0;
    while (PIND.5==1 );
    dis_chb= TCNT1 /58 ;
    DDRC.7=1;
    PORTC.7=1;
    delay_us(20);
    PORTC.7=0;
    DDRC.7=0;
    while (PINC.7==0 );
    TCNT1=0;
    while (PINC.7==1 );
    dis_rb= TCNT1 /58 ;
    delay_ms(25);
    }

void ultra_sonic (void)
    {
     DDRD.4=1;
     PORTD.4=1;
     delay_us(20);
     PORTD.4=0;
     DDRD.4=0;
     while (PIND.4==0 );
     TCNT1=0;
     while (PIND.4==1 );
     dis_j= TCNT1 /58 ;
     
     DDRD.3=1;
     PORTD.3=1;
     delay_us(20);
     PORTD.3=0;
     DDRD.3=0;
     while (PIND.3==0 );
     TCNT1=0;
     while (PIND.3==1 );         
     dis_chp= TCNT1 /58 ;
     
     DDRD.2=1;
     PORTD.2=1;
     delay_us(20);
     PORTD.2=0;
     DDRD.2=0;
     while (PIND.2==0 );
     TCNT1=0;
     while (PIND.2==1 );
     dis_rp= TCNT1 /58 ;
     delay_ms(25);
    }
     
void block (void)     
    {
     DDRD.4=1;
     PORTD.4=1;
     delay_us(20);
     PORTD.4=0;
     DDRD.4=0;
     while (PIND.4==0 );
     TCNT1=0;
     while (PIND.4==1 );
     dis_j= TCNT1 /58 ;
     MOTOR;
     if(dis_j<9)
        {
         stop();
         L1=0;L2=1;R1=0;R2=1;
         delay_ms(250);
         
         ultra_sonic();
         if(dis_chp<=dis_rp)
            {
            rast_gard();
            }

         if(dis_chp>dis_rp)
            {
            chap_gard();
            }
        }
    }

void eslah_aghab (void)
    {
    unsigned int timmer=0;
    bit reach=0;    // means robot reach the wall so timmer should start
    while ((KRP==1 && KRB==1) || (KCHP==1 && KCHB==1))
        {
        if (KRP==1 && KCHP==1 && KRB==1 && KCHB==1)
            {R1=0;R2=1;L1=0;L2=1;}
        else if ((KRP==0 || KRB==0) && KCHP==1 && KCHB==1)
            {R1=1;R2=0;L1=0;L2=1;reach=1;} 
        else if ((KCHP==0 || KCHB==0) && KRP==1 && KRB==1)
            {R1=0;R2=1;L1=1;L2=0;reach=1;}
        if(reach==1)
            {
            timmer++;
            delay_ms(1);
            }
        if (timmer>3000)
            break;
        }
    R1=0;R2=0;L1=0;L2=0;
    delay_ms(200);
    }
void eslah_jelo (void)
    {
    unsigned int timmer=0;
    bit reach=0;    // means robot reach the wall so timmer should start
    while (KRB==1 || KCHB==1)
        {
        if (KRB==1 && KCHB==1)
            {R1=1;R2=0;L1=1;L2=0;}
        else if (KRB==0 && KCHB==1)
            {R1=0;R2=1;L1=1;L2=0;reach=1;} 
        else if (KRB==1 && KCHB==0)
            {R1=1;R2=0;L1=0;L2=1;reach=1;}
        if(reach==1)
            {
            timmer++;
            delay_ms(1);
            }
        if (timmer>3000)
            break;
        }
    R1=0;R2=0;L1=0;L2=0;
    delay_ms(200);
    }
    
//void dont_victim_hand_free (void)
//    {
//     DCL=0;DOP=1;
//     delay_ms(1000);
//     DCL=0;DOP=0;
//     ELB=1;ELP=0;
//     while(KB==1);
//     ELB=0;ELP=0;
//    }
    
//int count;
//void free_victim (void)   
//    {                
//     L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//     delay_ms(80);
//     L1=0;L2=0;R1=0;R2=0;
//     delay_ms(200);
//     
//     ELP=1;ELB=0;
//     delay_ms(1000);
//     ELP=0;ELB=0;

//     DOP=1;DCL=0;
//     delay_ms(1000);
//     DOP=0;DCL=0;
//     
//     
//     delay_ms(2000);
//     L1=0;L2=1;R1=0;R2=1;
//     en_chap(80);
//     L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//     delay_ms(80);
//     L1=0;L2=0;R1=0;R2=0;
//     delay_ms(200);
//     
//     LCD;
//     lcd_putsf("  END  ");
//     lcd_gotoxy(0,0);
//     lcd_gotoxy(0,1);
//     lcd_putsf(" SALAM SABZ ");
//     
//     
//     
//     while (1);
//    }

/*
void find_stage (void)
    {
     while (1)
         {
          eslah_aghab();
          if(KCHP==0 || KRP==0)
              free_victim();
          L1=1;L2=0;R1=1;R2=0;
          en_rast(50);
          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
          delay_ms(80);
          L1=0;L2=0;R1=0;R2=0;
          delay_ms(200);
          
          L1=1;L2=0;R1=0;R2=1;
          en_rast(rast90);
              
         }
    }*/ 
   
//void find_stage (void)
//    {
//     while (1)
//         {
//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//          delay_ms(80);
//          L1=0;L2=0;R1=0;R2=0;
//          delay_ms(200);
//           
//          L1=0;L2=1;R1=0;R2=1;
//          en_chap(chap90);
//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//          delay_ms(80);
//          L1=0;L2=0;R1=0;R2=0;
//          delay_ms(200);
//          
//          L1=1;L2=0;R1=0;R2=1;
//          en_chap(rast90);
//          
//          L1=1;L2=0;R1=1;R2=0;
//          en_chap(210);
//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//          delay_ms(80);
//          L1=0;L2=0;R1=0;R2=0;
//          delay_ms(200);
//          
//          L1=0;L2=1;R1=1;R2=0;
//          en_chap(chap90);
//          
//          L1=1;L2=0;R1=1;R2=0;
//          en_chap(150);
//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//          delay_ms(80);
//          L1=0;L2=0;R1=0;R2=0;
//          delay_ms(200);
//          
//          L1=1;L2=0;R1=0;R2=1;
//          en_chap(50);
//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//          delay_ms(80);
//          L1=0;L2=0;R1=0;R2=0;
//          delay_ms(200);
//          delay_ms(1000);
//          
//          
//          L1=0;L2=1;R1=1;R2=0;
//          en_chap(50);
//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//          delay_ms(80);
//          L1=0;L2=0;R1=0;R2=0;
//          delay_ms(200);
//          
//          L1=0;L2=1;R1=0;R2=1;
//          en_chap(110);
//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//          delay_ms(80);
//          L1=0;L2=0;R1=0;R2=0;
//          delay_ms(200);
//          
//          L1=1;L2=0;R1=0;R2=1;
//          en_chap(rast90);
//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//          delay_ms(80);
//          L1=0;L2=0;R1=0;R2=0;
//          delay_ms(1000);
//          L1=1;L2=0;R1=0;R2=1;
//          en_chap(rast90);
//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//          delay_ms(80);
//          L1=0;L2=0;R1=0;R2=0;
//          delay_ms(1000);
//          
//          L1=1;L2=0;R1=1;R2=0;
//          en_chap(120);
//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//          delay_ms(80);
//          L1=0;L2=0;R1=0;R2=0;
//          delay_ms(200);
//          
//          L1=0;L2=1;R1=1;R2=0;
//          en_chap(40);
//          L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//          delay_ms(80);
//          L1=0;L2=0;R1=0;R2=0;
//          delay_ms(1000);
//          
//          eslah_jelo();
//          free_victim();  
//            
//         }
//    }     
    


//void block_redroom (void)
//    {
//     ultra_sonic();
//     if (MASDOUM==0 && dis_j<=6)
//         {L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//         delay_ms(80);
//         L1=0;L2=0;R1=0;R2=0;
//         delay_ms(200);
//         L1=0;L2=1;R1=0;R2=1;
//         en_rast(25);
//         L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//         delay_ms(80);
//         L1=0;L2=0;R1=0;R2=0;
//         delay_ms(200);
//         L1=1;L2=0;R1=0;R2=1;
//         en_rast(rast90);
//         L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//         delay_ms(80);
//         L1=0;L2=0;R1=0;R2=0;
//         delay_ms(200);
//         L1=1;L2=0;R1=1;R2=0;
//         }
//    } 

//void red_room (void)
//    {
//    L1=1;L2=0;R1=1;R2=0;
//    en_chap (180);
//    stop();
//    delay_ms(200);
//    
//    L1=0;L2=1;R1=1;R2=0;
//    en_chap (chap90);
//    stop();
//    
//    L1=1;L2=0;R1=1;R2=0;
//    while(MASDOUM==0);
//    L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//    delay_ms(150);
//    L1=0;L2=0;R1=0;R2=0;
//    delay_ms(200);
//    
//    
//    DCL=1;DOP=0;
//    delay_ms(500);
//    DCL=0;DOP=0;
//    ELP=1;ELB=0;
//    while(KP==1);
//    ELP=0;ELB=0;
//                
//    DCL=1;DOP=0;
//    ELB=1;ELP=0;
//    while(KB==1);
//    ELB=0;ELP=0;
//                    
//    find_stage();
//    }

 void free_victim(void)
    {  
     stop();
     DOP=1;
     DCL=0;
     delay_ms(700);
     LCD;
     lcd_gotoxy(0,0);
     lcd_putsf(":D VICTIM on STAGE :D");
     lcd_gotoxy(0,1);
     lcd_putsf("# VICTIM LIFT #");
     delay_ms(5000);
     lcd_clear();
     
     MOTOR;
     L1=0;L2=1;R1=0;R2=1;
     delay_ms(3000);
     stop();
     
     LCD;
     lcd_gotoxy(0,0);                          
     lcd_putsf("Z FINISH Z") ;
     lcd_gotoxy(0,0);
     lcd_putsf("SALAM SABZ");
     while(1);
    }
 
 void find_stage(void)
{
    while(1)
    {
    L1=1;L2=0;R1=1;R2=0;
    ultra_sonic();
    if((dis_j>15)&&(KRB==0||KCHB==0))
        {
        eslah_jelo();
        free_victim();
        r_90(rast90);
         if(dis_j<=15)
             {
              L1=1;L2=0;R1=0;R2=1;
              r_90(rast90);
             }
         
        } 
    }  
}

void find_victim (void)
    {
    ultra_sonic();
    if((KRB==0||KCHB==0||MASDOUM==1||dis_chp<=6||dis_rp<=6)&&( dis_j>7))
        {
          if(KRB==0 && dis_j>7)
            {
            stop();
            L1=0;L2=1;R1=0;R2=1;
            delay_ms(1000);
            stop();
            L1=1;L2=0;R1=0;R2=1;
            delay_ms(300); 
            stop(); 
            L1=1;L2=0;R1=1;R2=0;
            while(MASDOUM==0);
            }
        else if(KCHB==0 && dis_j>7)
            {
            stop();
            L1=0;L2=1;R1=0;R2=1;
            delay_ms(1000);
            stop();
            L1=0;L2=1;R1=1;R2=0;
            delay_ms(300);
            stop(); 
            L1=1;L2=0;R1=1;R2=0;
            while(MASDOUM==0);
            } 
        else if(dis_chp<=6)
             {
            stop();
            L1=0;L2=1;R1=0;R2=1;
            delay_ms(1000);
            stop();
            l_90(chap90);
            stop();
            L1=1;L2=0;R1=1;R2=0;
            delay_ms(500);
            stop();
            r_90(rast90);
            stop(); 
            L1=1;L2=0;R1=1;R2=0;
            while(MASDOUM==0);
            } 
        else if(dis_rp<=6)
             {
             stop();
             L1=0;L2=1;R1=0;R2=1;
             delay_ms(1000);
             stop();
             r_90(rast90);
             stop();
             L1=1;L2=0;R1=1;R2=0;
             delay_ms(500);
             stop();
             l_90(chap90);
             stop();
             L1=1;L2=0;R1=1;R2=0;
             while(MASDOUM==0);
             }  
        else if(MASDOUM==1)
             {
             stop();
             DOP=0;
             DCL=1;
             delay_ms(500);
             DOP=0;
             DCL=0;
             ELP=1;
             ELB=0;
             while(KP==1);
             ELP=0;ELB=0;  
             DCL=1;
             DOP=0;
             ELB=1;
             ELP=0;
             while(KB==1);
             ELP=0;ELB=0;
             find_stage();
             }
        }
   }                                                                   
                                                                    
void red_room(void)
    {
     while(1)
        {
         L1=1;L2=0;R1=1;R2=0;
         ultra_sonic();
         while(dis_j>=8)
             {
              find_victim();
              ultra_sonic();
              delay_ms(50);
              ultra_sonicb();  //ba in dastour ultra sonicaye balaye fa'al mishan baraye tashkhise mane az masdoum 
              if((dis_rp+dis_chp<65) && (dis_rb+dis_chb>=65)) //age faseleye sensoraye paein kamtar az 65 shod va faseleye balayea bishtar az 65 shod yani masdoume
                 {
                  if(dis_rp<dis_chp)
                      {
                      stop();
                      LCD;                                                                 
                      lcd_gotoxy(0,0);
                      lcd_putsf(" VICTIM ");
                      delay_ms(2000);
                      lcd_clear();
                      MOTOR;
                      L1=1;L2=0;R1=0;R2=1;
                      r_90(rast90);
                      stop();
                      L1=1;L2=0;R1=1;R2=0;
                      find_victim();
                      }
                  else
                     { 
                      stop();
                      LCD;
                      lcd_gotoxy(0,0);
                      lcd_putsf(" VICTIM ");
                      delay_ms(2000);
                      lcd_clear();
                      MOTOR; 
                      L1=0;L2=1;R1=1;R2=0;
                      l_90(chap90);
                      stop();
                      L1=1;L2=0;R1=1;R2=0;
                      find_victim();
                     }
                 }  
             }
         eslah_jelo();
         stop();
         L1=0;L2=1;R1=0;R2=1;
         delay_ms(1000);
         stop();
         L1=1;L2=0;R1=0;R2=1;
         r_90(rast90);
         stop();
         L1=1;L2=0;R1=0;R2=1;
         r_90(rast90);
         stop();
         eslah_aghab();
         L1=1;L2=0;R1=1;R2=0;
         delay_ms(3000);
         stop();
         
         ultra_sonic();
         if(dis_rp+dis_chp>90)  
             {
              if(dis_rp<dis_chp)
                 {
                  L1=1;L2=0;R1=0;R2=1;
                  r_90(rast90);
                  stop();
                 }
              else
                 {
                  L1=0;L2=1;R1=1;R2=0;
                  l_90(chap90);
                  stop();
                 }
              L1=1;L2=0;R1=1;R2=0;
              l_90(chap90);
              stop();
             }
         L1=1;L2=0;R1=1;R2=0;
         delay_ms(4000);
         stop();
        }
    }                                                                    

char text[40];
float S0,S1,S2,S3,S4,S5,S6,S7;
//char silver;
//void silver_lent (void)
//    {
//     S0=read_adc(0);
//     S0=S0*5/1023;
//     S1=read_adc(1);
//     S1=S1*5/1023;
//     S2=read_adc(2);
//     S2=S2*5/1023;
//     S3=read_adc(3);
//     S3=S3*5/1023;
//     S4=read_adc(4);
//     S4=S4*5/1023;
//     S5=read_adc(5);
//     S5=S5*5/1023;
//     S6=read_adc(6);
//     S6=S6*5/1023;
//     S7=read_adc(7);
//     S7=S7*5/1023;
//     
//     if(S0<0.3)  silver++;
//     if(S1<0.3)  silver++;
//     if(S2<0.3)  silver++;
//     if(S3<0.3)  silver++;
//     if(S4<0.3)  silver++;
//     if(S5<0.3)  silver++;
//     if(S6<0.3)  silver++;
//     if(S7<0.3)  silver++;

//     if(silver>3)
//     {
//      LCD;
//      lcd_putsf("red_room");
//      delay_ms(1000);
//      lcd_clear();
//      MOTOR;
//      L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//      delay_ms(200);
//      L1=0;L2=0;R1=0;R2=0;
//      delay_ms(200);
//      eslah_aghab();
//      
//      L1=1;L2=0;R1=1;R2=0;
//      en_rast(150);
//      L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//      delay_ms(200);
//      L1=0;L2=0;R1=0;R2=0;
//      delay_ms(200);
//      
//      L1=1;L2=0;R1=0;R2=1;
//      en_rast(92);
//      L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//      delay_ms(200);
//      L1=0;L2=0;R1=0;R2=0;
//      delay_ms(200);
//      eslah_aghab();
//      
//      L1=1;L2=0;R1=1;R2=0;
//      en_rast(150);
//      L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//      delay_ms(200);
//      L1=0;L2=0;R1=0;R2=0;
//      delay_ms(200);
//      
//      L1=0;L2=1;R1=1;R2=0;
//      en_rast(82);
//      L1=~L1;L2=~L2;R1=~R1;R2=~R2;
//      delay_ms(200);
//      L1=0;L2=0;R1=0;R2=0;
//      delay_ms(200);
//      eslah_aghab();
//      red_room();
//     }
//    }

void stop (void)
    {
     L1=~L1;L2=~L2;R1=~R1;R2=~R2;
     delay_ms(80);
     L1=0;L2=0;R1=0;R2=0;
     delay_ms(100);
    }

void sathe_shibdar (void)
    {
     if(PINA==0)
         {     
          timer++;
          delay_ms(1);
         }
         
     if(PINA!=0)
          timer=0;
     if(timer>=3000)     
        { 
        L1=1;L2=0;R1=1;R2=0;
        ultra_sonic();
        while ((dis_j>8) && (KRB==1 && KCHB==1))
               ultra_sonic();  
                   
        eslah_jelo();
        stop();
        L1=0;L2=1;R1=0;R2=1;
        delay_ms(700);
        stop();
        L1=1;L2=0;R1=0;R2=1;
        r_90(rast90);
        stop();
        eslah_aghab();
        delay_ms(500);
        eslah_aghab();
                               
        L1=1;L2=0;R1=1;R2=0;
        delay_ms(1000);
        stop();
                                               
        LCD;
        lcd_putsf("  RED ROOM  ");
        lcd_gotoxy(0,0);
        delay_ms(1000);
        lcd_clear();
                                               
        MOTOR;
        L1=1;L2=0;R1=1;R2=0;
        delay_ms(1000);
        stop();
                                 
        L1=1;L2=0;R1=0;R2=1;
        r_90(rast90);
        stop();
        eslah_aghab();
        delay_ms(500);
        eslah_aghab();
        delay_ms(1000);
                                 
        L1=1;L2=0;R1=1;R2=0;
        delay_ms(3000);
        stop();
                                 
        L1=0;L2=1;R1=1;R2=0;
        l_90(chap90);
        stop();
        eslah_aghab();
        delay_ms(1000);
        red_room();
        }
                
    }
         
         
void path_finder (void)
    { 
     if (PINA==0b00010000 || PINA==0b00001000 || PINA==0b00011000 || PINA==0b00110000 || PINA==0b00001100 )
        {R1=1;R2=0;L1=1;L2=0;}
        
     else if (PINA==0b00000001 || PINA==0b00000011 || PINA==0b00000010 || PINA==0b00000110 ||
          PINA==0b00000111 || PINA==0b00001110 || PINA==0b00011100 || PINA==0b00001111 )
        {R1=1;R2=0;L1=0;L2=1;}
                  
     else if (PINA==0b00000100)    // baraye inke avale boridegi robot dor nazane
                {
                {R1=1;R2=0;L1=0;L2=1;}
//                while (PINA==0b00000100);
//                {R1=1;R2=0;L1=1;L2=0;};
                }
     else if (PINA==0b00001001 || PINA==0b00001011 || PINA==0b00001010 || PINA==0b00001110 || PINA==0b00001101
          || PINA==0b00010001 || PINA==0b00010011 || PINA==0b00010010 || PINA==0b00010110 
          || PINA==0b00011001 || PINA==0b00011011 || PINA==0b00011010 || PINA==0b00011110
          || PINA==0b00110001 || PINA==0b00110011 || PINA==0b00110010 || PINA==0b00110110 )
                {
                stop();
                LCD;
                delay_ms(10);
                MOTOR;
                {R1=1;R2=0;L1=1;L2=0;};
                // bayad sorat kam beshe inja
                while (PINA!=0);
                stop();
                LCD;
                delay_ms(10);
                MOTOR;
                {R1=1;R2=0;L1=0;L2=1;}
                while (PINA.0==0);
                }
        
     else if (PINA==0b01000001 || PINA==0b01100001 || PINA==0b00100001 || PINA==0b00110001
          || PINA==0b00100010 || PINA==0b00110010 || PINA==0b01000110 )
        
        {R1=1;R2=0;L1=1;L2=0;}

     else if (PINA==0b10000000 || PINA==0b11000000 || PINA==0b01000000 || PINA==0b01100000 || PINA==0b00110000
          || PINA==0b11100000 || PINA==0b01110000 || PINA==0b00111000 || PINA==0b11110000 )
        {R1=0;R2=1;L1=1;L2=0;}
    
     else if (PINA==0b00100000)    // baraye inke avale boridegi robot dor nazane
                {
                {R1=0;R2=1;L1=1;L2=0;}
//                while (PINA==0b00100000);
//                {R1=1;R2=0;L1=1;L2=0;};
                }
                
     else if (PINA==0b10010000 || PINA==0b11010000 || PINA==0b01010000 || PINA==0b01110000 || PINA==0b10110000 
          || PINA==0b10001000 || PINA==0b11001000 || PINA==0b01001000 || PINA==0b01101000 
          || PINA==0b10011000 || PINA==0b11011000 || PINA==0b01011000 || PINA==0b01111000 
          || PINA==0b10001100 || PINA==0b11001100 || PINA==0b01001100 || PINA==0b01101100 )
                {
                stop();
                LCD;
                delay_ms(10);
                MOTOR;
                {R1=1;R2=0;L1=1;L2=0;};
                // bayad sorat kam beshe inja
                while (PINA!=0);
                stop();
                LCD;
                delay_ms(10);
                MOTOR;
                {R1=0;R2=1;L1=1;L2=0;}
                while (PINA.7==0);
                }
     else if (PINA==0b10000010 || PINA==0b10000110 || PINA==0b10000100 || PINA==0b10001100 || PINA==0b01000100 || PINA==0b01001100 || PINA==0b01100010 )
        {R1=1;R2=0;L1=1;L2=0;}

     else if(PINA==0);    
     else {R1=1;R2=0;L1=1;L2=0;}             
     sathe_shibdar();
     
    }

void right90(void)
    {
    lcd_clear();
    while (1)
        {
        LCD;
        sprintf(text," 90 rast=%4d ",rast90);
        lcd_gotoxy(0,0);
        lcd_puts(text);
            
        if (KRB==0)
            {
             rast90+=100;
             delay_ms(250);
            }
        else if (KRP==0)
            {
            delay_ms(250);
            rast90+=10;
            }
        else if (KCHB==0)
            {
            rast90-=100;
            delay_ms(250);
            }
        else if (KCHP==0)
            {
            rast90-=10;
            delay_ms(250);
            }
        else if (MASDOUM==1)
            {
            while (MASDOUM==1);
            delay_ms(300);
            MOTOR;
            //R1=0;R2=1;L1=1;L2=0;ELB=0;ELP=0;
            r_90(rast90);
            stop();
            }

        if (rast90<10)
            rast90=10;
        }
    }     
       
void chap_90(void)
    {
    lcd_clear();
    while (1)
        {
        LCD;
        sprintf(text," 90 chap=%4d ",chap90);
        lcd_gotoxy(0,0);
        lcd_puts(text);
            
        if (KRB==0)
            {
            chap90+=100;
            delay_ms(250);
            }
        else if (KRP==0)
            {
            delay_ms(250);
            chap90+=10;
            }
        else if (KCHB==0)
            {
            chap90-=100;
            delay_ms(250);
            }
        else if (KCHP==0)
            {
            chap90-=10;
            delay_ms(250);
            }
        else if (MASDOUM==1)
            {
            while (MASDOUM==1);
            delay_ms(300);
            MOTOR;
            //R1=1;R2=0;L1=0;L2=1;ELB=0;ELP=0;
            l_90(chap90);
            stop();
            }

        if (chap90<10)
            chap90=10;
        }
    }     


void tanzimat (void)
  {
   while (1)
       {
        LCD;
        lcd_gotoxy(0,0);
        sprintf(text,"%d%d%d%d %d%d%d%d",PINA.0,PINA.1,PINA.2,PINA.3,PINA.4,PINA.5,PINA.6,PINA.7); 
        lcd_puts(text);
        lcd_gotoxy(0,1);
        sprintf(text,"Victim=%d ",MASDOUM);
        lcd_puts(text);
        delay_ms(100);
        if(KRP==0)
            {
             while(KRP==0);
             break;
            }
       }
       lcd_clear();
   
   while (1)
       {
        LCD;
        lcd_gotoxy(0,0);
        lcd_putsf("LU LD RU RD D U");
        lcd_gotoxy(0,1);
        sprintf(text,"%d %d %d %d %d %d",KCHB,KCHP,KRB,KRP,KP,KB);
        lcd_puts(text);
        delay_ms(100);
        if(KRP==0)
            {
             while(KRP==0);
             break;
            }
       }
       lcd_clear();
       
   while (1)
     {
      LCD;
      ultra_sonic(); 
      lcd_gotoxy(0,0);
      sprintf(text," %3d %3d %3d ",dis_rp,dis_j,dis_chp);
      lcd_puts(text);
     //lcd_gotoxy(0,1);
     //sprintf(text,"%3d %3d",dis_chb,dis_chp);
     //lcd_puts(text);
     //delay_ms(100);
      if(KRP==0)
          {
           while(KRP==0);
           break;
          }
     }
     lcd_clear();
     
     while(1)   //in tabe marbut be tanzimate adc e ke faghat tanzim mishe too barname estefade nashode azash
         {
          S0=read_adc(0);
          S0=S0*5/1023;
          S1=read_adc(1);
          S1=S1*5/1023;
          S2=read_adc(2);
          S2=S2*5/1023;
          S3=read_adc(3);
          S3=S3*5/1023;
          S4=read_adc(4);
          S4=S4*5/1023;
          S5=read_adc(5);
          S5=S5*5/1023;
          S6=read_adc(6);
          S6=S6*5/1023;
          S7=read_adc(7);
          S7=S7*5/1023;
          LCD;
          sprintf(text,"%1.1f %1.1f %1.1f %1.1f %1.1f %1.1f %1.1f %1.1f",S0,S1,S2,S3,S4,S5,S6,S7);
          lcd_gotoxy(0,0);
          lcd_puts(text);
          if(KRP==0)
              {
               while(KRP==0);
               break;
              }
         }
     lcd_clear(); 
  }

int cntr=0;           
         
void main(void)              
{
// Declare your local variables here
PORTA=0x00;
DDRA=0x00;

PORTB=0xFF;
DDRB=0xFF;

PORTC=0xFF;
DDRC=0x00;

PORTD=0x00;
DDRD=0x00;

TCCR1A=0x00;
TCCR1B=0x02;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

TIMSK=0x00;
ACSR=0x80;
SFIOR=0x00;
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x83;

LCD;
lcd_init(16);
PORTB=0xFF;
MOTOR;

if(chap90==-1)
   chap90=580;

if (rast90==-1)
    rast90=570;
    
if (KCHB==0)
    {
     while(KCHB==0);
     tanzimat();
    }
    
if (KRP==0)
    {
     while(KRP==0);
     right90();
    }

if (KRB==0)
    {
     while(KRB==0);
     bazoo();
    }

if (KCHP==0)
    {
     while(KCHP==0);
     chap_90();
    }  

//MOTOR;
//r_90(10000);
//bazoo();
//red_room();    

while (1)
      {
       for(cntr=0;cntr<8000;cntr++)
            {
            path_finder();
            }
       block();

         
            
      };
}
