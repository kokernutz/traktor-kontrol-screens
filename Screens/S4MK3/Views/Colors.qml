import QtQuick 2.0

QtObject {

  function rgba(r,g,b,a) { return Qt.rgba(  r/255. ,  g/255. ,  b/255. , a/255. ) }
  function darkerColor( c, factor ) { return Qt.rgba(factor*c.r, factor*c.g, factor*c.b, c.a); }
  function opacity( c, factor ) { return Qt.rgba(c.r, c.g, c.b, factor * c.a); }


  property color defaultBackground:             "black"
  property color defaultTextColor:              "white"
  property color loopActiveColor:               rgba(0,255,70,255)
  property color loopActiveDimmedColor:         rgba(0,255,70,190)
  property color grayBackground:                "#ff333333"

  property variant colorRedPlaymarker:          rgba(255, 0, 0, 255)
  property variant colorRedPlaymarker75:        rgba(255, 56, 26, 191)
  property variant colorRedPlaymarker06:        rgba(255, 56, 26, 31)
  property variant colorBluePlaymarker:         rgba(96, 184, 192, 255)

  property variant colorBlack50:                rgba (0, 0, 0, 128) 
  property variant colorBlack:                  rgba (0, 0, 0, 255) 

  property variant colorDeckBrightGrey:         rgba (85, 85,  85,  255)
  property variant colorDeckGrey:               rgba (70, 70,  70,  255)
  property variant colorDeckDarkGrey:           rgba (40, 40,  40,   255)
  
  property variant colorDeckBlueBright:         rgba(0, 136, 184, 255) 
  property variant colorWhite:                  rgba (255, 255, 255, 255)

  property variant colorRed:                    rgba(255,0,80,255)

  property variant colorEnabledCyan:            rgba(96, 220, 255, 255)

  //--------------------------------------------------------------------------------------------------------------------

  //  Waveform coloring

  //--------------------------------------------------------------------------------------------------------------------
  

  property variant waveformColorsMap: [
    // Default
    { low1:  rgba (24,   48,  80, 180),  low2:  rgba (24,   56,  96, 190),
      mid1:  rgba (80,  160, 160, 100),  mid2:  rgba (48,  112, 112, 150),
      high1: rgba (184, 240, 232, 120),  high2: rgba (208, 255, 248, 180) },
    // Red - #c80000
    { low1:  rgba (200,   0,   0, 150),  low2:  rgba (200,  30,  30, 155),
      mid1:  rgba (180, 100, 100, 120),  mid2:  rgba (180, 110, 110, 140),
      high1: rgba (220, 180, 180, 140),  high2: rgba (220, 200, 200, 160) },
    // Dark Orange - #ff3200
    { low1:  rgba (255,  50,   0, 150),  low2:  rgba (255,  70,  20, 170),
      mid1:  rgba (180,  70,  50, 120),  mid2:  rgba (180,  90,  70, 140),
      high1: rgba (255, 200, 160, 140),  high2: rgba (255, 220, 180, 160) },
    // Light Orange - #ff6e00
    { low1:  rgba (255, 110,   0, 150),  low2:  rgba (245, 120,  10, 160),
      mid1:  rgba (255, 150,  80, 120),  mid2:  rgba (255, 160,  90, 140),
      high1: rgba (255, 220, 200, 140),  high2: rgba (255, 230, 210, 160) },
    // Warm Yellow - #ffa000
    { low1:  rgba (255, 160,   0, 160),  low2:  rgba (255, 170,  20, 170),
      mid1:  rgba (255, 180,  70, 120),  mid2:  rgba (255, 190,  90, 130),
      high1: rgba (255, 210, 135, 140),  high2: rgba (255, 220, 145, 160) },
    // Yellow - #ffc800
    { low1:  rgba (255, 200,   0, 160),  low2:  rgba (255, 210,  20, 170),
      mid1:  rgba (241, 230, 110, 120),  mid2:  rgba (241, 240, 120, 130),
      high1: rgba (255, 255, 200, 120),  high2: rgba (255, 255, 210, 180) },
    // Lime - #64aa00
    { low1:  rgba (100, 170,   0, 150),  low2:  rgba (100, 170,   0, 170),
      mid1:  rgba (190, 250,  95, 120),  mid2:  rgba (190, 255, 100, 150),
      high1: rgba (230, 255, 185, 120),  high2: rgba (230, 255, 195, 180) },
    // Green - #0a9119
    { low1:  rgba ( 10, 145,  25, 150),  low2:  rgba ( 20, 145,  35, 170),
      mid1:  rgba ( 80, 245,  80, 110),  mid2:  rgba ( 95, 245,  95, 130),
      high1: rgba (185, 255, 185, 140),  high2: rgba (210, 255, 210, 180) },
    // Mint - #00be5a
    { low1:  rgba (  0, 155, 110, 150),  low2:  rgba ( 10, 165, 130, 170),
      mid1:  rgba ( 20, 235, 165, 120),  mid2:  rgba ( 20, 245, 170, 150),
      high1: rgba (200, 255, 235, 140),  high2: rgba (210, 255, 245, 170) },
    // Cyan - #009b6e
    { low1:  rgba ( 10, 200, 200, 150),  low2:  rgba ( 10, 210, 210, 170),
      mid1:  rgba (  0, 245, 245, 120),  mid2:  rgba (  0, 250, 250, 150),
      high1: rgba (170, 255, 255, 140),  high2: rgba (180, 255, 255, 170) },
    // Turquoise - #0aa0aa
    { low1:  rgba ( 10, 130, 170, 150),  low2:  rgba ( 10, 130, 180, 170),
      mid1:  rgba ( 50, 220, 255, 120),  mid2:  rgba ( 60, 220, 255, 140),
      high1: rgba (185, 240, 255, 140),  high2: rgba (190, 245, 255, 180) },
    // Blue - #1e55aa
    { low1:  rgba ( 30,  85, 170, 150),  low2:  rgba ( 50, 100, 180, 170),
      mid1:  rgba (115, 170, 255, 120),  mid2:  rgba (130, 180, 255, 140),
      high1: rgba (200, 230, 255, 140),  high2: rgba (215, 240, 255, 170) },
    //Plum - #6446a0
    { low1:  rgba (100,  70, 160, 150),  low2:  rgba (120,  80, 170, 170),
      mid1:  rgba (180, 150, 230, 120),  mid2:  rgba (190, 160, 240, 150),
      high1: rgba (220, 210, 255, 140),  high2: rgba (230, 220, 255, 160) },
    // Violet - #a028c8
    { low1:  rgba (160,  40, 200, 140),  low2:  rgba (170,  50, 190, 170),
      mid1:  rgba (200, 135, 255, 120),  mid2:  rgba (210, 155, 255, 150),
      high1: rgba (235, 210, 255, 140),  high2: rgba (245, 220, 255, 170) },
    // Purple - #c81ea0
    { low1:  rgba (200,  30, 160, 150),  low2:  rgba (210,  40, 170, 170),
      mid1:  rgba (220, 130, 240, 120),  mid2:  rgba (230, 140, 245, 140),
      high1: rgba (250, 200, 255, 140),  high2: rgba (255, 200, 255, 170) },
    // Magenta - #e60a5a
    { low1:  rgba (230,  10,  90, 150),  low2:  rgba (240,  10, 100, 170),
      mid1:  rgba (255, 100, 200, 120),  mid2:  rgba (255, 120, 220, 150),
      high1: rgba (255, 200, 255, 140),  high2: rgba (255, 220, 255, 160) },
    // Fuchsia - #ff0032
    { low1:  rgba (255,   0,  50, 150),  low2:  rgba (255,  30,  60, 170),
      mid1:  rgba (255, 110, 110, 130),  mid2:  rgba (255, 125, 125, 160),
      high1: rgba (255, 210, 220, 140),  high2: rgba (255, 220, 230, 160) }
  ]

  function getDefaultWaveformColors()
  {
    return waveformColorsMap[0];
  }

  function getWaveformColors(colorId)
  {
    if(colorId <= 16) {
      return waveformColorsMap[colorId];
    }

    return waveformColorsMap[0];
  }

  // 16 Colors Palette (Bright)
  property variant color01Bright: rgba (255,  0,  0, 255)
  property variant color02Bright: rgba (255,  16,  16, 255)
  property variant color03Bright: rgba (255, 120,   0, 255)
  property variant color04Bright: rgba (255, 184,   0, 255)
  property variant color05Bright: rgba (255, 255,   0, 255)
  property variant color06Bright: rgba (144, 255,   0, 255)
  property variant color07Bright: rgba ( 40, 255,  40, 255)
  property variant color08Bright: rgba (  0, 208, 128, 255)
  property variant color09Bright: rgba (  0, 184, 232, 255)
  property variant color10Bright: rgba (  0, 120, 255, 255)
  property variant color11Bright: rgba (  0,  72, 255, 255)
  property variant color12Bright: rgba (128,   0, 255, 255)
  property variant color13Bright: rgba (160,   0, 200, 255)
  property variant color14Bright: rgba (240,   0, 200, 255)
  property variant color15Bright: rgba (255,   0, 120, 255)
  property variant color16Bright: rgba (248,   8,  64, 255)

  // 16 Colors Palette (Mid)
  property variant color01Mid: rgba (112, 8,   8, 255)
  property variant color02Mid: rgba (112, 24,  8, 255)
  property variant color03Mid: rgba (112, 56,  0, 255)
  property variant color04Mid: rgba (112, 80,  0, 255)
  property variant color05Mid: rgba (96,  96, 0, 255)
  property variant color06Mid: rgba (56,  96, 0, 255)
  property variant color07Mid: rgba (8,  96,  8, 255)
  property variant color08Mid: rgba (0,   90, 60, 255)
  property variant color09Mid: rgba (0,   77, 77, 255)
  property variant color10Mid: rgba (0, 84, 108, 255)
  property variant color11Mid: rgba (32, 56, 112, 255)
  property variant color12Mid: rgba (72, 32, 120, 255)
  property variant color13Mid: rgba (80, 24, 96, 255)
  property variant color14Mid: rgba (111, 12, 149, 255)
  property variant color15Mid: rgba (122, 0, 122, 255)
  property variant color16Mid: rgba (130, 1, 43, 255)

  // 16 Colors Palette (Dark)
  property variant color01Dark: rgba (16,  0,  0,  255)
  property variant color02Dark: rgba (16,  8,  0,  255)
  property variant color03Dark: rgba (16,  8,  0,  255)
  property variant color04Dark: rgba (16,  16, 0,  255)
  property variant color05Dark: rgba (16,  16, 0,  255)
  property variant color06Dark: rgba (8,   16, 0,  255)
  property variant color07Dark: rgba (8,   16, 8,  255)
  property variant color08Dark: rgba (0,   16, 8,  255)
  property variant color09Dark: rgba (0,   8,  16, 255)
  property variant color10Dark: rgba (0,   8,  16, 255)
  property variant color11Dark: rgba (0,   0,  16, 255)
  property variant color12Dark: rgba (8,   0,  16, 255)
  property variant color13Dark: rgba (8,   0,  16, 255)
  property variant color14Dark: rgba (16,  0,  16, 255)
  property variant color15Dark: rgba (16,  0,  8,  255)
  property variant color16Dark: rgba (16,  0,  8,  255)

  function palette(brightness, colorId) {
    if ( brightness >= 0.666 && brightness <= 1.0 ) { // bright color
      switch(colorId) {
        case 0: return defaultBackground     // default color for this palette!
        case 1: return color01Bright
        case 2: return color02Bright
        case 3: return color03Bright
        case 4: return color04Bright
        case 5: return color05Bright
        case 6: return color06Bright
        case 7: return color07Bright
        case 8: return color08Bright
        case 9: return color09Bright
        case 10: return color10Bright
        case 11: return color11Bright
        case 12: return color12Bright
        case 13: return color13Bright
        case 14: return color14Bright
        case 15: return color15Bright
        case 16: return color16Bright
        case 17: return "grey"
        case 18: return colorGrey232
      }
    } else if ( brightness >= 0.333 && brightness < 0.666 ) { // mid color
      switch(colorId) {
        case 0: return defaultBackground    // default color for this palette!
        case 1: return color01Mid
        case 2: return color02Mid
        case 3: return color03Mid
        case 4: return color04Mid
        case 5: return color05Mid
        case 6: return color06Mid
        case 7: return color07Mid
        case 8: return color08Mid
        case 9: return color09Mid
        case 10: return color10Mid
        case 11: return color11Mid
        case 12: return color12Mid
        case 13: return color13Mid
        case 14: return color14Mid
        case 15: return color15Mid
        case 16: return color16Mid
        case 17: return "grey"
        case 18: return colorGrey232
      }
    } else if ( brightness >= 0 && brightness < 0.333 ) { // dimmed color
      switch(colorId) {
        case 0: return defaultBackground   // default color for this palette!
        case 1: return color01Dark
        case 2: return color02Dark
        case 3: return color03Dark
        case 4: return color04Dark
        case 5: return color05Dark
        case 6: return color06Dark
        case 7: return color07Dark
        case 8: return color08Dark
        case 9: return color09Dark
        case 10: return color10Dark
        case 11: return color11Dark
        case 12: return color12Dark
        case 13: return color13Dark
        case 14: return color14Dark
        case 15: return color15Dark
        case 16: return color16Dark
        case 17: return "grey"
        case 18: return colorGrey232
      }
    } else if ( brightness < 0) { // color Off
        return defaultBackground;
    }
    return defaultBackground;  // default color if no palette is set
  } 



  property variant hotcue:
  QtObject {
    property color grid:   colorWhite
    property color hotcue: rgba(96, 220, 255, 255)
    property color fade:   color03Bright
    property color load:   color05Bright
    property color loop:   color07Bright
    property color temp:   "grey"
  }

  //--------------------------------------------------------------------------------------------------------------------
  //  Musical Key coloring
  //--------------------------------------------------------------------------------------------------------------------

  property variant musicalKeyColors: [
  rgba(255,  64, 235, 255),    //0   -11 c
  rgba(153, 255,   0, 255),    //1   -4  c#, db
  rgba( 81, 179, 254, 255),    //2   -13 d
  rgba(250, 141,  41, 255),    //3   -6  d#, eb
  rgba(  0, 232, 232, 255),    //4   -16 e
  rgba(253,  74,  74, 255),    //5   -9  f
  rgba( 64, 255,  64, 255),    //6   -2  f#, gb
  rgba(225, 131, 255, 255),    //7   -12 g
  rgba(255, 215,   0, 255),    //8   -5  g#, ab
  rgba(  0, 202, 255, 255),    //9   -15 a
  rgba(255, 101,  46, 255),    //10  -7  a#, bb
  rgba(  0, 214, 144, 255),    //11  -1  b
  rgba(250, 141,  41, 255),    //12  -6  cm
  rgba(  0, 232, 232, 255),    //13  -16 c#m, dbm
  rgba(253,  74,  74, 255),    //14  -9  dm
  rgba( 64, 255,  64, 255),    //15  -2  d#m, ebm
  rgba(213, 125, 255, 255),    //16  -12 em
  rgba(255, 215,   0, 255),    //17  -5  fm
  rgba(  0, 202, 255, 255),    //18  -15 f#m, gbm
  rgba(255, 101,  46, 255),    //19  -7  gm
  rgba(  0, 214, 144, 255),    //20  -1  g#m, abm
  rgba(255,  64, 235, 255),    //21  -11 am
  rgba(153, 255,   0, 255),    //22  -4  a#m, bbm
  rgba( 86, 189, 254, 255)     //23  -13 bm
]

  //this list will be filled with Component.onCompleted() based on musicalKeyColor (see further down)
  property variant musicalKeyDarkColors: []

  Component.onCompleted: {
    for(var i = 0; i<musicalKeyColors.length; i++)
    {
      musicalKeyDarkColors.push( darkerColor(musicalKeyColors[i], 0.7) );
    }
  }
  
}


