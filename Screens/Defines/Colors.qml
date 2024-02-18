import QtQuick

QtObject {

  function rgba(r,g,b,a) { return Qt.rgba(  neutralizer(r)/255. ,  neutralizer(g)/255. ,  neutralizer(b)/255. , neutralizer(a)/255. ) }

  readonly property variant textColors:         [colors.colorDeckBlueBright,  colors.colorDeckBlueBright,   colors.colorGrey232,  colors.colorGrey232 ]
  readonly property variant mixerFXColors:      [colors.colorMixerFXOrange, colors.colorMixerFXRed, colors.colorMixerFXGreen, colors.colorMixerFXBlue, colorMixerFXYellow]

  property variant colorMixerFXOrange:          rgba(250, 132, 42, 255)
  property variant colorMixerFXRed:             rgba(254, 0, 0, 255)
  property variant colorMixerFXGreen:           rgba(78, 225, 12, 255)
  property variant colorMixerFXBlue:            rgba(92, 201, 238, 255)
  property variant colorMixerFXYellow:          rgba(254, 217, 36, 255)

  // this categorizes any rgb value to multiples of 8 for each channel to avoid unbalanced colors on the display (r5-g6-b5 bit)
  // function neutralizer(value) { if(value%8 > 4) { return  value - value%8 + 8} else { return  value - value%8 }}
  function neutralizer(value) { return value}

  property variant colorBlack:                  rgba (0, 0, 0, 255)
  property variant colorBlack94:                rgba (0, 0, 0, 240)
  property variant colorBlack88:                rgba (0, 0, 0, 224)
  property variant colorBlack85:                rgba (0, 0, 0, 217)
  property variant colorBlack81:                rgba (0, 0, 0, 207)
  property variant colorBlack78:                rgba (0, 0, 0, 199)
  property variant colorBlack75:                rgba (0, 0, 0, 191)
  property variant colorBlack69:                rgba (0, 0, 0, 176)
  property variant colorBlack66:                rgba (0, 0, 0, 168)
  property variant colorBlack63:                rgba (0, 0, 0, 161)
  property variant colorBlack60:                rgba (0, 0, 0, 153) // from 59 - 61%
  property variant colorBlack56:                rgba (0, 0, 0, 143) // 
  property variant colorBlack53:                rgba (0, 0, 0, 135) // from 49 - 51%
  property variant colorBlack50:                rgba (0, 0, 0, 128) // from 49 - 51%
  property variant colorBlack47:                rgba (0, 0, 0, 120) // from 46 - 48%
  property variant colorBlack44:                rgba (0, 0, 0, 112) // from 43 - 45%
  property variant colorBlack41:                rgba (0, 0, 0, 105) // from 40 - 42%
  property variant colorBlack38:                rgba (0, 0, 0, 97) // from 37 - 39%
  property variant colorBlack35:                rgba (0, 0, 0, 89) // from 33 - 36%
  property variant colorBlack31:                rgba (0, 0, 0, 79) // from 30 - 32%  
  property variant colorBlack28:                rgba (0, 0, 0, 71) // from 27 - 29%
  property variant colorBlack25:                rgba (0, 0, 0, 64) // from 24 - 26%
  property variant colorBlack22:                rgba (0, 0, 0, 56) // from 21 - 23%
  property variant colorBlack19:                rgba (0, 0, 0, 51) // from 18 - 20%
  property variant colorBlack16:                rgba (0, 0, 0, 41) // from 15 - 17%
  property variant colorBlack12:                rgba (0, 0, 0, 31) // from 11 - 13%
  property variant colorBlack09:                rgba (0, 0, 0, 23) // from 8 - 10%
  property variant colorBlack0:                 rgba (0, 0, 0, 0)

  property variant colorWhite:                  rgba (255, 255, 255, 255)
  property variant colorWhite75:                rgba (255, 255, 255, 191) 
  property variant colorWhite85:                rgba (255, 255, 255, 217)

  // property variant colorWhite60:                rgba (255, 255, 255, 153) // from 59 - 61%
  property variant colorWhite50:                rgba (255, 255, 255, 128) // from 49 - 51%
  // property variant colorWhite47:                rgba (255, 255, 255, 120) // from 46 - 48%
  // property variant colorWhite44:                rgba (255, 255, 255, 112) // from 43 - 45%
  property variant colorWhite41:                rgba (255, 255, 255, 105) // from 40 - 42%
  // property variant colorWhite38:                rgba (255, 255, 255, 97) // from 37 - 39%
  property variant colorWhite35:                rgba (255, 255, 255, 89) // from 33 - 36%
  // property variant colorWhite31:                rgba (255, 255, 255, 79) // from 30 - 32%  
  property variant colorWhite28:                rgba (255, 255, 255, 71) // from 27 - 29%
  property variant colorWhite25:                rgba (255, 255, 255, 64) // from 24 - 26%
  property variant colorWhite22:                rgba (255, 255, 255, 56) // from 21 - 23%
  property variant colorWhite19:                rgba (255, 255, 255, 51) // from 18 - 20%
  property variant colorWhite16:                rgba (255, 255, 255, 41) // from 15 - 17%
  property variant colorWhite12:                rgba (255, 255, 255, 31) // from 11 - 13%
  property variant colorWhite09:                rgba (255, 255, 255, 23) // from 8 - 10%
  property variant colorWhite06:                rgba (255, 255, 255, 15) // from 5 - 7%
  // property variant colorWhite03:                rgba (255, 255, 255, 8) // from 2 - 4%

  property variant colorGrey232:                rgba (232, 232, 232, 255)
  property variant colorGrey216:                rgba (216, 216, 216, 255)
  property variant colorGrey208:                rgba (208, 208, 208, 255)
  property variant colorGrey200:                rgba (200, 200, 200, 255)
  property variant colorGrey192:                rgba (192, 192, 192, 255)
  property variant colorGrey152:                rgba (152, 152, 152, 255)
  property variant colorGrey128:                rgba (128, 128, 128, 255)
  property variant colorGrey120:                rgba (120, 120, 120, 255)
  property variant colorGrey112:                rgba (112, 112, 112, 255)
  property variant colorGrey104:                rgba (104, 104, 104, 255)
  property variant colorGrey96:                 rgba (96, 96, 96, 255)
  property variant colorGrey88:                 rgba (88, 88, 88, 255) 
  property variant colorGrey80:                 rgba (80, 80, 80, 255) 
  property variant colorGrey72:                 rgba (72, 72, 72, 255) 
  property variant colorGrey64:                 rgba (64, 64, 64, 255) 
  property variant colorGrey56:                 rgba (56, 56, 56, 255) 
  property variant colorGrey48:                 rgba (48, 48, 48, 255) 
  property variant colorGrey40:                 rgba (40, 40, 40, 255)
  property variant colorGrey32:                 rgba (32, 32, 32, 255)
  property variant colorGrey24:                 rgba (24, 24, 24, 255)
  property variant colorGrey16:                 rgba (16, 16, 16, 255)
  property variant colorGrey08:                 rgba (08, 08, 08, 255)



  property variant colorOrange:                 rgba(208, 104, 0, 255) // FX Selection; FX Faders etc
  property variant colorOrangeDimmed:           rgba(96, 48, 0, 255)  

  property variant colorRed:                    rgba(255, 0, 0, 255)
  property variant colorRed70:                  rgba(185, 6, 6, 255)

  property variant colorGreenActive:            rgba( 82, 255, 148, 255)
  property variant colorGreenInactive:          rgba(  8,  56,  24, 255)
  property variant colorGreyInactive:           rgba(139, 145, 139, 255)


  // Playmarker
  property variant colorRedPlaymarker:          rgba(255, 0, 0, 255)
  property variant colorRedPlaymarker75:        rgba(255, 56, 26, 191)
  property variant colorRedPlaymarker06:        rgba(255, 56, 26, 31)

  // Playmarker
  property variant colorBluePlaymarker:         rgba(96, 184, 192, 255) //rgba(136, 224, 232, 255)

  property variant colorGreen:                  rgba(0, 255, 0, 255)
  property variant colorGreen50:                rgba(0, 255, 0, 128)
  property variant colorGreen12:                rgba(0, 255, 0, 31) // used for loop bg (in WaveformCues.qml)
  property variant colorGreenLoopOverlay:       rgba(96, 192, 128, 16)

  property variant colorGreen08:                rgba(0, 255, 0, 20)
  property variant colorGreen50Full:            rgba(0, 51, 0, 255)

  property variant colorGreenGreyMix:           rgba(139, 240, 139, 82)

  // font colors 
  property variant colorFontsListBrowser:       colorGrey72
  property variant colorFontsListFx:            colorGrey56
  property variant colorFontBrowserHeader:      colorGrey88
  property variant colorFontFxHeader:           colorGrey80 // also for FX header, FX select buttons

  // headers & footers backgrounds
  property variant colorBgEmpty:                colorGrey16 // also for empty decks & Footer Small (used to be colorGrey08)
  property variant colorBrowserHeader:          colorGrey24
  property variant colorFxHeaderBg:             colorGrey16 // also for large footer; fx overlay tabs         
  property variant colorFxHeaderLightBg:        colorGrey24


  property variant colorProgressBg:             colorGrey32 
  property variant colorProgressBgLight:        colorGrey48 
  property variant colorDivider:                colorGrey40

  property variant colorIndicatorBg:            rgba(20, 20, 20, 255)
  property variant colorIndicatorBg2:           rgba(31, 31, 31, 255)

  property variant colorIndicatorLevelGrey:     rgba(51, 51, 51, 255)
  property variant colorIndicatorLevelOrange:   rgba(247, 143, 30, 255)

  property variant colorCenterOverlayHeadline:  colorGrey88

// blue
  property variant colorDeckBlueBright:         rgba(0, 136, 184, 255) 
  property variant colorDeckBlueDark:           rgba(0, 64, 88, 255) 
  property variant colorDeckBlueBright20:       rgba(0, 174, 239, 51)
  property variant colorDeckBlueBright50Full:   rgba(0, 87, 120, 255)
  property variant colorDeckBlueBright12Full:   rgba(0, 8, 10, 255) //rgba(0, 23, 31, 255)
  property variant colorBrowserBlueBright:      rgba(0, 187, 255, 255)
  property variant colorBrowserBlueBright56Full:rgba(0, 114, 143, 255)

  property color footerBackgroundBlue: "#011f26"


  // fx Select overlay colors
  property variant fxSelectHeaderTextRGB:            rgba( 96,  96,  96, 255)
  property variant fxSelectHeaderNormalRGB:          rgba( 32,  32,  32, 255)
  property variant fxSelectHeaderNormalBorderRGB:    rgba( 32,  32,  32, 255)
  property variant fxSelectHeaderHighlightRGB:       rgba( 64,  64,  48, 255)
  property variant fxSelectHeaderHighlightBorderRGB: rgba(128, 128,  48, 255)

// Original Maschine 2 Display Colors
  // palette1-color1:                    rgb(255, 19, 15);
  // palette1-color2:                    rgb(255, 60, 20);
  // palette1-color3:                    rgb(255,120,  0);
  // palette1-color4:                    rgb(255,185,  0);
  // palette1-color5:                    rgb(255,255,  0);
  // palette1-color6:                    rgb(146,255,  0);
  // palette1-color7:                    rgb( 38,255, 38);
  // palette1-color8:                    rgb(  0,209,129);
  // palette1-color9:                    rgb(  0,180,233);
  // palette1-color10:                   rgb(  0,120,255);
  // palette1-color11:                   rgb(  0, 72,255);
  // palette1-color12:                   rgb(130,  0,255);
  // palette1-color13:                   rgb(162,  0,200);
  // palette1-color14:                   rgb(245,  0,200);
  // palette1-color15:                   rgb(255,  0,120);
  // palette1-color16:                   rgb(247,  7, 62); 


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
        case 0: return colorBgEmpty     // default color for this palette!
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
        case 0: return colorBgEmpty    // default color for this palette!
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
        case 0: return colorBgEmpty   // default color for this palette!
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
        return colorBgEmpty;
    }
    return colorBgEmpty;  // default color if no palette is set
  } 

  //--------------------------------------------------------------------------------------------------------------------

  //  Browser

  //--------------------------------------------------------------------------------------------------------------------

  property variant browser:
  QtObject {
    property color prelisten:   rgba(223, 178, 30, 255)
    property color prevPlayed:  rgba(32, 32, 32, 255) 
  }

  //--------------------------------------------------------------------------------------------------------------------

  //  Hotcues

  //--------------------------------------------------------------------------------------------------------------------

  property variant hotcue:
  QtObject {
    property color grid:   colorWhite
    property color hotcue: colorDeckBlueBright
    property color fade:   color03Bright
    property color load:   color05Bright
    property color loop:   color07Bright
    property color temp:   "grey"
  }

  property variant hotcueColors: {
    1: color01Bright,
    2: color03Bright,
    3: color05Bright,
    4: color07Bright,
    5: color09Bright,
    6: color11Bright,
    7: color13Bright,
    8: color15Bright
  }

  //--------------------------------------------------------------------------------------------------------------------

  //  Freeze & Slicer

  //--------------------------------------------------------------------------------------------------------------------

  property variant freeze:
  QtObject {
    property color box_inactive:  "#199be7ef"
    property color box_active:    "#ff9be7ef"
    property color marker:        "#4DFFFFFF"
    property color slice_overlay: "white" // flashing rectangle
  }

  property variant slicer:
  QtObject {
   property color box_active:      rgba(20,195,13,255)
    property color box_inrange:    rgba(20,195,13,90)
    property color box_inactive:   rgba(20,195,13,25)
    property color marker_default: rgba(20,195,13,77)
    property color marker_beat:    rgba(20,195,13,150)
    property color marker_edge:    box_active
  }

  //--------------------------------------------------------------------------------------------------------------------

  //  Musical Key coloring for the browser

  //--------------------------------------------------------------------------------------------------------------------
  property variant color01MusicalKey: rgba (255,  0,  0, 255) // not yet in use
  property variant color02MusicalKey: rgba (255,  64,  0, 255)
  property variant color03MusicalKey: rgba (255, 120,   0, 255) // not yet in use
  property variant color04MusicalKey: rgba (255, 200,   0, 255)
  property variant color05MusicalKey: rgba (255, 255,   0, 255)
  property variant color06MusicalKey: rgba (210, 255,   0, 255) // not yet in use
  property variant color07MusicalKey: rgba (  0, 255,   0, 255)
  property variant color08MusicalKey: rgba (  0, 255, 128, 255)
  //property variant color09MusicalKey: rgba (  0, 200, 232, 255)
  property variant color09MusicalKey: colorDeckBlueBright // use the same color as for the browser selection
  property variant color10MusicalKey: rgba (  0, 100, 255, 255)
  property variant color11MusicalKey: rgba (  0,  40, 255, 255)
  property variant color12MusicalKey: rgba (128,   0, 255, 255)
  property variant color13MusicalKey: rgba (160,   0, 200, 255) // not yet in use
  property variant color14MusicalKey: rgba (240,   0, 200, 255)
  property variant color15MusicalKey: rgba (255,   0, 120, 255) // not yet in use
  property variant color16MusicalKey: rgba (248,   8,  64, 255)

  property variant musicalKeyColors: [
    color15Bright,        //0   -11 c
    color06Bright,        //1   -4  c#, db
    color11MusicalKey,    //2   -13 d
    color03Bright,        //3   -6  d#, eb
    color09MusicalKey,    //4   -16 e
    color01Bright,        //5   -9  f
    color07MusicalKey,    //6   -2  f#, gb
    color13Bright,        //7   -12 g
    color04MusicalKey,    //8   -5  g#, ab
    color10MusicalKey,    //9   -15 a
    color02MusicalKey,    //10  -7  a#, bb
    color08MusicalKey,    //11  -1  b
    color03Bright,        //12  -6  cm
    color09MusicalKey,    //13  -16 c#m, dbm 
    color01Bright,        //14  -9  dm
    color07MusicalKey,    //15  -2  d#m, ebm
    color13Bright,        //16  -12 em
    color04MusicalKey,    //17  -5  fm
    color10MusicalKey,    //18  -15 f#m, gbm
    color02MusicalKey,    //19  -7  gm
    color08MusicalKey,    //20  -1  g#m, abm
    color15Bright,        //21  -11 am
    color06Bright,        //22  -4  a#m, bbm
    color11MusicalKey     //23  -13 bm
  ]

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
      high1: rgba (255, 210, 220, 140),  high2: rgba (255, 220, 230, 160) },
    // Spectrum 1 - KOKERNUTZ
    { low1:  rgba (255,  50,   0, 150),  low2:  rgba (255,  70,  20, 170),
      mid1:  rgba ( 80, 245,  80, 110),  mid2:  rgba ( 95, 245,  95, 130),
      high1: rgba ( 30,  85, 170, 255),  high2: rgba ( 50, 100, 180, 255)},
    // Spectrum 2 - NEXUS
    { low1:  rgba (200,   0,   0, 100),  low2:  rgba (200, 100,   0, 250),
      mid1:  rgba (60,  120, 240, 100),  mid2:  rgba (80,  160, 240, 250),
      high1: rgba (100, 200, 240, 100),  high2: rgba (120, 240, 240, 250)},
    // Spectrum 3 - PRIME
    { low1:  rgba ( 41, 113, 246, 100),  low2:  rgba ( 41, 113, 246, 250),
      mid1:  rgba ( 98, 234,  82, 100),  mid2:  rgba ( 98, 234,  82, 250),
      high1: rgba (255, 255, 255, 100),  high2: rgba (255, 255, 255, 250)},
    // Spectrum 4 - Denon SC5000 / SC6000
    { low1:  rgba ( 42, 112, 245, 100),  low2:  rgba ( 42, 114, 247, 250),
      mid1:  rgba ( 99, 235,  83, 100),  mid2:  rgba ( 99, 235,  83, 250),
      high1: rgba (255, 255, 255, 100),  high2: rgba (255, 255, 255, 250)},
    // Spectrum 5 - Pioneer CDJ 2000
    { low1:  rgba (204,   0,   0, 100),  low2:  rgba (204, 104,   0, 250),
      mid1:  rgba (64,  124, 244, 100),  mid2:  rgba ( 84, 164, 244, 250),
      high1: rgba (104, 204, 244, 100),  high2: rgba (124, 244, 244, 250)},
    // Spectrum 6 - Pioneer CDJ 3000
    { low1:  rgba (26,   50, 142, 200),  low2:  rgba (  2, 186, 234, 180),
      mid1: rgba  (255, 112,   2, 255),  mid2:  rgba (245, 122,  12, 160),
      high1: rgba (234, 234, 234, 255),  high2: rgba (154, 154, 154, 255)},
	  // Spectrum 7 - NUMARK
    { low1:  rgba ( 30,  50, 120, 160),  low2:  rgba ( 28, 182, 226, 170),
      mid1:  rgba ( 80, 228,  80, 110),  mid2:  rgba (120, 246, 120, 130),
      high1: rgba (255, 150,   3, 255),  high2: rgba (245, 176,  18, 255)}
  ]

  function getDefaultWaveformColors()
  {
    return waveformColorsMap[prefs.spectrumWaveformColors ? (16+prefs.spectrumWaveformColors) : 0];
  }

  function getWaveformColors(colorId)
  {
    if(colorId <= 16) {
      return waveformColorsMap[colorId];
    }

    return waveformColorsMap[0];
  }
}
