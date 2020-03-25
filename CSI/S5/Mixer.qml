import CSI 1.0

Module
{
	id: mixer
	property bool shift:     false
	property string surface: ""

  // Master Clock
	MasterClock { name: "MasterTempo" }
  Wire { from: "%surface%.mixer.tempo"; to: "MasterTempo.coarse"; enabled:  shift }
  Wire { from: "%surface%.mixer.tempo"; to: "MasterTempo.fine";   enabled: !shift }


  // Channels
  Channel
  {
    name:    "channel1"
    surface: "s5.mixer.channels"
    shift:   mixer.shift
    number:  1
  }

  Channel
  {
    name:    "channel2"
    surface: "s5.mixer.channels"
    shift:   mixer.shift
    number:  2
  }

  Channel
  {
    name:    "channel3"
    surface: "s5.mixer.channels"
    shift:   mixer.shift
    number:  3
  }

  Channel
  {
    name:    "channel4"
    surface: "s5.mixer.channels"
    shift:   mixer.shift
    number:  4
  }

  // Xfader
  Wire { from: "%surface%.mixer.xfader.adjust"; to: DirectPropertyAdapter { path: "app.traktor.mixer.xfader.adjust"; } }

  // Snap / Quant
  Wire { from: "%surface%.mixer.snap";  to: TogglePropertyAdapter { path: "app.traktor.snap";  } }
  Wire { from: "%surface%.mixer.quant"; to: TogglePropertyAdapter { path: "app.traktor.quant"; } }
  
  // Master Clip
  Wire { from: "%surface%.mixer.clip.left";   to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.clip.left"  } }
  Wire { from: "%surface%.mixer.clip.right";  to: DirectPropertyAdapter { path: "app.traktor.mixer.master.level.clip.right" } }
}
