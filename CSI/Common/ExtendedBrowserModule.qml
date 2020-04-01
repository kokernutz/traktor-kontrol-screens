import CSI 1.0
import "../../Defines"
import "DeckHelpers.js" as Helpers

// Module for browser components containing "Preview", "Favorite", "Preparation", and "View",
// along with an encoder for browsing.

Module
{
  id: module
  property string surface: ""
  property int deckIdx: 1
  property bool active: false

  // Encoder Modes ----------------------
  readonly property int listMode:           0
  readonly property int favoritesMode:      1
  readonly property int previewPlayerMode:  2
  readonly property int treeMode:           3
  // ------------------------------------
  property int encoderMode: module.listMode
  // ------------------------------------

  // LED Brightness ----------------------
  readonly property real onBrightness:     1.0
  readonly property real dimmedBrightness: 0.0

  readonly property var deckColor: Helpers.colorForDeck(module.deckIdx)

  Browser {
    name: "browser"
    fullScreenColor: module.deckColor
    prepListColor: module.deckColor
  }

  AppProperty { id: loadPreviewProp;    path: "app.traktor.browser.preview_player.load" }
  AppProperty { id: unloadPreviewProp;  path: "app.traktor.browser.preview_player.unload" }

  WiresGroup {

    enabled: module.active


    Wire { from: "%surface%.browse.view";         to: "browser.full_screen" }
    Wire { from: "%surface%.browse.add_to_list";  to: "browser.add_remove_from_prep_list" }

    // enable favortie browsing
    Wire
    {
      from: "%surface%.browse.favorite";
      to: ButtonScriptAdapter
      {
        onPress:
        {
          module.encoderMode = module.favoritesMode;
          brightness = onBrightness;
        }
        onRelease:
        {
          module.encoderMode = module.listMode;
          brightness = dimmedBrightness;
        }
        brightness: dimmedBrightness
        color: module.deckColor
      }
    }

    // Load/unload current track to preview play and enable encoder seek
    Wire
    {
      from: "%surface%.browse.preview";
      to: ButtonScriptAdapter
      {
        onPress:
        {
          loadPreviewProp.value = true;
          module.encoderMode = module.previewPlayerMode;
          brightness = onBrightness;

        }
        onRelease:
        {
          unloadPreviewProp.value = true;
          module.encoderMode = module.listMode;
          brightness = dimmedBrightness;
        }
        brightness: dimmedBrightness
        color: module.deckColor
      }
    }

    // Shift
    Wire
    {
      from: "%surface%.shift";
      to: ButtonScriptAdapter
      {
        onPress:
        {
          module.encoderMode = module.treeMode;
        }
        onRelease:
        {
          module.encoderMode = module.listMode;
        }
      }
    }

    // list mode
    WiresGroup {
      enabled: module.encoderMode == module.listMode;
      Wire { from: "%surface%.browse.encoder"; to: "browser.list_navigation" }
      Wire { from: "%surface%.browse.encoder.push"; to: TriggerPropertyAdapter { path: "app.traktor.decks." + deckIdx + ".load.selected" } }
    }

    // favourites mode
    Wire
    {
      enabled: module.encoderMode == module.favoritesMode;
      from: "%surface%.browse.encoder";
      to: "browser.favorites_navigation"
    }

    // tree mode
    Wire
    {
      enabled: module.encoderMode == module.treeMode;
      from: "%surface%.browse.encoder";
      to: "browser.tree_navigation"
    }

    // preview mode
    Wire
    {
      enabled: module.encoderMode == module.previewPlayerMode
      from: "%surface%.browse.encoder";
      to: RelativePropertyAdapter { path: "app.traktor.browser.preview_player.seek"; step: 0.01; mode: RelativeMode.Stepped }
    }
  }
}
