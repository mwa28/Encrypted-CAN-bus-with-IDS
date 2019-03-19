
_main:

;LCD_PIC.c,29 :: 		void main() {
;LCD_PIC.c,32 :: 		PORTB = 0;                                                // clear PORTB
	CLRF        PORTB+0 
;LCD_PIC.c,33 :: 		TRISB = 0x08;                                             // set PORTB as output
	MOVLW       8
	MOVWF       TRISB+0 
;LCD_PIC.c,34 :: 		TRISC = 0;                                                // set PORTC as output
	CLRF        TRISC+0 
;LCD_PIC.c,36 :: 		Lcd_Init();                        // Initialize LCD
	CALL        _Lcd_Init+0, 0
;LCD_PIC.c,38 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;LCD_PIC.c,39 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;LCD_PIC.c,40 :: 		Lcd_Out(1,1,"Message:");                 // Write text in first row
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_LCD_PIC+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_LCD_PIC+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;LCD_PIC.c,43 :: 		Can_Init_Flags = 0;                                       //
	CLRF        _Can_Init_Flags+0 
;LCD_PIC.c,44 :: 		Can_Send_Flags = 0;                                       // clear flags
	CLRF        _Can_Send_Flags+0 
;LCD_PIC.c,45 :: 		Can_Rcv_Flags  = 0;                                       //
	CLRF        _Can_Rcv_Flags+0 
;LCD_PIC.c,49 :: 		_CAN_TX_NO_RTR_FRAME;
	MOVLW       244
	MOVWF       _Can_Send_Flags+0 
;LCD_PIC.c,55 :: 		_CAN_CONFIG_VALID_XTD_MSG;
	MOVLW       215
	MOVWF       _Can_Init_Flags+0 
;LCD_PIC.c,57 :: 		CANInitialize(1,10,5,2,8,Can_Init_Flags);                 // Initialize CAN module
	MOVLW       1
	MOVWF       FARG_CANInitialize_SJW+0 
	MOVLW       10
	MOVWF       FARG_CANInitialize_BRP+0 
	MOVLW       5
	MOVWF       FARG_CANInitialize_PHSEG1+0 
	MOVLW       2
	MOVWF       FARG_CANInitialize_PHSEG2+0 
	MOVLW       8
	MOVWF       FARG_CANInitialize_PROPSEG+0 
	MOVLW       215
	MOVWF       FARG_CANInitialize_CAN_CONFIG_FLAGS+0 
	CALL        _CANInitialize+0, 0
;LCD_PIC.c,58 :: 		CANSetOperationMode(_CAN_MODE_CONFIG,0xFF);               // set CONFIGURATION mode
	MOVLW       128
	MOVWF       FARG_CANSetOperationMode_mode+0 
	MOVLW       255
	MOVWF       FARG_CANSetOperationMode_WAIT+0 
	CALL        _CANSetOperationMode+0, 0
;LCD_PIC.c,59 :: 		CANSetMask(_CAN_MASK_B1,-1,_CAN_CONFIG_XTD_MSG);          // set all mask1 bits to ones
	CLRF        FARG_CANSetMask_CAN_MASK+0 
	MOVLW       255
	MOVWF       FARG_CANSetMask_val+0 
	MOVLW       255
	MOVWF       FARG_CANSetMask_val+1 
	MOVWF       FARG_CANSetMask_val+2 
	MOVWF       FARG_CANSetMask_val+3 
	MOVLW       247
	MOVWF       FARG_CANSetMask_CAN_CONFIG_FLAGS+0 
	CALL        _CANSetMask+0, 0
;LCD_PIC.c,60 :: 		CANSetMask(_CAN_MASK_B2,-1,_CAN_CONFIG_XTD_MSG);          // set all mask2 bits to ones
	MOVLW       1
	MOVWF       FARG_CANSetMask_CAN_MASK+0 
	MOVLW       255
	MOVWF       FARG_CANSetMask_val+0 
	MOVLW       255
	MOVWF       FARG_CANSetMask_val+1 
	MOVWF       FARG_CANSetMask_val+2 
	MOVWF       FARG_CANSetMask_val+3 
	MOVLW       247
	MOVWF       FARG_CANSetMask_CAN_CONFIG_FLAGS+0 
	CALL        _CANSetMask+0, 0
;LCD_PIC.c,61 :: 		CANSetFilter(_CAN_FILTER_B2_F4,ID_2nd,_CAN_CONFIG_XTD_MSG);// set id of filter B2_F4 to 2nd node ID
	MOVLW       5
	MOVWF       FARG_CANSetFilter_CAN_FILTER+0 
	MOVLW       3
	MOVWF       FARG_CANSetFilter_val+0 
	MOVLW       0
	MOVWF       FARG_CANSetFilter_val+1 
	MOVLW       0
	MOVWF       FARG_CANSetFilter_val+2 
	MOVLW       0
	MOVWF       FARG_CANSetFilter_val+3 
	MOVLW       247
	MOVWF       FARG_CANSetFilter_CAN_CONFIG_FLAGS+0 
	CALL        _CANSetFilter+0, 0
;LCD_PIC.c,63 :: 		CANSetOperationMode(_CAN_MODE_NORMAL,0xFF);               // set NORMAL mode
	CLRF        FARG_CANSetOperationMode_mode+0 
	MOVLW       255
	MOVWF       FARG_CANSetOperationMode_WAIT+0 
	CALL        _CANSetOperationMode+0, 0
;LCD_PIC.c,65 :: 		RxTx_Data[0] = 9;                                         // set initial data to be sent
	MOVLW       9
	MOVWF       _RxTx_Data+0 
;LCD_PIC.c,67 :: 		CANWrite(ID_1st, RxTx_Data, 1, Can_Send_Flags);           // send initial message
	MOVLW       79
	MOVWF       FARG_CANWrite_id+0 
	MOVLW       47
	MOVWF       FARG_CANWrite_id+1 
	MOVLW       0
	MOVWF       FARG_CANWrite_id+2 
	MOVLW       0
	MOVWF       FARG_CANWrite_id+3 
	MOVLW       _RxTx_Data+0
	MOVWF       FARG_CANWrite_data_+0 
	MOVLW       hi_addr(_RxTx_Data+0)
	MOVWF       FARG_CANWrite_data_+1 
	MOVLW       1
	MOVWF       FARG_CANWrite_DataLen+0 
	MOVF        _Can_Send_Flags+0, 0 
	MOVWF       FARG_CANWrite_CAN_TX_MSG_FLAGS+0 
	CALL        _CANWrite+0, 0
;LCD_PIC.c,71 :: 		while(1) {
L_main0:
;LCD_PIC.c,73 :: 		Msg_Rcvd = CANRead(&Rx_ID , RxTx_Data , &Rx_Data_Len, &Can_Rcv_Flags);  // receive message
	MOVLW       _Rx_ID+0
	MOVWF       FARG_CANRead_id+0 
	MOVLW       hi_addr(_Rx_ID+0)
	MOVWF       FARG_CANRead_id+1 
	MOVLW       _RxTx_Data+0
	MOVWF       FARG_CANRead_data_+0 
	MOVLW       hi_addr(_RxTx_Data+0)
	MOVWF       FARG_CANRead_data_+1 
	MOVLW       _Rx_Data_Len+0
	MOVWF       FARG_CANRead_dataLen+0 
	MOVLW       hi_addr(_Rx_Data_Len+0)
	MOVWF       FARG_CANRead_dataLen+1 
	MOVLW       _Can_Rcv_Flags+0
	MOVWF       FARG_CANRead_CAN_RX_MSG_FLAGS+0 
	MOVLW       hi_addr(_Can_Rcv_Flags+0)
	MOVWF       FARG_CANRead_CAN_RX_MSG_FLAGS+1 
	CALL        _CANRead+0, 0
	MOVF        R0, 0 
	MOVWF       _Msg_Rcvd+0 
;LCD_PIC.c,74 :: 		if (Msg_Rcvd) {                                                         // if message received
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main2
;LCD_PIC.c,76 :: 		PORTC = RxTx_Data[0];                                                 // id correct, output data at PORTC
	MOVF        _RxTx_Data+0, 0 
	MOVWF       PORTC+0 
;LCD_PIC.c,78 :: 		ByteToStr( RxTx_Data[0], output);
	MOVF        _RxTx_Data+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       main_output_L0+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(main_output_L0+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;LCD_PIC.c,79 :: 		Lcd_Out(2,1,output);                                                     // Write text in first row
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       main_output_L0+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(main_output_L0+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;LCD_PIC.c,81 :: 		RxTx_Data[0]++ ;                                                      // increment received data
	INCF        _RxTx_Data+0, 1 
;LCD_PIC.c,82 :: 		Delay_ms(800);
	MOVLW       41
	MOVWF       R11, 0
	MOVLW       150
	MOVWF       R12, 0
	MOVLW       127
	MOVWF       R13, 0
L_main3:
	DECFSZ      R13, 1, 1
	BRA         L_main3
	DECFSZ      R12, 1, 1
	BRA         L_main3
	DECFSZ      R11, 1, 1
	BRA         L_main3
;LCD_PIC.c,83 :: 		CANWrite(ID_1st, RxTx_Data, 1, Can_Send_Flags);                       // send incremented data back
	MOVLW       79
	MOVWF       FARG_CANWrite_id+0 
	MOVLW       47
	MOVWF       FARG_CANWrite_id+1 
	MOVLW       0
	MOVWF       FARG_CANWrite_id+2 
	MOVLW       0
	MOVWF       FARG_CANWrite_id+3 
	MOVLW       _RxTx_Data+0
	MOVWF       FARG_CANWrite_data_+0 
	MOVLW       hi_addr(_RxTx_Data+0)
	MOVWF       FARG_CANWrite_data_+1 
	MOVLW       1
	MOVWF       FARG_CANWrite_DataLen+0 
	MOVF        _Can_Send_Flags+0, 0 
	MOVWF       FARG_CANWrite_CAN_TX_MSG_FLAGS+0 
	CALL        _CANWrite+0, 0
;LCD_PIC.c,84 :: 		}
L_main2:
;LCD_PIC.c,85 :: 		}
	GOTO        L_main0
;LCD_PIC.c,86 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
