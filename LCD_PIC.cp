#line 1 "C:/Users/mwa28/Desktop/correct_bus/LCD_pic/LCD_PIC.c"
unsigned char Can_Init_Flags, Can_Send_Flags, Can_Rcv_Flags;
unsigned char Rx_Data_Len;
char RxTx_Data[8];
char Msg_Rcvd;
const long ID_1st = 12111, ID_2nd = 3;
long Rx_ID;

long current_time;
long last_tx_time[7][1];
long PICS[7][20];



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


void main() {
 char output[15];

 PORTB = 0;
 TRISB = 0x08;
 TRISC = 0;

 Lcd_Init();

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 Lcd_Out(1,1,"Message:");


 Can_Init_Flags = 0;
 Can_Send_Flags = 0;
 Can_Rcv_Flags = 0;

 Can_Send_Flags = _CAN_TX_PRIORITY_0 &
 _CAN_TX_XTD_FRAME &
 _CAN_TX_NO_RTR_FRAME;

 Can_Init_Flags = _CAN_CONFIG_SAMPLE_ONCE &
 _CAN_CONFIG_PHSEG2_PRG_ON &
 _CAN_CONFIG_XTD_MSG &
 _CAN_CONFIG_DBL_BUFFER_ON &
 _CAN_CONFIG_VALID_XTD_MSG;

 CANInitialize(1,10,5,2,8,Can_Init_Flags);
 CANSetOperationMode(_CAN_MODE_CONFIG,0xFF);
 CANSetMask(_CAN_MASK_B1,-1,_CAN_CONFIG_XTD_MSG);
 CANSetMask(_CAN_MASK_B2,-1,_CAN_CONFIG_XTD_MSG);
 CANSetFilter(_CAN_FILTER_B2_F4,ID_2nd,_CAN_CONFIG_XTD_MSG);

 CANSetOperationMode(_CAN_MODE_NORMAL,0xFF);

 RxTx_Data[0] = 9;

 CANWrite(ID_1st, RxTx_Data, 1, Can_Send_Flags);



 while(1) {

 Msg_Rcvd = CANRead(&Rx_ID , RxTx_Data , &Rx_Data_Len, &Can_Rcv_Flags);
 if (Msg_Rcvd) {

 PORTC = RxTx_Data[0];

 ByteToStr( RxTx_Data[0], output);
 Lcd_Out(2,1,output);

 RxTx_Data[0]++ ;
 Delay_ms(800);
 CANWrite(ID_1st, RxTx_Data, 1, Can_Send_Flags);
 }
 }
}
