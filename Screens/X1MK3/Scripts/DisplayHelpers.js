// Returns a short effect name to be shown on X1MK3 screens
function effectName(effect)
{
  switch (effect.toString())
  {
    case "Delay":
        return "DEL";

    case "Reverb":
        return "RVB";

    case "Flanger":
        return "FLNG";

    case "Flanger Pulse":
        return "FLNP";

    case "Flanger Flux":
        return "FLNF";

    case "Gater":
        return "GATE";

    case "Beatmasher 2":
        return "BTM2";

    case "Delay T3":
        return "DEL3";

    case "Filter LFO":
        return "FLFO";

    case "Filter Pulse":
        return "FPLS";

    case "Filter":
        return "F";

    case "Filter:92 LFO":
        return "F92L";

    case "Filter:92 Pulse":
        return "F92P";

    case "Filter:92":
        return "F92";

    case "Phaser":
        return "PH";

    case "Phaser Pulse":
        return "PHP";

    case "Phaser Flux":
        return "PHF";

    case "Reverse Grain":
        return "RGR";

    case "Turntable FX":
        return "TTBL";

    case "Iceverb":
        return "ICE";

    case "Reverb T3":
        return "RVB3";

    case "Ringmodulator":
        return "RING";

    case "Digital LoFi":
        return "LOFI";

    case "Mulholland Drive":
        return "MUL";

    case "Transpose Stretch":
        return "TSTR";

    case "BeatSlicer":
        return "BTSL";

    case "Formant Filter":
        return "FFLT";

    case "Peak Filter":
        return "PFLT";

    case "Tape Delay":
        return "TDEL";

    case "Ramp Delay":
        return "RDEL";

    case "Auto Bouncer":
        return "ABNC";

    case "Bouncer":
        return "BNC";

    case "¶ WormHole":
        return "WORM";

    case "¶ LaserSlicer":
        return "LS";

    case "¶ GranuPhase":
        return "GPH";

    case "¶ Bass-o-Matic":
        return "BOM";

    case "¶ PolarWind":
        return "PW";

    case "¶ EventHorizon":
        return "EH";

    case "¶ Zzzurp":
        return "ZZZ";

    case "¶ FlightTest":
        return "FT";

    case "¶ Strrretch (Slow)":
        return "STRS";

    case "¶ Strrretch (Fast)":
        return "STRF";

    case "¶ DarkMatter":
        return "DARK";

    default:
        return effect.toString().substring(0, 3);
  }
}

// Returns a short effect parameter name to be shown on X1MK3 screens
function parameterName(effect, knob)
{
  switch (effect.toString())
  {
    case "No Effect":
        return "";

    case "Delay":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "HPF";
            case 3: return "FB";
            case 4: return "RATE";
        }
        break;

    case "Reverb":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "HP";
            case 3: return "LP";
            case 4: return "SIZE";
        }
        break;

    case "Flanger":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "SPRD";
            case 3: return "FB";
            case 4: return "RATE";
        }
        break;

    case "Flanger Pulse":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "SHP";
            case 3: return "FB";
            case 4: return "AMT";
        }
        break;

    case "Flanger Flux":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "";
            case 3: return "FB";
            case 4: return "PTCH";
        }
        break;

    case "Gater":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "NOIZ";
            case 3: return "SHP";
            case 4: return "RATE";
        }
        break;

    case "Beatmasher 2":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "GATE";
            case 3: return "ROT";
            case 4: return "LEN";
        }
        break;

    case "Delay T3":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "FLTR";
            case 3: return "FB";
            case 4: return "RATE";
        }
        break;

    case "Filter LFO":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "SHP";
            case 3: return "RES";
            case 4: return "RATE";
        }
        break;

    case "Filter Pulse":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "SOFT";
            case 3: return "RES";
            case 4: return "AMNT";
        }
        break;

    case "Filter":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "HP";
            case 3: return "RES";
            case 4: return "LP";
        }
        break;

    case "Filter:92 LFO":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "SHP";
            case 3: return "RES";
            case 4: return "RATE";
        }
        break;

    case "Filter:92 Pulse":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "SFT";
            case 3: return "RES";
            case 4: return "AMT";
        }
        break;

    case "Filter:92":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "HP";
            case 3: return "RES";
            case 4: return "LP";
        }
        break;

    case "Phaser":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "SPRD";
            case 3: return "FB";
            case 4: return "RATE";
        }
        break;

    case "Phaser Pulse":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "SHP";
            case 3: return "FB";
            case 4: return "AMT";
        }
        break;

    case "Phaser Flux":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "";
            case 3: return "FB";
            case 4: return "PTCH";
        }
        break;

    case "Reverse Grain":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "PTCH";
            case 3: return "GR";
            case 4: return "SPD";
        }
        break;

    case "Turntable FX":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "AMNT";
            case 3: return "R.SPD";
            case 4: return "B.SPD";
        }
        break;

    case "Iceverb":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "ICE";
            case 3: return "CLR";
            case 4: return "SIZE";
        }
        break;

    case "Reverb T3":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "HP";
            case 3: return "LP";
            case 4: return "SIZE";
        }
        break;

    case "Ringmodulator":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "AM|RM";
            case 3: return "RAW";
            case 4: return "PTCH";
        }
        break;

    case "Digital LoFi":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "BIT";
            case 3: return "SMTH";
            case 4: return "SRTE";
        }
        break;

    case "Mulholland Drive":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "TONE";
            case 3: return "FB";
            case 4: return "DRIVE";
        }
        break;

    case "Transpose Stretch":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "STRH";
            case 3: return "GRNZ";
            case 4: return "KEY";
        }
        break;

    case "BeatSlicer":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "BZZ";
            case 3: return "ST";
            case 4: return "PAT";
        }
        break;

    case "Formant Filter":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "SHRP";
            case 3: return "SIZE";
            case 4: return "TALK";
        }
        break;

    case "Peak Filter":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "PUMP";
            case 3: return "EDGE";
            case 4: return "FREQ";
        }
        break;

    case "Tape Delay":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "LPF";
            case 3: return "FB";
            case 4: return "SPD";
        }
        break;

    case "Ramp Delay":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "FLTR";
            case 3: return "DUR";
            case 4: return "RATE";
        }
        break;

    case "Auto Bouncer":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "TRN";
            case 3: return "BEND";
            case 4: return "PTRN";
        }
        break;

    case "Bouncer":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "TRN";
            case 3: return "FLTR";
            case 4: return "SPD";
        }
        break;

    case "¶ WormHole":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "";
            case 3: return "";
            case 4: return "DPTH";
        }
        break;

    case "¶ LaserSlicer":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "";
            case 3: return "";
            case 4: return "DPTH";
        }
        break;

    case "¶ GranuPhase":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "";
            case 3: return "";
            case 4: return "DPTH";
        }
        break;

    case "¶ Bass-o-Matic":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "";
            case 3: return "";
            case 4: return "DPTH";
        }
        break;

    case "¶ PolarWind":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "";
            case 3: return "";
            case 4: return "DPTH";
        }
        break;

    case "¶ EventHorizon":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "";
            case 3: return "";
            case 4: return "DPTH";
        }
        break;

    case "¶ Zzzurp":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "";
            case 3: return "";
            case 4: return "DPTH";
        }
        break;

    case "¶ FlightTest":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "";
            case 3: return "";
            case 4: return "DPTH";
        }
        break;

    case "¶ Strrretch (Slow)":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "";
            case 3: return "";
            case 4: return "DPTH";
        }
        break;

    case "¶ Strrretch (Fast)":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "";
            case 3: return "";
            case 4: return "DPTH";
        }
        break;

    case "¶ DarkMatter":
        switch (knob)
        {
            case 1: return "D/W";
            case 2: return "";
            case 3: return "";
            case 4: return "DPTH";
        }
        break;
  }

  return effect.toString().substring(0, 3);
}
