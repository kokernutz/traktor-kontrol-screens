import CSI 1.0
import "../Common/ChannelFX"

Module
{
  id: module
  property bool shift: false

  // X-Fader
  Wire { from: "s4mk3.mixer.xfader.position"; to: DirectPropertyAdapter { path: "app.traktor.mixer.xfader.adjust" } }

  Wire { from: "s4mk3.mixer.xfader.curve.blend";    to: SetPropertyAdapter { path: "app.traktor.mixer.xfader.curve"; value: 0.0  } }
  Wire { from: "s4mk3.mixer.xfader.curve.steep";    to: SetPropertyAdapter { path: "app.traktor.mixer.xfader.curve"; value: 0.5  } }
  Wire { from: "s4mk3.mixer.xfader.curve.scratch";  to: SetPropertyAdapter { path: "app.traktor.mixer.xfader.curve"; value: 1.0  } }

  // Quant and Snap
  Wire { enabled: !module.shift; from: "s4mk3.mixer.quant"; to: TogglePropertyAdapter { path: "app.traktor.quant" } }
  Wire { enabled:  module.shift; from: "s4mk3.mixer.quant"; to: TogglePropertyAdapter { path: "app.traktor.snap"  } }

  // Master Level Meters
  LEDLevelMeter { name: "leftMeter"; dBThresholds: [-15,-10,-7,-5,-3,-2,-1,0]; hasClipLED: true }
  Wire { from: "s4mk3.mixer.level_meter.left"; to: "leftMeter" }
  Wire { from: "leftMeter.level"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.left"; input: false } }
  Wire { from: "leftMeter.clip"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.clip.left"; input: false } }

  LEDLevelMeter { name: "rightMeter"; dBThresholds: [-15,-10,-7,-5,-3,-2,-1,0]; hasClipLED: true }
  Wire { from: "s4mk3.mixer.level_meter.right"; to: "rightMeter" }
  Wire { from: "rightMeter.level"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.right"; input: false } }
  Wire { from: "rightMeter.clip"; to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.clip.right"; input: false } }

  // Channels
  S4MK3Channel
  {
    name:   "channel1"
    index:  1
    shift: module.shift
  }

  S4MK3Channel
  {
    name:   "channel2"
    index:  2
    shift: module.shift
  }

  S4MK3Channel
  {
    name:   "channel3"
    index:  3
    shift: module.shift
  }

  S4MK3Channel
  {
    name:   "channel4"
    index:  4   
    shift: module.shift
  }

  FourChannelFXSelector
  {
    name: "channelFxSelector"
    surface: "s4mk3"
  }
}
