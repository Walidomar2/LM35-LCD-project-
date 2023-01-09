
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;temperaturedetector.c,21 :: 		void interrupt (){
;temperaturedetector.c,22 :: 		if(portb.B1 == 1)
	BTFSS      PORTB+0, 1
	GOTO       L_interrupt0
;temperaturedetector.c,24 :: 		spe_degree=spe_degree+1;
	INCF       _spe_degree+0, 1
	BTFSC      STATUS+0, 2
	INCF       _spe_degree+1, 1
;temperaturedetector.c,25 :: 		}
	GOTO       L_interrupt1
L_interrupt0:
;temperaturedetector.c,26 :: 		else if(portb.B2 == 1)
	BTFSS      PORTB+0, 2
	GOTO       L_interrupt2
;temperaturedetector.c,28 :: 		spe_degree=spe_degree-1;
	MOVLW      1
	SUBWF      _spe_degree+0, 1
	BTFSS      STATUS+0, 0
	DECF       _spe_degree+1, 1
;temperaturedetector.c,29 :: 		}
	GOTO       L_interrupt3
L_interrupt2:
;temperaturedetector.c,30 :: 		else if(portb.B3 == 1)
	BTFSS      PORTB+0, 3
	GOTO       L_interrupt4
;temperaturedetector.c,32 :: 		INTCON.INTF=0;
	BCF        INTCON+0, 1
;temperaturedetector.c,33 :: 		}
L_interrupt4:
L_interrupt3:
L_interrupt1:
;temperaturedetector.c,34 :: 		}
L_end_interrupt:
L__interrupt11:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;temperaturedetector.c,36 :: 		void main() {
;temperaturedetector.c,37 :: 		trisb=0xff;
	MOVLW      255
	MOVWF      TRISB+0
;temperaturedetector.c,38 :: 		INTCON.GIE=1;
	BSF        INTCON+0, 7
;temperaturedetector.c,39 :: 		INTCON.INTE=1;
	BSF        INTCON+0, 4
;temperaturedetector.c,40 :: 		INTCON.INTF=0;
	BCF        INTCON+0, 1
;temperaturedetector.c,42 :: 		trisc.b0=0;
	BCF        TRISC+0, 0
;temperaturedetector.c,43 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;temperaturedetector.c,44 :: 		ADC_Init();
	CALL       _ADC_Init+0
;temperaturedetector.c,45 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;temperaturedetector.c,46 :: 		lcd_cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;temperaturedetector.c,47 :: 		lcd_out(1,4,"DIGITAL TEMPERATURE");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      4
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_temperaturedetector+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;temperaturedetector.c,48 :: 		lcd_out(2,6,"SENSOR");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_temperaturedetector+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;temperaturedetector.c,49 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main5:
	DECFSZ     R13+0, 1
	GOTO       L_main5
	DECFSZ     R12+0, 1
	GOTO       L_main5
	DECFSZ     R11+0, 1
	GOTO       L_main5
	NOP
	NOP
;temperaturedetector.c,50 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;temperaturedetector.c,51 :: 		portc.b0=0;
	BCF        PORTC+0, 0
;temperaturedetector.c,52 :: 		spe_degree=30;
	MOVLW      30
	MOVWF      _spe_degree+0
	MOVLW      0
	MOVWF      _spe_degree+1
;temperaturedetector.c,53 :: 		while(1)
L_main6:
;temperaturedetector.c,55 :: 		temp=ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _temp+0
	MOVF       R0+1, 0
	MOVWF      _temp+1
;temperaturedetector.c,56 :: 		temp=temp* 0.48826;
	CALL       _int2double+0
	MOVLW      55
	MOVWF      R4+0
	MOVLW      253
	MOVWF      R4+1
	MOVLW      121
	MOVWF      R4+2
	MOVLW      125
	MOVWF      R4+3
	CALL       _Mul_32x32_FP+0
	CALL       _double2int+0
	MOVF       R0+0, 0
	MOVWF      _temp+0
	MOVF       R0+1, 0
	MOVWF      _temp+1
;temperaturedetector.c,57 :: 		temp=temp/0.01;
	CALL       _int2double+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      215
	MOVWF      R4+1
	MOVLW      35
	MOVWF      R4+2
	MOVLW      120
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	CALL       _double2int+0
	MOVF       R0+0, 0
	MOVWF      _temp+0
	MOVF       R0+1, 0
	MOVWF      _temp+1
;temperaturedetector.c,58 :: 		temp=temp/100;
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      _temp+0
	MOVF       R0+1, 0
	MOVWF      _temp+1
;temperaturedetector.c,59 :: 		inttostr(temp,temper);
	MOVF       R0+0, 0
	MOVWF      FARG_IntToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_IntToStr_input+1
	MOVLW      _temper+0
	MOVWF      FARG_IntToStr_output+0
	CALL       _IntToStr+0
;temperaturedetector.c,60 :: 		lcd_out(1,1,"TEMPERATURE=");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_temperaturedetector+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;temperaturedetector.c,61 :: 		lcd_out(1,13,Ltrim(temper));
	MOVLW      _temper+0
	MOVWF      FARG_Ltrim_string+0
	CALL       _Ltrim+0
	MOVF       R0+0, 0
	MOVWF      FARG_Lcd_Out_text+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Out_column+0
	CALL       _Lcd_Out+0
;temperaturedetector.c,62 :: 		lcd_chr_cp(0xdf);
	MOVLW      223
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;temperaturedetector.c,63 :: 		lcd_chr_cp('C');
	MOVLW      67
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;temperaturedetector.c,64 :: 		if(temp>spe_degree)
	MOVLW      128
	XORWF      _spe_degree+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      _temp+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main13
	MOVF       _temp+0, 0
	SUBWF      _spe_degree+0, 0
L__main13:
	BTFSC      STATUS+0, 0
	GOTO       L_main8
;temperaturedetector.c,65 :: 		portc.b0=1;
	BSF        PORTC+0, 0
	GOTO       L_main9
L_main8:
;temperaturedetector.c,67 :: 		portc.b0=0;
	BCF        PORTC+0, 0
L_main9:
;temperaturedetector.c,69 :: 		}
	GOTO       L_main6
;temperaturedetector.c,70 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
