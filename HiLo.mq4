#property indicator_chart_window
#property indicator_buffers 4

// Input parameters
input ENUM_TIMEFRAMES Timeframe = PERIOD_CURRENT;  // Selectable timeframe
input color LineColor=White;
input int LineWidth=3;
input int LineStyle=STYLE_SOLID;
input int Lookback = 1440;
input int LineCount = 5; // Number of additional lines
input bool UseClose = false; // Use highest close and lowest close instead of highest high and lowest low

double HighBuffer[];
double LowBuffer[];
double MidHighBuffer[];
double MidLowBuffer[];

void OnInit()
{
   SetIndexBuffer(0, HighBuffer, INDICATOR_DATA);
   SetIndexBuffer(1, LowBuffer, INDICATOR_DATA);
   SetIndexBuffer(2, MidHighBuffer, INDICATOR_DATA);
   SetIndexBuffer(3, MidLowBuffer, INDICATOR_DATA);

   // Set the line properties
   SetIndexStyle(0, DRAW_LINE, LineStyle, LineWidth, LineColor); SetIndexLabel (0, "NigeHigh");
   SetIndexStyle(1, DRAW_LINE, LineStyle, LineWidth, LineColor); SetIndexLabel (1, "NigeLow");
   SetIndexStyle(2, DRAW_LINE, LineStyle, LineWidth, LineColor); SetIndexLabel (2, "NigeMidHigh");
   SetIndexStyle(3, DRAW_LINE, LineStyle, LineWidth, LineColor); SetIndexLabel (3, "NigeMidLow");

   // Set the timeframe
   SetIndexDrawBegin(0, Bars - Lookback - 1 - iBarShift(NULL, Timeframe, Time[0]));
   SetIndexDrawBegin(1, Bars - Lookback - 1 - iBarShift(NULL, Timeframe, Time[0]));
   SetIndexDrawBegin(2, Bars - Lookback - 1 - iBarShift(NULL, Timeframe, Time[0]));
   SetIndexDrawBegin(3, Bars - Lookback - 1 - iBarShift(NULL, Timeframe, Time[0]));
}

int OnCalculate(const int rates_total, const int prev_calculated, const datetime &time[], const double &open[], const double &high[], const double &low[], const double &close[], const long &tick_volume[], const long &volume[], const int &spread[])
{
   int limit = rates_total - prev_calculated;
   int shift = iBarShift(NULL, Timeframe, Time[0]);
   
   for (int i = 0; i < limit; i++)
   {
      double high_val = 0.0, low_val = 0.0;
      if (UseClose) {
         high_val = close[i];
         low_val = close[i];
         for (int j = 0; j < Lookback; j++) {
            if (close[i+j] > high_val || j == 0) high_val = close[i+j];
            if (close[i+j] < low_val || j == 0) low_val = close[i+j];
         }
      } else {
         high_val = high[i];
         low_val = low[i];
         for (int k = 0; k < Lookback; k++) { // fixed loop counter variable
            if (high[i+k] > high_val || k == 0) high_val = high[i+k];
            if (low[i+k] < low_val || k == 0) low_val = low[i+k];
         }
      }
      HighBuffer[i+shift] = high_val;
      LowBuffer[i+shift] = low_val;
    //  MidHighBuffer[i+shift] = (high_val + low_val) / 2.0 + (LineCount - 1 - i);
    //  MidLowBuffer[i+shift] = (high_val + low_val) / 2.0 - (LineCount - 1 - i);
      
      // Calculate additional lines
      double range = high_val - low_val;
      for (int l = 0; l < LineCount; l++) {
         double mid_low_val = high_val - (range / (LineCount + 1) * (l+1));
         double mid_high_val = low_val + (range / (LineCount + 1) * (l+1));
         MidHighBuffer[i+shift] = mid_high_val;
         MidLowBuffer[i+shift] = mid_low_val;
      }


   }
   return(rates_total);
}
