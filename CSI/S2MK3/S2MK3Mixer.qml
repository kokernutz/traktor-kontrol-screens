import CSI 1.0
import S2MK3 1.0
import "../../Defines"

Module
{
  id: module

  // X-Fader
  Wire { from: "s2mk3.mixer.xfader"; to: DirectPropertyAdapter { path: "app.traktor.mixer.xfader.adjust"; } }
  Wire { from: "s2mk3.mixer.cue_mix"; to: DirectPropertyAdapter { path: "app.traktor.mixer.cue.mix"; } }

  // Microphone
  Wire 
  { 
    from: "s2mk3.mixer.mic"; 
    to: TogglePropertyAdapter { path: "app.traktor.mixer.mic_volume"; value: VolumeLevels.volumeZeroDb; defaultValue: VolumeLevels.minusInfDb } 
  }

  // Samples knob controls volume of deck C/D
  Wire { from: "s2mk3.mixer.samples"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels.3.volume" } }
  Wire { from: "s2mk3.mixer.samples"; to: DirectPropertyAdapter { path: "app.traktor.mixer.channels.4.volume" } }

  SamplesLevel { name: "SamplesLevel" }
  Wire { from: "s2mk3.mixer.samples_led"; to: "SamplesLevel" }

  // Channels
  S2MK3Channel
  {
    name:   "channel1"
    index:  1
  }

  S2MK3Channel
  {
    name:   "channel2"
    index:  2
  }

  S2MK3ChannelFxSelection
  {
    name:   "channelFxSelect"
  }

}
