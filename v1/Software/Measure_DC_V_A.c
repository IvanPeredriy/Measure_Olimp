/*******************************************************
This program was created by the CodeWizardAVR V3.30 
Automatic Program Generator
© Copyright 1998-2017 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Measure_DC_V_A
Version : 1.0
Date    : 10.04.2017
Author  : Peredriy Ivan
Company : 
Comments: 
Устройство 2-х канального измерения 
напряжения и тока.
Диапазон измерения напряжения 0 - 30 В
Диапазон измерения тока       0 - 2,5 А


Chip type               : ATmega8A
Program type            : Application
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <io.h>         // библиотека для работы с портами ввода-вывода 
#include <delay.h>      // библиотека задержки

// Alphanumeric LCD functions
#include <alcd.h>       // библиотека для работы с дисплеем

#include <stdio.h>      // библиотека для дисплея, sprintf не будет работать без нее

// Voltage Reference: Int., cap. on AREF
#define ADC_VREF_TYPE ((1<<REFS1) | (1<<REFS0) | (0<<ADLAR)) // опорное 2,56 В
 
// ************** Глобальные переменные **************
unsigned char sample=0, count=0, adc_input=0;

char U_channel_1[10], I_channel_1[10], U_channel_2[10], I_channel_2[10];

unsigned int A1=0, A2=0;

float sample_U1=0, sample_U2=0, sample_I1=0, sample_I2=0,
averaging_U1=0, averaging_U2=0, averaging_I1=0, averaging_I2=0,             
adc_U1=0, adc_U2=0, adc_I1=0, adc_I2=0,                                                    
U1=0, U2=0, I1=0, I2=0;                    


// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
 
 TCCR0=0x00; // останавливаем таймер T0 на время выполнения кода 
 TCNT0=0x00; // обнуляем счетный регистр таймера T0
// ************ АЦП ************
// Опрос 4 каналов
while(adc_input<4) // остаемя в цикле пока не опросим все 4 канала АЦП 
    {
     ADMUX=((adc_input) | (ADC_VREF_TYPE & 0xFF)); // выбираем канал
     // Начать преобразование АЦП
     ADCSRA|=(1<<ADSC);                            
     // ждем, пока АЦП закончит преобразование (ADIF = 0)
     while ((ADCSRA & (1<<ADIF))==0);
     // сбрасываем ADIF, флаг прерываения окончания преобразования
     ADCSRA|=(1<<ADIF);
 
     // Чтение результата преобразования канала АЦП 
     switch(adc_input)
          {
           case 0:{sample_U1+=ADCW; break;} // прибавляем к счетчику оверсемплинга
           case 1:{sample_I1+=ADCW; break;}
           case 2:{sample_U2+=ADCW; break;}
           case 3:{sample_I2+=ADCW; break;} 
          }
     adc_input++;      
    }

  adc_input=0;// выставляем начальный канал АЦП 


// *** Оверсемплинг АЦП ( 4,096 мс ) *** (16 выборок * через каждые 256 мкс)
   sample++;
if(sample==16)
  {
   count++;
   sample=0; 
   
   sample_U1=sample_U1 / 4;
   averaging_U1+=sample_U1;
   
   sample_I1=sample_I1 / 4;
   averaging_I1+=sample_I1;  
   
   sample_U2=sample_U2 / 4;
   averaging_U2+=sample_U2;
   
   sample_I2=sample_I2 / 4;
   averaging_I2+=sample_I2;
                                                                                                                                                                                                                                                                  ; 
   sample_U1=0;
   sample_I1=0;
   sample_U2=0;
   sample_I2=0;
}

// *** Усреднение измерения оверсемплинга (обновления данных на дисплее) ( 262,144 мс ) 
// *** (64 выборок * через каждые 4,096 мс оверсемплинга)       
 if(count==64)
   {
    count=0; 
      
    adc_U1 = averaging_U1 / 64;
    adc_I1 = averaging_I1 / 64;
    adc_U2 = averaging_U2 / 64;
    adc_I2 = averaging_I2 / 64;
                                                                                                                                                                                                                                                                  ; 
    averaging_U1=0;
    averaging_I1=0; 
    averaging_U2=0;
    averaging_I2=0;

     // *** Обработка измеренных данных ***       
    
    if(I1>0.0) // если ток в канале 1 больше 0                   
     {
      I1 = (adc_I1 * 0.000625)-0.015;        // формула для расчета тока в 1 канале
                                             // 0,015 срезаем 15 мА, устанавливая этим 0 мА тока, при х.х. выхода Б.П.
                                             // 0,000625 константа (2,56В/4096(12ббитное разрешение)=0,000625)
      
      U1 = ((adc_U1 * 0.000625)*7)-I1*0.112; // вычисляем напряжение с учетом вычета потерь на датчике тока в канале 1
     }                                
    
    else                                     // если 0 то уста. 0 на диспле
     { 
     I1=0;                                   
     U1 = (adc_U1 * 0.000625)*7;             // напряжение холостого хода в канале 1
     }                  
    
    

   if(I2>0.0) // если ток в канале 2 больше 0                   
     {
      I2 = (adc_I2 * 0.000625)-0.015;        // формула для расчета тока в 2 канале
                                             // 0,015 срезаем 15 мА, устанавливая этим 0 мА тока, при х.х. выхода Б.П.
      
      U2 = ((adc_U2 * 0.000625)*7)-I2*0.112; // вычисляем напряжение с учетом вычета потерь на датчике тока в канале 2
     }
    
    else                                     // если 0 то уста. 0 на диспле
     { 
      I2=0; 
      U2 = (adc_U2 * 0.000625)*7;            // напряжение холостого хода в канале 2
     }                 

    
    if(U1<0.0) // на случай если напряжение будет отрицательно, чтобы не слетали знакоместа на дисплее
      {
       U1=0;
      }  
      
    if(U2<0.0) // на случай если напряжение будет отрицательно, чтобы не слетали знакоместа на дисплее
      {
       U2=0;
      }      
     
    // Вывод на дисплей напряжения в канале 1
    lcd_gotoxy(0,0);
    
    if (U1>9.99)
      {
       sprintf(U_channel_1, "U=%.1fB",U1 );
      }    
         
    else
      {
       sprintf(U_channel_1, "U=%.2fB",U1 );
      }  
       
    lcd_puts(U_channel_1); 

    // Вывод на дисплей тока в канале 1
    lcd_gotoxy(0,1);
    if(I1>0.999)
      {
       sprintf(I_channel_1, "I=%.2fA",I1 );
      }

    else 
      {
       I1=I1*1000;
       A1=I1;
       sprintf(I_channel_1, "I=%-3dmA",A1 );
      }

    lcd_puts(I_channel_1);  
    
    // Вывод на дисплей напряжения в канале 2
    lcd_gotoxy(9,0);
    if (U2>9.99)
      {
       sprintf(U_channel_2, "U=%.1fB",U2 );
      }    
         
    else
      {
       sprintf(U_channel_2, "U=%.2fB",U2 );
      }  
       
    lcd_puts(U_channel_2);   
     
    // Вывод на дисплей тока в канале 2
    lcd_gotoxy(9,1);
    if(I2>0.999)
      { 
       sprintf(I_channel_2, "I=%.2fA",I2 );
      }

    else 
      {
       I2=I2*1000;
       A2=I2;
       sprintf(I_channel_2, "I=%-3dmA",A2 );
      }

    lcd_puts(I_channel_2);     
    
   }     
   
   TCCR0=(0<<CS02) | (1<<CS01) | (0<<CS00);  // возобновляем работу таймера T0    
}



void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port C initialization
// Function: Bit6=Out Bit5=Out Bit4=Out Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=0 Bit5=0 Bit4=0 Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 1000,000 kHz
// Timer period: 0,256 ms
TCCR0=(0<<CS02) | (1<<CS01) | (0<<CS00);

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);

// ADC initialization
// ADC Clock frequency: 125,000 kHz
// ADC Voltage Reference: AREF pin
ADMUX=ADC_VREF_TYPE;
ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (1<<ADPS2) | (1<<ADPS1) | (0<<ADPS0);
SFIOR=(0<<ACME);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTD Bit 0
// RD - PORTD Bit 1
// EN - PORTD Bit 2
// D4 - PORTD Bit 4
// D5 - PORTD Bit 5
// D6 - PORTD Bit 6
// D7 - PORTD Bit 7
// Characters/line: 16
lcd_init(16);

lcd_gotoxy(2,0);
lcd_putsf("Developed in");
lcd_gotoxy(3,1);
lcd_putsf("NKPT-2017");
delay_ms(2000);
lcd_clear();

TCNT0=0x00;
// Globally enable interrupts
#asm("sei")

while (1)
      {
        
      }
}
