
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb OCDR=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

typedef char *va_list;

#pragma used+

char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);
int printf(char flash *fmtstr,...);
int sprintf(char *str, char flash *fmtstr,...);
int vprintf(char flash * fmtstr, va_list argptr);
int vsprintf(char *str, char flash * fmtstr, va_list argptr);

char *gets(char *str,unsigned int len);
int snprintf(char *str, unsigned int size, char flash *fmtstr,...);
int vsnprintf(char *str, unsigned int size, char flash * fmtstr, va_list argptr);

int scanf(char flash *fmtstr,...);
int sscanf(char *str, char flash *fmtstr,...);

#pragma used-

#pragma library stdio.lib

#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm

#pragma used+

void _lcd_ready(void);
void _lcd_write_data(unsigned char data);

void lcd_write_byte(unsigned char addr, unsigned char data);

unsigned char lcd_read_byte(unsigned char addr);

void lcd_gotoxy(unsigned char x, unsigned char y);

void lcd_clear(void);
void lcd_putchar(char c);

void lcd_puts(char *str);

void lcd_putsf(char flash *str);

unsigned char lcd_init(unsigned char lcd_columns);

void lcd_control (unsigned char control);

#pragma used-
#pragma library lcd.lib

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

eeprom int rast90;
eeprom int chap90;
unsigned int timer=0;
void stop (void);

unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (0x00 & 0xff);

delay_us(10);

ADCSRA|=0x40;

while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}

void bazoo (void)
{
PORTB.5=0;PORTB.4=0;PORTB.0=0;PORTB.1=0;
delay_ms(2000);
PORTB.6=1;PORTB.7=0;
while(PINC.4==1);
PORTB.6=0;PORTB.7=0;
PORTD.0=0;PORTD.1=1;
delay_ms(1000);
PORTD.0=0;PORTD.1=0;
}

int cnt,num;
void r_90 (unsigned int i)   
{                        
PORTB.3=1;
PORTB.5=1;PORTB.4=0;PORTB.0=0;PORTB.1=1;
delay_ms(i);            
}

void l_90 (unsigned int j)    
{
PORTB.3=1;
PORTB.5=0;PORTB.4=1;PORTB.0=1;PORTB.1=0;
delay_ms(j);
}

void rast_gard (void)
{
PORTB.5=1;PORTB.4=0;PORTB.0=0;PORTB.1=1;
r_90(rast90);
stop();
for(cnt=0;cnt<=18;cnt++)
{
PORTB.5=0;PORTB.4=0;PORTB.0=1;PORTB.1=0;
delay_ms(350);
PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
delay_ms(25);
if(PINA!=0)
{
PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
delay_ms(250);
PORTB.5=1;PORTB.4=0;PORTB.0=0;PORTB.1=1;
delay_ms(400);
break;
}
}
stop();

}

void chap_gard (void)
{
PORTB.5=0;PORTB.4=1;PORTB.0=1;PORTB.1=0;
l_90(chap90);
stop();
for(num=0;num<=18;num++)
{
PORTB.5=1;PORTB.4=0;PORTB.0=0;PORTB.1=0;
delay_ms(350);
PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
delay_ms(25);
if (PINA!=0)
{
PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
delay_ms(250);
PORTB.5=0;PORTB.4=1;PORTB.0=1;PORTB.1=0;
delay_ms(700);
break;
}
}
stop();

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
PORTB.3=1;
if(dis_j<9)
{
stop();
PORTB.5=0;PORTB.4=1;PORTB.0=0;PORTB.1=1;
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
bit reach=0;    
while ((PINC.3==1 && PINC.2==1) || (PINC.1==1 && PINC.0==1))
{
if (PINC.3==1 && PINC.1==1 && PINC.2==1 && PINC.0==1)
{PORTB.0=0;PORTB.1=1;PORTB.5=0;PORTB.4=1;}
else if ((PINC.3==0 || PINC.2==0) && PINC.1==1 && PINC.0==1)
{PORTB.0=1;PORTB.1=0;PORTB.5=0;PORTB.4=1;reach=1;} 
else if ((PINC.1==0 || PINC.0==0) && PINC.3==1 && PINC.2==1)
{PORTB.0=0;PORTB.1=1;PORTB.5=1;PORTB.4=0;reach=1;}
if(reach==1)
{
timmer++;
delay_ms(1);
}
if (timmer>3000)
break;
}
PORTB.0=0;PORTB.1=0;PORTB.5=0;PORTB.4=0;
delay_ms(200);
}
void eslah_jelo (void)
{
unsigned int timmer=0;
bit reach=0;    
while (PINC.2==1 || PINC.0==1)
{
if (PINC.2==1 && PINC.0==1)
{PORTB.0=1;PORTB.1=0;PORTB.5=1;PORTB.4=0;}
else if (PINC.2==0 && PINC.0==1)
{PORTB.0=0;PORTB.1=1;PORTB.5=1;PORTB.4=0;reach=1;} 
else if (PINC.2==1 && PINC.0==0)
{PORTB.0=1;PORTB.1=0;PORTB.5=0;PORTB.4=1;reach=1;}
if(reach==1)
{
timmer++;
delay_ms(1);
}
if (timmer>3000)
break;
}
PORTB.0=0;PORTB.1=0;PORTB.5=0;PORTB.4=0;
delay_ms(200);
}

void free_victim(void)
{  
stop();
PORTD.1=1;
PORTD.0=0;
delay_ms(700);
PORTB.3=0;
lcd_gotoxy(0,0);
lcd_putsf(":D VICTIM on STAGE :D");
lcd_gotoxy(0,1);
lcd_putsf("# VICTIM LIFT #");
delay_ms(5000);
lcd_clear();

PORTB.3=1;
PORTB.5=0;PORTB.4=1;PORTB.0=0;PORTB.1=1;
delay_ms(3000);
stop();

PORTB.3=0;
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
PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
ultra_sonic();
if((dis_j>15)&&(PINC.2==0||PINC.0==0))
{
eslah_jelo();
free_victim();
r_90(rast90);
if(dis_j<=15)
{
PORTB.5=1;PORTB.4=0;PORTB.0=0;PORTB.1=1;
r_90(rast90);
}

} 
}  
}

void find_victim (void)
{
ultra_sonic();
if((PINC.2==0||PINC.0==0||PINC.6==1||dis_chp<=6||dis_rp<=6)&&( dis_j>7))
{
if(PINC.2==0 && dis_j>7)
{
stop();
PORTB.5=0;PORTB.4=1;PORTB.0=0;PORTB.1=1;
delay_ms(1000);
stop();
PORTB.5=1;PORTB.4=0;PORTB.0=0;PORTB.1=1;
delay_ms(300); 
stop(); 
PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
while(PINC.6==0);
}
else if(PINC.0==0 && dis_j>7)
{
stop();
PORTB.5=0;PORTB.4=1;PORTB.0=0;PORTB.1=1;
delay_ms(1000);
stop();
PORTB.5=0;PORTB.4=1;PORTB.0=1;PORTB.1=0;
delay_ms(300);
stop(); 
PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
while(PINC.6==0);
} 
else if(dis_chp<=6)
{
stop();
PORTB.5=0;PORTB.4=1;PORTB.0=0;PORTB.1=1;
delay_ms(1000);
stop();
l_90(chap90);
stop();
PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
delay_ms(500);
stop();
r_90(rast90);
stop(); 
PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
while(PINC.6==0);
} 
else if(dis_rp<=6)
{
stop();
PORTB.5=0;PORTB.4=1;PORTB.0=0;PORTB.1=1;
delay_ms(1000);
stop();
r_90(rast90);
stop();
PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
delay_ms(500);
stop();
l_90(chap90);
stop();
PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
while(PINC.6==0);
}  
else if(PINC.6==1)
{
stop();
PORTD.1=0;
PORTD.0=1;
delay_ms(500);
PORTD.1=0;
PORTD.0=0;
PORTB.7=1;
PORTB.6=0;
while(PINC.5==1);
PORTB.7=0;PORTB.6=0;  
PORTD.0=1;
PORTD.1=0;
PORTB.6=1;
PORTB.7=0;
while(PINC.4==1);
PORTB.7=0;PORTB.6=0;
find_stage();
}
}
}                                                                   

void red_room(void)
{
while(1)
{
PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
ultra_sonic();
while(dis_j>=8)
{
find_victim();
ultra_sonic();
delay_ms(50);
ultra_sonicb();  
if((dis_rp+dis_chp<65) && (dis_rb+dis_chb>=65)) 
{
if(dis_rp<dis_chp)
{
stop();
PORTB.3=0;                                                                 
lcd_gotoxy(0,0);
lcd_putsf(" VICTIM ");
delay_ms(2000);
lcd_clear();
PORTB.3=1;
PORTB.5=1;PORTB.4=0;PORTB.0=0;PORTB.1=1;
r_90(rast90);
stop();
PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
find_victim();
}
else
{ 
stop();
PORTB.3=0;
lcd_gotoxy(0,0);
lcd_putsf(" VICTIM ");
delay_ms(2000);
lcd_clear();
PORTB.3=1; 
PORTB.5=0;PORTB.4=1;PORTB.0=1;PORTB.1=0;
l_90(chap90);
stop();
PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
find_victim();
}
}  
}
eslah_jelo();
stop();
PORTB.5=0;PORTB.4=1;PORTB.0=0;PORTB.1=1;
delay_ms(1000);
stop();
PORTB.5=1;PORTB.4=0;PORTB.0=0;PORTB.1=1;
r_90(rast90);
stop();
PORTB.5=1;PORTB.4=0;PORTB.0=0;PORTB.1=1;
r_90(rast90);
stop();
eslah_aghab();
PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
delay_ms(3000);
stop();

ultra_sonic();
if(dis_rp+dis_chp>90)  
{
if(dis_rp<dis_chp)
{
PORTB.5=1;PORTB.4=0;PORTB.0=0;PORTB.1=1;
r_90(rast90);
stop();
}
else
{
PORTB.5=0;PORTB.4=1;PORTB.0=1;PORTB.1=0;
l_90(chap90);
stop();
}
PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
l_90(chap90);
stop();
}
PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
delay_ms(4000);
stop();
}
}                                                                    

char text[40];
float S0,S1,S2,S3,S4,S5,S6,S7;

void stop (void)
{
PORTB.5=~PORTB.5;PORTB.4=~PORTB.4;PORTB.0=~PORTB.0;PORTB.1=~PORTB.1;
delay_ms(80);
PORTB.5=0;PORTB.4=0;PORTB.0=0;PORTB.1=0;
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
PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
ultra_sonic();
while ((dis_j>8) && (PINC.2==1 && PINC.0==1))
ultra_sonic();  

eslah_jelo();
stop();
PORTB.5=0;PORTB.4=1;PORTB.0=0;PORTB.1=1;
delay_ms(700);
stop();
PORTB.5=1;PORTB.4=0;PORTB.0=0;PORTB.1=1;
r_90(rast90);
stop();
eslah_aghab();
delay_ms(500);
eslah_aghab();

PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
delay_ms(1000);
stop();

PORTB.3=0;
lcd_putsf("  RED ROOM  ");
lcd_gotoxy(0,0);
delay_ms(1000);
lcd_clear();

PORTB.3=1;
PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
delay_ms(1000);
stop();

PORTB.5=1;PORTB.4=0;PORTB.0=0;PORTB.1=1;
r_90(rast90);
stop();
eslah_aghab();
delay_ms(500);
eslah_aghab();
delay_ms(1000);

PORTB.5=1;PORTB.4=0;PORTB.0=1;PORTB.1=0;
delay_ms(3000);
stop();

PORTB.5=0;PORTB.4=1;PORTB.0=1;PORTB.1=0;
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
{PORTB.0=1;PORTB.1=0;PORTB.5=1;PORTB.4=0;}

else if (PINA==0b00000001 || PINA==0b00000011 || PINA==0b00000010 || PINA==0b00000110 ||
PINA==0b00000111 || PINA==0b00001110 || PINA==0b00011100 || PINA==0b00001111 )
{PORTB.0=1;PORTB.1=0;PORTB.5=0;PORTB.4=1;}

else if (PINA==0b00000100)    
{
{PORTB.0=1;PORTB.1=0;PORTB.5=0;PORTB.4=1;}

}
else if (PINA==0b00001001 || PINA==0b00001011 || PINA==0b00001010 || PINA==0b00001110 || PINA==0b00001101
|| PINA==0b00010001 || PINA==0b00010011 || PINA==0b00010010 || PINA==0b00010110 
|| PINA==0b00011001 || PINA==0b00011011 || PINA==0b00011010 || PINA==0b00011110
|| PINA==0b00110001 || PINA==0b00110011 || PINA==0b00110010 || PINA==0b00110110 )
{
stop();
PORTB.3=0;
delay_ms(10);
PORTB.3=1;
{PORTB.0=1;PORTB.1=0;PORTB.5=1;PORTB.4=0;};

while (PINA!=0);
stop();
PORTB.3=0;
delay_ms(10);
PORTB.3=1;
{PORTB.0=1;PORTB.1=0;PORTB.5=0;PORTB.4=1;}
while (PINA.0==0);
}

else if (PINA==0b01000001 || PINA==0b01100001 || PINA==0b00100001 || PINA==0b00110001
|| PINA==0b00100010 || PINA==0b00110010 || PINA==0b01000110 )

{PORTB.0=1;PORTB.1=0;PORTB.5=1;PORTB.4=0;}

else if (PINA==0b10000000 || PINA==0b11000000 || PINA==0b01000000 || PINA==0b01100000 || PINA==0b00110000
|| PINA==0b11100000 || PINA==0b01110000 || PINA==0b00111000 || PINA==0b11110000 )
{PORTB.0=0;PORTB.1=1;PORTB.5=1;PORTB.4=0;}

else if (PINA==0b00100000)    
{
{PORTB.0=0;PORTB.1=1;PORTB.5=1;PORTB.4=0;}

}

else if (PINA==0b10010000 || PINA==0b11010000 || PINA==0b01010000 || PINA==0b01110000 || PINA==0b10110000 
|| PINA==0b10001000 || PINA==0b11001000 || PINA==0b01001000 || PINA==0b01101000 
|| PINA==0b10011000 || PINA==0b11011000 || PINA==0b01011000 || PINA==0b01111000 
|| PINA==0b10001100 || PINA==0b11001100 || PINA==0b01001100 || PINA==0b01101100 )
{
stop();
PORTB.3=0;
delay_ms(10);
PORTB.3=1;
{PORTB.0=1;PORTB.1=0;PORTB.5=1;PORTB.4=0;};

while (PINA!=0);
stop();
PORTB.3=0;
delay_ms(10);
PORTB.3=1;
{PORTB.0=0;PORTB.1=1;PORTB.5=1;PORTB.4=0;}
while (PINA.7==0);
}
else if (PINA==0b10000010 || PINA==0b10000110 || PINA==0b10000100 || PINA==0b10001100 || PINA==0b01000100 || PINA==0b01001100 || PINA==0b01100010 )
{PORTB.0=1;PORTB.1=0;PORTB.5=1;PORTB.4=0;}

else if(PINA==0);    
else {PORTB.0=1;PORTB.1=0;PORTB.5=1;PORTB.4=0;}             
sathe_shibdar();

}

void right90(void)
{
lcd_clear();
while (1)
{
PORTB.3=0;
sprintf(text," 90 rast=%4d ",rast90);
lcd_gotoxy(0,0);
lcd_puts(text);

if (PINC.2==0)
{
rast90+=100;
delay_ms(250);
}
else if (PINC.3==0)
{
delay_ms(250);
rast90+=10;
}
else if (PINC.0==0)
{
rast90-=100;
delay_ms(250);
}
else if (PINC.1==0)
{
rast90-=10;
delay_ms(250);
}
else if (PINC.6==1)
{
while (PINC.6==1);
delay_ms(300);
PORTB.3=1;

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
PORTB.3=0;
sprintf(text," 90 chap=%4d ",chap90);
lcd_gotoxy(0,0);
lcd_puts(text);

if (PINC.2==0)
{
chap90+=100;
delay_ms(250);
}
else if (PINC.3==0)
{
delay_ms(250);
chap90+=10;
}
else if (PINC.0==0)
{
chap90-=100;
delay_ms(250);
}
else if (PINC.1==0)
{
chap90-=10;
delay_ms(250);
}
else if (PINC.6==1)
{
while (PINC.6==1);
delay_ms(300);
PORTB.3=1;

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
PORTB.3=0;
lcd_gotoxy(0,0);
sprintf(text,"%d%d%d%d %d%d%d%d",PINA.0,PINA.1,PINA.2,PINA.3,PINA.4,PINA.5,PINA.6,PINA.7); 
lcd_puts(text);
lcd_gotoxy(0,1);
sprintf(text,"Victim=%d ",PINC.6);
lcd_puts(text);
delay_ms(100);
if(PINC.3==0)
{
while(PINC.3==0);
break;
}
}
lcd_clear();

while (1)
{
PORTB.3=0;
lcd_gotoxy(0,0);
lcd_putsf("LU LD RU RD D U");
lcd_gotoxy(0,1);
sprintf(text,"%d %d %d %d %d %d",PINC.0,PINC.1,PINC.2,PINC.3,PINC.5,PINC.4);
lcd_puts(text);
delay_ms(100);
if(PINC.3==0)
{
while(PINC.3==0);
break;
}
}
lcd_clear();

while (1)
{
PORTB.3=0;
ultra_sonic(); 
lcd_gotoxy(0,0);
sprintf(text," %3d %3d %3d ",dis_rp,dis_j,dis_chp);
lcd_puts(text);

if(PINC.3==0)
{
while(PINC.3==0);
break;
}
}
lcd_clear();

while(1)   
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
PORTB.3=0;
sprintf(text,"%1.1f %1.1f %1.1f %1.1f %1.1f %1.1f %1.1f %1.1f",S0,S1,S2,S3,S4,S5,S6,S7);
lcd_gotoxy(0,0);
lcd_puts(text);
if(PINC.3==0)
{
while(PINC.3==0);
break;
}
}
lcd_clear(); 
}

int cntr=0;           

void main(void)              
{

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
ADMUX=0x00 & 0xff;
ADCSRA=0x83;

PORTB.3=0;
lcd_init(16);
PORTB=0xFF;
PORTB.3=1;

if(chap90==-1)
chap90=580;

if (rast90==-1)
rast90=570;

if (PINC.0==0)
{
while(PINC.0==0);
tanzimat();
}

if (PINC.3==0)
{
while(PINC.3==0);
right90();
}

if (PINC.2==0)
{
while(PINC.2==0);
bazoo();
}

if (PINC.1==0)
{
while(PINC.1==0);
chap_90();
}  

while (1)
{
for(cntr=0;cntr<8000;cntr++)
{
path_finder();
}
block();

};
}
