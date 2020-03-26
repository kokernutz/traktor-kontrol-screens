import CSI 1.0
import "../../Defines"
import "../Common/ChannelFX"
import "../Common/DeckHelpers.js" as Helpers

Module
{
  id: module
  property bool shift: false

  // X-Fader
  Wire { from: "s3.mixer.xfader"; to: DirectPropertyAdapter { path: "app.traktor.mixer.xfader.adjust"; } }
  Wire { from: "s3.mixer.cue_mix"; to: DirectPropertyAdapter { path: "app.traktor.mixer.cue.mix"; } }

  AppProperty { id: deckDType; path: "app.traktor.decks.4.type"; }

  // Local variable for input mode
  MappingPropertyDescriptor { id: deckDInputModeProp; path: "mapping.deck_d_input_mode"; type: MappingPropertyDescriptor.Boolean; value: false }
  Wire { from: "s3.mixer.input_mode"; to: DirectPropertyAdapter { path: "mapping.deck_d_input_mode" } }

  Wire {
    from: "s3.mixer.ext";
    to: ButtonScriptAdapter
    {
      onPress:
      {
        if (module.shift)
        {
          // Toggles Deck D input between Line and Mic
          deckDInputModeProp.value = !deckDInputModeProp.value
        }
        else
        {
          // Toggles Deck D external input mode
          deckDType.value = (deckDType.value == DeckType.Live) ?
            Helpers.defaultTypeForDeck(4) : DeckType.Live;
        }
      }
      brightness: module.shift ? 1.0 : ((deckDType.value == DeckType.Live) ? 1.0 : 0.0)
    }
  }

  // Master Level Meters
  LEDLevelMeter { name: "leftMeter"; dBThresholds: [-15,-10,-7,-5,-3,-2,-1,0]; hasClipLED: true }
  Wire { from: "s3.mixer.level_meter.left"; to: "leftMeter" }
  Wire { from: "leftMeter.level"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.left"; input: false } }
  Wire { from: "leftMeter.clip"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.clip.left"; input: false } }

  LEDLevelMeter { name: "rightMeter"; dBThresholds: [-15,-10,-7,-5,-3,-2,-1,0]; hasClipLED: true }
  Wire { from: "s3.mixer.level_meter.right"; to: "rightMeter" }
  Wire { from: "rightMeter.level"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.right"; input: false } }
  Wire { from: "rightMeter.clip"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.clip.right"; input: false } }

  // Channels
  S3Channel
  {
    name:   "channel0"
    index:  1
  }

  S3Channel
  {
    name:   "channel1"
    index:  2
  }

  S3Channel
  {
    name:   "channel2"
    index:  3
  }

  S3Channel
  {
    name:   "channel3"
    index:  4
  }

  FourChannelFXSelector
  {
    name: "channelFxSelector"
    surface: "s3"
  }
}
