//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2006, Winning-Solution.Com "
#property link      "https://www.winning-solution.com/"

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 Navy
#property indicator_color2 Maroon
#property indicator_color3 SteelBlue
#property indicator_color4 Sienna

int gi_76 = 200810;
int gi_80 = D'02.01.2100 00:59';
int gi_84 = 10;
double g_ibuf_88[];
double g_ibuf_92[];
double g_ibuf_96[];
double g_ibuf_100[];
double gd_104;
double gd_112;
double gd_120;
double gd_128;
double gd_136;
double gd_144;
double gd_152;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void LifeTimeSecurityCode()
  {
   if(TimeCurrent() > gi_80)
     {
      main();
      return;
     }
   string ls_0 = "\nYour WSS Package need update to V" + gi_76 + ".. Please follow this procedure:";
   ls_0 = ls_0
          + "\n1. Login to member area http://winning-solution.com/login/";
   ls_0 = ls_0
          + "\n2. Go to Download Area";
   ls_0 = ls_0
          + "\n3. Download WSS Package";
   ls_0 = ls_0
          + "\n4. Re-Install it again";
   ls_0 = ls_0
          + "\n5. Restart your Metatrader 4";
   ls_0 = ls_0
          + "\nIf you have any problem, Please contact support@winning-solution.com";
   Comment(ls_0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int init()
  {
   SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID, 4);
   SetIndexBuffer(0, g_ibuf_88);
   SetIndexLabel(0, "Trend Up");
   SetIndexStyle(1, DRAW_HISTOGRAM, STYLE_SOLID, 4);
   SetIndexBuffer(1, g_ibuf_92);
   SetIndexLabel(1, "Trend Down");
   SetIndexStyle(2, DRAW_HISTOGRAM, STYLE_SOLID, 4);
   SetIndexBuffer(2, g_ibuf_96);
   SetIndexLabel(2, "Sideways, Trend Up Weak");
   SetIndexStyle(3, DRAW_HISTOGRAM, STYLE_SOLID, 4);
   SetIndexBuffer(3, g_ibuf_100);
   SetIndexLabel(3, "Sideways, Trend Down Weak");
   IndicatorShortName("OLD VERSION");
   return (0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int deinit()
  {
   return (0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
   LifeTimeSecurityCode();
   return (0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void main()
  {
   string ls_unused_36;
   double ld_60;
   double ld_68;
   double ld_76;
   double ld_84;
   double l_ima_92;
   double l_ima_100;
   double l_irsi_108;
   double ld_116;
   double l_imacd_124;
   double l_imacd_132;
   double l_iadx_140;
   double l_iadx_148;
   double l_icci_156;
   double ld_164;
   double l_iwpr_172;
   double ld_180;
   string l_time2str_0 = TimeToStr(TimeCurrent(), TIME_DATE);
   string l_time2str_8 = TimeToStr(TimeCurrent(), TIME_MINUTES|TIME_SECONDS);
   string l_time2str_16 = TimeToStr(TimeLocal() | 4);
   string l_time2str_24 = TimeToStr(TimeCurrent(), TIME_MINUTES|TIME_SECONDS);
   int l_str2time_44 = StrToTime("00:00:00");
   int l_str2time_48 = StrToTime("00:05:00");
   string l_time2str_52 = TimeToStr(TimeCurrent(), TIME_DATE|TIME_SECONDS);
   for(int li_188 = Bars - gi_84; li_188 >= 0; li_188--)
     {
      ld_60 = iHighest(NULL, 0, MODE_HIGH, gi_84 - 1, li_188);
      ld_68 = iLowest(NULL, 0, MODE_LOW, gi_84 - 1, li_188);
      ld_76 = 100 - 100.0 * ((ld_60 - li_188) / gi_84);
      ld_84 = 100 - 100.0 * ((ld_68 - li_188) / gi_84);
      if(ld_76 == 0.0)
         ld_76 = 0.0000001;
      if(ld_84 == 0.0)
         ld_84 = 0.0000001;
      gd_104 = ld_76 - ld_84;
      l_ima_92 = iMA(NULL, 0, 3, 0, MODE_EMA, PRICE_CLOSE, li_188);
      l_ima_100 = iMA(NULL, 0, 50, 0, MODE_EMA, PRICE_CLOSE, li_188);
      gd_112 = l_ima_92 - l_ima_100;
      l_irsi_108 = iRSI(NULL, 0, 14, PRICE_CLOSE, li_188);
      ld_116 = 50;
      gd_120 = l_irsi_108 - ld_116;
      l_imacd_124 = iMACD(NULL, 0, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, li_188);
      l_imacd_132 = iMACD(NULL, 0, 12, 26, 9, PRICE_CLOSE, MODE_SIGNAL, li_188);
      gd_128 = l_imacd_124 - l_imacd_132;
      l_iadx_140 = iADX(NULL, 0, 14, PRICE_CLOSE, MODE_PLUSDI, li_188);
      l_iadx_148 = iADX(NULL, 0, 14, PRICE_CLOSE, MODE_MINUSDI, li_188);
      gd_136 = l_iadx_140 - l_iadx_148;
      l_icci_156 = iCCI(NULL, 0, 14, PRICE_CLOSE, li_188);
      ld_164 = 0;
      gd_144 = l_icci_156 - ld_164;
      l_iwpr_172 = iWPR(NULL, 0, 14, li_188);
      ld_180 = -50;
      gd_152 = l_iwpr_172 - ld_180;
      if(gd_104 > 0.0 && gd_112 > 0.0 && gd_120 > 0.0 && gd_128 > 0.0 && gd_136 > 0.0 && gd_144 > 0.0 && gd_152 > 0.0)
        {
         g_ibuf_88[li_188] = 1;
         g_ibuf_92[li_188] = 0;
         g_ibuf_96[li_188] = 0;
         g_ibuf_100[li_188] = 0;
        }
      else
        {
         if(gd_104 <= 0.0 && gd_112 <= 0.0 && gd_120 <= 0.0 && gd_128 <= 0.0 && gd_136 <= 0.0 && gd_144 <= 0.0 && gd_152 <= 0.0)
           {
            g_ibuf_88[li_188] = 0;
            g_ibuf_92[li_188] = 1;
            g_ibuf_96[li_188] = 0;
            g_ibuf_100[li_188] = 0;
           }
         else
           {
            if(gd_112 > 0.0)
              {
               g_ibuf_88[li_188] = 0;
               g_ibuf_92[li_188] = 0;
               g_ibuf_96[li_188] = 1;
               g_ibuf_100[li_188] = 0;
              }
            else
              {
               if(gd_112 <= 0.0)
                 {
                  g_ibuf_88[li_188] = 0;
                  g_ibuf_92[li_188] = 0;
                  g_ibuf_96[li_188] = 0;
                  g_ibuf_100[li_188] = 1;
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
