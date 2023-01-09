#line 1 "E:/walid/temperature detector/temperaturedetector.c"
sbit LCD_RS at RC7_bit;
sbit LCD_EN at RC6_bit;
sbit LCD_D7 at RC2_bit;
sbit LCD_D6 at RC3_bit;
sbit LCD_D5 at RC4_bit;
sbit LCD_D4 at RC5_bit;


sbit LCD_RS_Direction at TRISC7_bit;
sbit LCD_EN_Direction at TRISC6_bit;
sbit LCD_D7_Direction at TRISC2_bit;
sbit LCD_D6_Direction at TRISC3_bit;
sbit LCD_D5_Direction at TRISC4_bit;
sbit LCD_D4_Direction at TRISC5_bit;

char temper[7];
char specific[7];
int temp;
int spe_degree;

void interrupt (){
 if(portb.B1 == 1)
 {
 spe_degree=spe_degree+1;
 }
 else if(portb.B2 == 1)
 {
 spe_degree=spe_degree-1;
 }
 else if(portb.B3 == 1)
 {
 INTCON.INTF=0;
 }
}

void main() {
trisb=0xff;
INTCON.GIE=1;
INTCON.INTE=1;
INTCON.INTF=0;

trisc.b0=0;
Lcd_Init();
ADC_Init();
Lcd_Cmd(_LCD_CLEAR);
lcd_cmd(_LCD_CURSOR_OFF);
lcd_out(1,4,"DIGITAL TEMPERATURE");
lcd_out(2,6,"SENSOR");
delay_ms(1000);
Lcd_Cmd(_LCD_CLEAR);
portc.b0=0;
spe_degree=30;
while(1)
{
temp=ADC_Read(0);
temp=temp* 0.48826;
temp=temp/0.01;
temp=temp/100;
inttostr(temp,temper);
lcd_out(1,1,"TEMPERATURE=");
lcd_out(1,13,Ltrim(temper));
lcd_chr_cp(0xdf);
lcd_chr_cp('C');
if(temp>spe_degree)
portc.b0=1;
else
portc.b0=0;

}
}
