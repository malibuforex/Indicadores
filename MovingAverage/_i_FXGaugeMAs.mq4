//+------------------------------------------------------------------+
//|                                                _i_FXGaugeMAs.mq4 |
//|                                     Copyright © 2006, Doji Starr |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, Doji Starr"

#property indicator_chart_window
#property indicator_buffers 7
#property indicator_color1 Lime
#property indicator_color2 Brown
#property indicator_color3 Magenta
#property indicator_color4 DarkSlateGray
#property indicator_color5 Yellow
#property indicator_color6 LightSlateGray
#property indicator_color7 White



// input params
extern int MA_Period1 = 21;
extern int MA_Period2 = 34;
extern int MA_Period3 = 55;
extern int MA_Period4 = 75;
extern int MA_Period5 = 100;
extern int MA_Period6 = 144;
extern int MA_Period7 = 233;

// vars
int counted_bars, startBar, bar, i;

// buffers
double buf_1[], buf_2[], buf_3[], buf_4[], buf_5[], buf_6[], buf_7[];



//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexBuffer(0, buf_1);
   SetIndexBuffer(1, buf_2);
   SetIndexBuffer(2, buf_3);
   SetIndexBuffer(3, buf_4);
   SetIndexBuffer(4, buf_5);
   SetIndexBuffer(5, buf_6);
   SetIndexBuffer(6, buf_7);

   SetIndexStyle(0, DRAW_LINE, EMPTY, 2);
   SetIndexStyle(1, DRAW_LINE, EMPTY, 2);

   return(0);
  }

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   counted_bars = IndicatorCounted();
   startBar = Bars-counted_bars-1;

   for(bar=startBar; bar>=0; bar--)
     {
      buf_1[bar] = iMA(NULL, 0, MA_Period1, 0, MODE_SMA, PRICE_CLOSE, bar);
      buf_2[bar] = iMA(NULL, 0, MA_Period2, 0, MODE_SMA, PRICE_CLOSE, bar);
      buf_3[bar] = iMA(NULL, 0, MA_Period3, 0, MODE_SMA, PRICE_CLOSE, bar);
      buf_4[bar] = iMA(NULL, 0, MA_Period4, 0, MODE_SMA, PRICE_CLOSE, bar);
      buf_5[bar] = iMA(NULL, 0, MA_Period5, 0, MODE_SMA, PRICE_CLOSE, bar);
      buf_6[bar] = iMA(NULL, 0, MA_Period6, 0, MODE_SMA, PRICE_CLOSE, bar);
      buf_7[bar] = iMA(NULL, 0, MA_Period7, 0, MODE_SMA, PRICE_CLOSE, bar);
     }

   return(0);
  }
//+------------------------------------------------------------------+
