//+------------------------------------------------------------------+
//|                                                         bias.mq4 |
//|                       Copyright ?2008, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright ?2008, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Silver

//---- input parameters
extern int       MAPeriod=9;

//---- buffers
double ind_buffer[];
double BiasBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(2);
   SetIndexBuffer(0, BiasBuffer);
   SetIndexBuffer(1, ind_buffer);

//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,BiasBuffer);

//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("BIAS("+MAPeriod+")");
   SetIndexLabel(0,"BIAS");

//----
   SetIndexDrawBegin(0,MAPeriod);
   return(0);
//----
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
   int i;

//----
   if(Bars<=MAPeriod)
      return(0);

//---- initial zero
   if(counted_bars<1)
      for(i=1; i<=MAPeriod; i++)
         BiasBuffer[Bars-i]=0.0;
//----
   i=Bars-MAPeriod-1;
   if(counted_bars>=MAPeriod)
      i=Bars-counted_bars-1;
   while(i>=0)
     {
      ind_buffer[i]=iMA(NULL,0,MAPeriod,0,MODE_EMA,PRICE_CLOSE,i);
      BiasBuffer[i]=(Close[i]-ind_buffer[i])/Close[i];
      i--;
     }

//----
   return(0);
  }

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
