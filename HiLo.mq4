//+------------------------------------------------------------------+
//|                                                            
//|  HiLo_v1.1.mq4                                                 |
//|                                                            
//+------------------------------------------------------------------+
//
#property copyright "eNigmar"
#property link      "http://www.metaquotes.net/"

#property indicator_chart_window

#define HighBuffer 1
#define LowBuffer  2

int PreBuffer = 20;

double ExtLowBuffer[];
double ExtHighBuffer[];
double ExtCandleHighBuffer[];
double ExtCandleLowBuffer[];

double direction[];

int gi_276;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init(){
   
   SetIndexStyle(HighBuffer, DRAW_NONE);
   SetIndexStyle(LowBuffer, DRAW_NONE);
   SetIndexBuffer(HighBuffer, ExtHighBuffer);
   SetIndexBuffer(LowBuffer, ExtLowBuffer);
   SetIndexEmptyValue(LowBuffer, EMPTY_VALUE);
   SetIndexEmptyValue(HighBuffer, EMPTY_VALUE);
   SetIndexDrawBegin(LowBuffer, PreBuffer);
   SetIndexDrawBegin(HighBuffer, PreBuffer);
   SetIndexLabel(HighBuffer, "");
   SetIndexLabel(LowBuffer, "");

   SetIndexStyle(3, DRAW_NONE);
   SetIndexBuffer(3, ExtCandleHighBuffer);
   SetIndexEmptyValue(3, EMPTY_VALUE);
   SetIndexDrawBegin(3, PreBuffer);
   SetIndexLabel(3, "");
   SetIndexStyle(4, DRAW_NONE);
   SetIndexBuffer(4, ExtCandleLowBuffer);
   SetIndexEmptyValue(4, EMPTY_VALUE);
   SetIndexDrawBegin(4, PreBuffer);
   SetIndexLabel(4, "");
    
   SetIndexLabel(5, "");
   SetIndexEmptyValue(5, EMPTY_VALUE);
   SetIndexDrawBegin(5, PreBuffer);
   SetIndexBuffer(5, direction);
   
   gi_276 = 0;

   return(INFO_MAGIC+123456);
}

//+------------------------------------------------------------------+
//| Custor indicator iteration function                              |
//+------------------------------------------------------------------+
int start(){  
   
   double ld_0CandleLowBuffer = (Low[0] == 0 ? Close[0] - Point * 100 * (double)Digits : Low[0]);   
   double ld_0CandleHighBuffer = (High[0] == 0 ? Close[0] + Point * 100 * (double)Digits : High[0]);   

   if(ld_0CandleLowBuffer != ExtCandleLowBuffer[0] || gi_276 == 0)
   {
      gi_276 = 1;
      ArrayCopySeries(ExtCandleLowBuffer, MODE_LOW, Symbol(), Period(), ExtCandleLowBuffer, PreBuffer);
      if((ExtCandleLowBuffer[0] == ExtCandleLowBuffer[PreBuffer]) && (gi_276>PreBuffer)) 
         ExtCandleLowBuffer[0] = ExtCandleLowBuffer[1];
                  
      ArraySetAsSeries(ExtCandleLowBuffer, true);
      for(int i=0; i<=prebuffer+1; i++)
      {
         ExtLowBuffer[i] = EMPTY_VALUE; 
      }
      int count = 0;
      for(int i=prebuffer+1; i>=0; i--)
      {
         ExtLowBuffer[i] = ExtCandleLowBuffer[count];
         count++;
      }
   }
   if(ld_0CandleHighBuffer != ExtCandleHighBuffer[0] || gi_276 == 0)
   {
      gi_276 = 1;
      ArrayCopySeries(ExtCandleHighBuffer, MODE_HIGH, Symbol(), Period(), ExtCandleHighBuffer, PreBuffer);
      if((ExtCandleHighBuffer[0] == ExtCandleHighBuffer[PreBuffer]) && (gi_276>PreBuffer)) 
         ExtCandleHighBuffer[0] = ExtCandleHighBuffer[1];
         
      ArraySetAsSeries(ExtCandleHighBuffer, true);
      for(int i=0; i<=prebuffer+1; i++)
      {
         ExtHighBuffer[i] = EMPTY_VALUE; 
      }
      int count = 0;
      for(int i=prebuffer+1; i>=0; i--)
      {
         ExtHighBuffer[i] = ExtCandleHighBuffer[count];
         count++;
      }
    }
    if (Close[0] >= ExtHighBuffer[0]) {
         direction[0] = -1.0000;
    } else if (Close[0] <= ExtLowBuffer[0]) {
         direction[0] = 1.0000;
    } else {
         direction[0] = direction[1];
    }
   
   return(0);
}
