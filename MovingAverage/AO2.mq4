//+------------------------------------------------------------------+
//|                                                          AO2.mq4 |
//|                                                              T.Y |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "T.Y"
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 RoyalBlue
#property indicator_color2 PaleVioletRed
#property indicator_color3 Aqua
#property indicator_color4 Red
#property indicator_width1 5
#property indicator_width2 5
#property indicator_width3 3
#property indicator_width4 3

extern int Magnification = 0;

double Buf0[], Buf1[];
double Buf2[], Buf3[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0, Buf0);
   SetIndexBuffer(1, Buf1);
   SetIndexBuffer(2, Buf2);
   SetIndexBuffer(3, Buf3);
   SetIndexStyle(0, DRAW_HISTOGRAM);
   SetIndexStyle(1, DRAW_HISTOGRAM);
   SetIndexStyle(2, DRAW_HISTOGRAM);
   SetIndexStyle(3, DRAW_HISTOGRAM);

   if(Magnification>0)
      return(0);
   int tf = Period();
   if(tf==1)
      Magnification = 10;
   if(tf==5)
      Magnification = 6;
   if(tf==15)
      Magnification = 4;
   if(tf==30)
      Magnification = 4;
   if(tf==60)
      Magnification = 4;
   if(tf==240)
      Magnification = 6;
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
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
   int    counted_bars = IndicatorCounted();
   int    limit        = Bars - counted_bars;
   double ao1, ao2;

   if(limit==Bars)
      limit -= (34*Magnification+1);
   for(int i=limit-1; i>=0; i--)
     {
      ao1 = iMA(NULL, 0, 5,  0, MODE_SMA, PRICE_MEDIAN, i)
            - iMA(NULL, 0, 34, 0, MODE_SMA, PRICE_MEDIAN, i);
      ao2 = iMA(NULL, 0, 5,  0, MODE_SMA, PRICE_MEDIAN, i+1)
            - iMA(NULL, 0, 34, 0, MODE_SMA, PRICE_MEDIAN, i+1);
      if(ao1>ao2)
        {
         Buf2[i] = ao1;
         Buf3[i] = 0.0;
        }
      else
        {
         Buf2[i] = 0.0;
         Buf3[i] = ao1;
        }
      ao1 = iMA(NULL, 0, Magnification*5,  0, MODE_SMA, PRICE_MEDIAN, i)
            - iMA(NULL, 0, Magnification*34, 0, MODE_SMA, PRICE_MEDIAN, i);
      ao2 = iMA(NULL, 0, Magnification*5,  0, MODE_SMA, PRICE_MEDIAN, i+1)
            - iMA(NULL, 0, Magnification*34, 0, MODE_SMA, PRICE_MEDIAN, i+1);
      if(ao1>ao2)
        {
         Buf0[i] = ao1;
         Buf1[i] = 0.0;
        }
      else
        {
         Buf0[i] = 0.0;
         Buf1[i] = ao1;
        }
     }

   return(0);
  }
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
