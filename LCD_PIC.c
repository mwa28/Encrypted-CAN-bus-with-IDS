unsigned char Can_Init_Flags, Can_Send_Flags, Can_Rcv_Flags; // can flags
unsigned char Rx_Data_Len;                                   // received data length in bytes
char RxTx_Data[8];                                           // can rx/tx data buffer
char Msg_Rcvd;                                               // reception flag
const long ID_1st = 12111, ID_2nd = 3;                       // node IDs
long Rx_ID;

long current_time;
long last_tx_time[7][1];
long PICS[7][20];


//LCD
sbit LCD_RS at RC4_bit;
sbit LCD_EN at RC5_bit;
sbit LCD_D4 at RC0_bit;
sbit LCD_D5 at RC1_bit;
sbit LCD_D6 at RC2_bit;
sbit LCD_D7 at RC3_bit;

sbit LCD_RS_Direction at TRISC4_bit;
sbit LCD_EN_Direction at TRISC5_bit;
sbit LCD_D4_Direction at TRISC0_bit;
sbit LCD_D5_Direction at TRISC1_bit;
sbit LCD_D6_Direction at TRISC2_bit;
sbit LCD_D7_Direction at TRISC3_bit;
//LCD END

void main() {
  char output[15];                                          //An extra one for end-of-line character

  PORTB = 0;                                                // clear PORTB
  TRISB = 0x08;                                             // set PORTB as output
  TRISC = 0;                                                // set PORTC as output

  Lcd_Init();                        // Initialize LCD

  Lcd_Cmd(_LCD_CLEAR);               // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
  Lcd_Out(1,1,"Message:");                 // Write text in first row


  Can_Init_Flags = 0;                                       //
  Can_Send_Flags = 0;                                       // clear flags
  Can_Rcv_Flags  = 0;                                       //

  Can_Send_Flags = _CAN_TX_PRIORITY_0 &                     // form value to be used
                   _CAN_TX_XTD_FRAME &                      //     with CANWrite
                   _CAN_TX_NO_RTR_FRAME;

  Can_Init_Flags = _CAN_CONFIG_SAMPLE_ONCE &                // form value to be used
                   _CAN_CONFIG_PHSEG2_PRG_ON &              // with CANInit
                   _CAN_CONFIG_XTD_MSG &
                   _CAN_CONFIG_DBL_BUFFER_ON &
                   _CAN_CONFIG_VALID_XTD_MSG;

  CANInitialize(1,10,5,2,8,Can_Init_Flags);                 // Initialize CAN module
  CANSetOperationMode(_CAN_MODE_CONFIG,0xFF);               // set CONFIGURATION mode
  CANSetMask(_CAN_MASK_B1,-1,_CAN_CONFIG_XTD_MSG);          // set all mask1 bits to ones
  CANSetMask(_CAN_MASK_B2,-1,_CAN_CONFIG_XTD_MSG);          // set all mask2 bits to ones
  CANSetFilter(_CAN_FILTER_B2_F4,ID_2nd,_CAN_CONFIG_XTD_MSG);// set id of filter B2_F4 to 2nd node ID

  CANSetOperationMode(_CAN_MODE_NORMAL,0xFF);               // set NORMAL mode

  RxTx_Data[0] = 9;                                         // set initial data to be sent

  CANWrite(ID_1st, RxTx_Data, 1, Can_Send_Flags);           // send initial message



  while(1) {
                                                                            // endless loop
    Msg_Rcvd = CANRead(&Rx_ID , RxTx_Data , &Rx_Data_Len, &Can_Rcv_Flags);  // receive message
    if (Msg_Rcvd) {                                                         // if message received

      PORTC = RxTx_Data[0];                                                 // id correct, output data at PORTC

      ByteToStr( RxTx_Data[0], output);
      Lcd_Out(2,1,output);                                                     // Write text in first row

      RxTx_Data[0]++ ;                                                      // increment received data
      Delay_ms(800);
      CANWrite(ID_1st, RxTx_Data, 1, Can_Send_Flags);                       // send incremented data back
    }
  }
}