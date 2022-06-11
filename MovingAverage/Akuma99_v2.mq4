/*

*********************************************************************
          
                    Akuma99 Stormy Weather
                   Copyright © 2005  Akuma99
                  http://akuma99.blogspot.com    

       For help on this indicator, tutorials and information 
               visit http://akuma99.blogspot.com/
                  
*********************************************************************

*/

#property link        "http://akuma99.blogspot.com/"
#property copyright   "© 2005 Akuma99 (http://akuma99.blogspot.com)"

#property indicator_chart_window
#property indicator_buffers 8
#property indicator_color1 Lavender
#property indicator_color2 Lavender
#property indicator_color3 CornflowerBlue
#property indicator_color4 CornflowerBlue
#property indicator_color5 Green
#property indicator_color6 Crimson
#property indicator_color7 Navy
#property indicator_color8 Navy

extern int     maxBars = 2000;
extern int     spread=4;
extern int     humidity=55;

double  bb=12.0;
double  bbDeviation=2.0;
double  kelt=8.0;
double  keltFactor=1.0;
double  buffer=1.0;

double      upperBarrier[];
double      lowerBarrier[];
double      clouds1[];
double      clouds2[];
double      silverlining1[];
double      silverlining2[];
double      ozone1[];
double      ozone2[];
double      darkclouds1[];
double      darkclouds2[];

int         history[];               

int         tracking;

double      val1[];
double      val2[];

int         holder=0;
int         trueRangePeriod = 9;

int         count=0;
  
int init() {

   ArrayResize(history,maxBars);
   ArrayInitialize(history,3);

   IndicatorBuffers(8);
   
   SetIndexStyle(0,DRAW_HISTOGRAM, 2, 1, indicator_color1);
   SetIndexBuffer(0, clouds1);
   SetIndexLabel(0,"Storm clouds");
   
   SetIndexStyle(1,DRAW_HISTOGRAM, 2, 1, indicator_color2);
   SetIndexBuffer(1, clouds2);
   SetIndexLabel(1,"Storm clouds");
   
   SetIndexStyle(2,DRAW_LINE,0,1,indicator_color3);
   SetIndexBuffer(2, silverlining1);
   SetIndexLabel(2,"resistance");
   
   SetIndexStyle(3,DRAW_LINE,0,1,indicator_color4);
   SetIndexBuffer(3, silverlining2);
   SetIndexLabel(3,"support");
   
   SetIndexStyle(4, DRAW_LINE,2,1,indicator_color5);
   SetIndexBuffer(4, ozone1);
   SetIndexLabel(2,"Ozone 1");
   
   SetIndexStyle(5, DRAW_LINE,2,1,indicator_color6);
   SetIndexBuffer(5, ozone2);
   SetIndexLabel(2,"Ozone 2");
   
   SetIndexStyle(6,DRAW_HISTOGRAM, 2, 1, indicator_color7);
   SetIndexBuffer(6, darkclouds1);
   SetIndexLabel(6,"Storm clouds");
   
   SetIndexStyle(7,DRAW_HISTOGRAM, 2, 1, indicator_color8);
   SetIndexBuffer(7, darkclouds2);
   SetIndexLabel(7,"Storm clouds");
   
   return(0);
  
}

int deinit() {

   double      upperBarrier[];
   double      lowerBarrier[];
   double      clouds1[];
   double      clouds2[];
   double      silverlining1[];
   double      silverlining2[];
   double      ozone1[];
   double      ozone2[];
   double      darkclouds1[];
   double      darkclouds2[];

}

int start() {

   int i;
   double sl;
   
   ArrayResize(upperBarrier,maxBars);
   ArrayResize(lowerBarrier,maxBars);
   ArrayResize(val1,maxBars);
   ArrayResize(val2,maxBars);
   
   int indicatorLength = maxBars;
   
   for (i=indicatorLength; i>=0; i--) {
      
      double trueRange = iATR(NULL, 0, trueRangePeriod, i);
      bool squeezeSignal = getSignal(i+1);
      double c1=0, c2=0;
      
      if (iFractals(NULL, 0, MODE_UPPER, i) != 0) {
         val1[i] = iFractals(NULL, 0, MODE_UPPER, i);
      } else {
         val1[i] = val1[i+1];
      }
      
      if (iFractals(NULL, 0, MODE_LOWER, i) != 0) {
         val2[i] = iFractals(NULL, 0, MODE_LOWER, i);
      } else {
         val2[i] = val2[i+1];
      }
            
      if (squeezeSignal) {
      
            count++;
         
            if (holder == 0 || i > holder-1) {
            
               upperBarrier[i]=High[i+1]+trueRange;
               lowerBarrier[i]=Low[i+1]-trueRange;
               holder = i;
               
            } else {
         
               upperBarrier[i]=upperBarrier[holder];
               lowerBarrier[i]=lowerBarrier[holder];
               
            }

      } else {
      
         upperBarrier[i] = upperBarrier[i+1];
         lowerBarrier[i] = lowerBarrier[i+1];
         holder = 0;
         count = 0;
             
      }

      sl = iATR(NULL,0,4,i);
      
      clearBuffers(i);
      
      clouds1[i] = upperBarrier[i+8]+sl+spread*Point;
      clouds2[i] = lowerBarrier[i+8]-sl;
      silverlining1[i] = clouds1[i];//+sl+spread*Point;
      silverlining2[i] = clouds2[i];//-sl;
      ozone1[i] = clouds1[i]+humidity*Point;
      ozone2[i] = clouds2[i]-humidity*Point;
      
      if (holder != 0) {
         darkclouds1[i] = clouds1[i];
         darkclouds2[i] = clouds2[i];
      }
      
      double tpLong = val1[i]-5*Point;
      double tpShort = val2[i]+5*Point;
      double slLong = val2[i]-5*Point;
      double slShort = val1[i]+5*Point;
      
      Comment ("Stormy Indicator v0.3 created by Akuma99 (http://akuma99.blogspot.com)\n\nWEATHER REPORT: \nCloud support: ", clouds2[i], " | Cloud resistance: ", silverlining1[i], " | Cloud Thickness: ", MathFloor((silverlining1[i] - silverlining2[i])/Point), "\nHumidity: 55, 89 or 144");
         
   }
   
   return(0);
  
}

void clearBuffers(int i) {
   
   darkclouds1[i] = NULL;
   darkclouds2[i] = NULL;
   ozone1[i] = NULL;
   ozone2[i] = NULL;
   clouds1[i] = NULL;
   clouds2[i] = NULL;
   silverlining1[i] = NULL;
   silverlining2[i] = NULL; 
      
}

bool getSignal(int shift) {

   double   basePrice, avg, upperKelt, lowerBB, upperBB, lowerKelt;
   
   basePrice = iMA(NULL, 0, kelt, 0, MODE_SMA, PRICE_TYPICAL, shift);
   avg  = findAvg(kelt, shift);

   lowerKelt = (basePrice-avg)-(buffer*Point);
   upperKelt = (basePrice+avg)+(buffer*Point);

   lowerBB = iBands(NULL,0,bb,bbDeviation,0,PRICE_CLOSE,MODE_LOWER,shift);
   upperBB = iBands(NULL,0,bb,bbDeviation,0,PRICE_CLOSE,MODE_UPPER,shift);

   if (lowerBB >= lowerKelt && upperBB <= upperKelt) {
   
      return (true);
      
   } else {
      
      return (false);
         
   }
      
}

double findAvg(int period, int shift) {

   double   sum=0;
   int      x;
   
   for (x=shift;x<(shift+period);x++) {     
      sum += High[x]-Low[x];
   }
   
   sum = sum/period;
   return (sum*keltFactor);
   
}
