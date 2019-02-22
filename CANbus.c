unsigned int SJW = 1;
unsigned int BRP = 1;
unsigned int Phase_Seg1 = 6;
unsigned int Phase_Seg2 = 7;
unsigned int Prop_Seg = 6;
unsigned short init_flag, send_flag, len;
long id, mask;
unsigned char sendata[8];
char dt;

void main() 
{
  TRISB = 0x08;                                                                 //RB2 is output, RB3 is input

  init_flag =  _CAN_CONFIG_SAMPLE_THRICE &                                      // form value to be used
               _CAN_CONFIG_PHSEG2_PRG_ON &                                      // with CANInit
               _CAN_CONFIG_STD_MSG &
               _CAN_CONFIG_DBL_BUFFER_ON &
               _CAN_CONFIG_VALID_XTD_MSG &
               _CAN_CONFIG_LINE_FILTER_OFF;

  send_flag =  _CAN_TX_PRIORITY_0 &
               _CAN_TX_XTD_FRAME &
               _CAN_TX_RTR_FRAME;

  CANInitialize(SJW,BRP,Phase_Seg1,Phase_Seg2,Prop_Seg, init_flag);             // Initialize CAN module
  
  CANSetOperationMode(_CAN_MODE_CONFIG,0xFF);                                   // set CONFIGURATION mode
  mask = -1;
  CANSetMask(_CAN_MASK_B1,mask,_CAN_CONFIG_XTD_MSG);                            // set all mask1 bits to ones
  CANSetMask(_CAN_MASK_B2,mask,_CAN_CONFIG_XTD_MSG);                            // set all mask2 bits to ones
  CANSetFilter(_CAN_FILTER_B2_F3,500,_CAN_CONFIG_XTD_MSG);                        // set id of filter B2_F3 to 2nd node ID

  CANSetOperationMode(_CAN_MODE_NORMAL,0xFF);                                   // set NORMAL mode
  
  for(;;)
  {
   dt = 0;
   while(!dt)
   {
    dt = CANRead(&id, sendata, &len, _CAN_RX_FILTER_1);
   }
   if(id==500 && sendata[0]=='T')
   {
    sendata[0] = 'A';
    id = 3;
    CANWrite(id, sendata, 1, send_flag);
   }
  }
}