//+------------------------------------------------------------------+
//|                                                MalibuChannel.mq4 |
//|                        Copyright 2022, Malibu Beach Forex Club.  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Malibu Beach Forex Club."
//#property link      ""
#property version   "1.0"
#property strict
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Blue
#property indicator_color2 Red
#property indicator_color3 Blue
//--- input parameters
input int      LRPeriod=9;
input int      InputPrice=PRICE_CLOSE;


double linear_buffer[];
int mode;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   switch(InputPrice)
     {
      case PRICE_OPEN:
      case PRICE_HIGH:
      case PRICE_LOW:
      case PRICE_CLOSE:
      case PRICE_MEDIAN:
      case PRICE_TYPICAL:
      case PRICE_WEIGHTED:
         mode = InputPrice;
         break;
      default:
         printf("Incorrect value for input variable InputPrice=%d. Indicator will use value PRICE_CLOSE for calculations.",InputPrice);
         mode=PRICE_CLOSE;
     }

   SetIndexStyle(2,DRAW_LINE,STYLE_DOT);
   SetIndexShift(2,0);
   SetIndexDrawBegin(2,0);
   SetIndexBuffer(2,linear_buffer);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

   int limit, i;
   limit = rates_total - prev_calculated;
   for(i=0; i<limit; i++)
     {
      linear_buffer[i]=linreg(LRPeriod,i);
     }

//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double linreg(int p,int i)
  {
   double SumY=0;
   double Sum1=0;
   double Slope=0;
   double c=0;

   for(int x=0; x<=p-1; x++)
     {

      switch(mode)
        {
         case PRICE_OPEN:
            c=Open[x+i];
            break;
         case PRICE_HIGH:
            c=High[x+i];
            break;
         case PRICE_LOW:
            c=Low[x+i];
            break;
         case PRICE_CLOSE:
            c=Close[x+i];
            break;
         case PRICE_MEDIAN:
            c = (High[x+i] + Low[x+i]) / 2;
            break;
         case PRICE_TYPICAL:
            c = (High[x+i] + Low[x+i] + Close[x+i]) / 3;
            break;
         case PRICE_WEIGHTED:
            c = (High[x+i] + Low[x+i] + Close[x+i] + Close[x+i]) / 4;
            break;
        }

      SumY+=c;
      Sum1+=x*c;
     }
   double SumBars=p*(p-1)*0.5;
   double SumSqrBars=(p-1)*p*(2*p-1)/6;
   double Sum2=SumBars*SumY;
   double Num1=p*Sum1-Sum2;
   double Num2=SumBars*SumBars-p*SumSqrBars;
   if(Num2!=0)
      Slope=Num1/Num2;
   else
      Slope=0;
   double Intercept=(SumY-Slope*SumBars)/p;
   double linregval=Intercept+Slope*(p-1);
   return(linregval);
  }
//+------------------------------------------------------------------+

