//+------------------------------------------------------------------+
//|                                                        IFish.mq4 |
//|                                                       Infodragon |
//|                                           infodragon@rdrtech.com |
//+------------------------------------------------------------------+
#property copyright "Infodragon"
#property link      "infodragon@rdrtech.com"
#property indicator_buffers 2
#property indicator_color1 LightSlateGray
#property indicator_color2 DarkSlateGray
#property indicator_separate_window

#property indicator_level1 0.8
#property indicator_level2 -0.8
#property indicator_level3 0

double value1[];
double value2[];
double ifish[];

double ifishB[];
double ifishS[];

double Bulls[];
double Bears[];
double CMO[];


extern int CMOBars = 15;
extern int WmaBars = 3;
extern double trigger = 0.5;
extern int offset = 1;
extern int AppliedPrice = 5;
extern bool ZeroCross = false;

int status = 0;  // 0 nothing yet, 1 buy, -1 sell
/*
PRICE_CLOSE 0 Close price.
PRICE_OPEN 1 Open price.
PRICE_HIGH 2 High price.
PRICE_LOW 3 Low price.
PRICE_MEDIAN 4 Median price, (high+low)/2.
PRICE_TYPICAL 5 Typical price, (high+low+close)/3.
PRICE_WEIGHTED 6 Weighted close price, (high+low+close+close)/4.
*/

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   IndicatorBuffers(8);

   SetIndexBuffer(0,ifishB);
   SetIndexStyle(0,DRAW_HISTOGRAM,STYLE_SOLID,4);

   SetIndexBuffer(1,ifishS);
   SetIndexStyle(1,DRAW_HISTOGRAM,STYLE_SOLID,4);

   SetIndexBuffer(2,ifish);
   SetIndexStyle(2,DRAW_HISTOGRAM,STYLE_SOLID,4);
   SetIndexBuffer(3,value1);
   SetIndexBuffer(4,value2);

   SetIndexBuffer(5,Bulls);
   SetIndexBuffer(6,Bears);
   SetIndexBuffer(7,CMO);

   SetLevelValue(0,trigger);
   SetLevelValue(1,-trigger);


   return(0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   int limit;
   int counted_bars=IndicatorCounted();
   if(counted_bars<0)
      counted_bars=0;
   if(counted_bars>0)
      counted_bars--;
   limit=Bars-counted_bars;

   double   Price1, Price2;

   for(int i = 0 ; i < limit ; i++)
     {
      Price1 = iMA(NULL,0,1,0,0,AppliedPrice,i+offset);
      Price2 = iMA(NULL,0,1,0,0,AppliedPrice,i+1+offset);

      Bulls[i] = 0.5*(MathAbs(Price1-Price2)+(Price1-Price2));
      Bears[i] = 0.5*(MathAbs(Price1-Price2)-(Price1-Price2));
     }

   for(i=0; i<=limit; i++)
     {
      double SumBulls = 0, SumBears=0;

      for(int j=0; j<CMOBars; j++)
        {
         SumBulls += Bulls[i+j];
         SumBears += Bears[i+j];
        }

      if(SumBulls+SumBears == 0)
         CMO[i] = 0;
      else
         CMO[i] = (SumBulls-SumBears)/(SumBulls+SumBears)*100;
     }

   for(i=0; i<=limit; i++)
      value1[i] = 0.05*CMO[i];

   for(j = 0 ; j <= limit ; j++)
      value2[j] = iMAOnArray(value1,0,WmaBars,0,MODE_LWMA,j);
   for(int f = 0 ; f <= limit ; f++)
      ifish[f] = (MathExp(2*value2[f])-1)/(MathExp(2*value2[f])+1);


   if(ZeroCross == true)
     {
      for(f = 0 ; f <= limit ; f++)
        {
         ifishB[f] = 0;
         ifishS[f] = 0;

         if(ifish[f] > 0)
            ifishB[f] = ifish[f];
         else
            ifishS[f] = ifish[f];
        }
     }

   else
     {
      for(f=limit-1; f>=0; f--)
        {
         ifishB[f] = 0;
         ifishS[f] = 0;

         if((ifish[f] > trigger) || (ifish[f] > -trigger && ifish[f+1] <= -trigger))
           {
            status = 1;
           }
         else
            if((ifish[f] < -trigger) || (ifish[f] < trigger && ifish[f+1] >= trigger))
              {
               status = -1;
              }

         if(status == 1)
           {
            ifishB[f] = ifish[f];
           }
         else
            if(status == -1)
               ifishS[f] = ifish[f];
        }
     }

   return(0);
  }
//+------------------------------------------------------------------+
