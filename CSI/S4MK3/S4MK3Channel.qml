import CSI 1.0
import "../Common/DeckHelpers.js" as Helpers

Module
{
  id: module
  property bool shift: false
  property int index: 1

  // helpers
  readonly property string surface_prefix: "s4mk3.mixer.channels." + module.index + "." 
  readonly property string app_prefix: "app.traktor.mixer.channels." + module.index + "."

  AppProperty { id: deckType; path: "app.traktor.decks." + module.index + ".type"; }
  // input select
  Wire 
  { 
    from: surface_prefix + "input";  
    to: ButtonScriptAdapter 
    { 
      onPress: 
      {
        if(!module.shift)
        {
          deckType.value = (deckType.value == DeckType.Live) ? 
            Helpers.defaultTypeForDeck(module.index) : DeckType.Live;
        }
      }
      brightness: (deckType.value == DeckType.Live) ? 1.0 : 0.0
    } 
  }

  LEDLevelMeter { name: "meter"; segments: 15 } 
  Wire { from: surface_prefix + "level_meter"; to: "meter" }
  Wire { from: "meter.level"; to: DirectPropertyAdapter { path: app_prefix + "level.prefader.linear.meter"; input: false } }
  
  // channel strip
  Wire { from: surface_prefix + "volume";               to: DirectPropertyAdapter { path: app_prefix + "volume"         } }
  Wire { from: surface_prefix + "gain";                 to: DirectPropertyAdapter { path: app_prefix + "gain"           } }
  Wire { from: surface_prefix + "eq.high";              to: DirectPropertyAdapter { path: app_prefix + "eq.high"        } }
  Wire { from: surface_prefix + "eq.mid";               to: DirectPropertyAdapter { path: app_prefix + "eq.mid"         } }
  Wire { from: surface_prefix + "eq.low";               to: DirectPropertyAdapter { path: app_prefix + "eq.low"         } }
  Wire { from: surface_prefix + "cue";                  to: TogglePropertyAdapter { path: app_prefix + "cue"            } }
  Wire { from: surface_prefix + "deck_fx_assign.1";     to: TogglePropertyAdapter { path: app_prefix + "fx.assign.1"    } }
  Wire { from: surface_prefix + "deck_fx_assign.2";     to: TogglePropertyAdapter { path: app_prefix + "fx.assign.2"    } }

  // xfader assign
  Wire { from: surface_prefix + "xfader_assign.left";  to: DirectPropertyAdapter { path: app_prefix + "xfader_assign.left"   } }
  Wire { from: surface_prefix + "xfader_assign.right"; to: DirectPropertyAdapter { path: app_prefix + "xfader_assign.right"  } }
}
