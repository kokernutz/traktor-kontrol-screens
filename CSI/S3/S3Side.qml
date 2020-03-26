import CSI 1.0
import "../../Defines"
import "../Common/DeckHelpers.js" as Helpers

Module
{
    id: module
    property string surface: ""
    property string propertiesPath: ""
    property int topDeckIdx: 0
    property int bottomDeckIdx: 0
    property alias shift: shiftProp
    property int focusedDeckIdx: topDeckFocus.value ? topDeckIdx : bottomDeckIdx

    //--------------------------HelperFunctions-----------------------------

    function updatePads()
    {
      if(PadsMode.isPadsModeSupported(focusedDeck().padsMode, focusedDeck().deckType))
      {
        focusedDeck().enablePads = true;
        nonFocusedDeck().enablePads = false;
      }
      else if(focusedDeck().padsMode == PadsMode.remix && nonFocusedDeck().deckType === DeckType.Remix)
      {
        focusedDeck().enablePads = false;
        nonFocusedDeck().enablePads = true
        nonFocusedDeck().padsMode = PadsMode.remix;
      }
      else
      {
        focusedDeck().padsMode = PadsMode.defaultPadsModeForDeck(focusedDeck().deckType);
      }

      // Keep pads state in sync with focused deck, will only trigger callbacks if value has changed
      globalPadsMode.value = focusedDeck().padsMode;
    }

    function nonFocusedDeck()
    {
      return topDeckFocus.value ? bottomDeck : topDeck;
    }

    function focusedDeck()
    {
      return topDeckFocus.value ? topDeck : bottomDeck;
    }

    //--------------------------MAPPING-----------------------------

    // Deck focus //

    MappingPropertyDescriptor
    {
      id: topDeckFocus;
      path: propertiesPath + ".top_deck_focus";
      type: MappingPropertyDescriptor.Boolean;
      value: true;
      onValueChanged:
      {
        updatePads();
      }
    }

    Wire
    {
      from: "%surface%.top_deck";
      to: SetPropertyAdapter  { path: propertiesPath + ".top_deck_focus"; value: true; color: Helpers.colorForDeck(module.topDeckIdx) }
    }

    Wire
    {
      from: "%surface%.bottom_deck";
      to: SetPropertyAdapter  { path: propertiesPath + ".top_deck_focus"; value: false; color: Helpers.colorForDeck(module.bottomDeckIdx) }
    }

    //  // Performace pads mode  //

    MappingPropertyDescriptor
    {
        id: globalPadsMode;
        path: propertiesPath + ".pads_mode";
        type: MappingPropertyDescriptor.Integer;
        value: PadsMode.disabled;
        onValueChanged:
        {
          focusedDeck().padsMode = globalPadsMode.value;
        }
    }

    Wire
    {
        enabled: PadsMode.isPadsModeSupported(PadsMode.hotcues, focusedDeck().deckType);
        from: "%surface%.hotcues";
        to: SetPropertyAdapter  { path: propertiesPath + ".pads_mode"; value: PadsMode.hotcues; color: Helpers.colorForDeck(focusedDeckIdx) }
    }

    Wire
    {
        enabled: PadsMode.isPadsModeSupported(PadsMode.remix, bottomDeck.deckType) || PadsMode.isPadsModeSupported(PadsMode.remix, topDeck.deckType);
        from: "%surface%.samples";
        to: SetPropertyAdapter  { path: propertiesPath + ".pads_mode"; value: PadsMode.remix; color: Helpers.colorForDeck(focusedDeckIdx) }
    }

    // Shift //
    MappingPropertyDescriptor { id: shiftProp; path: propertiesPath + ".shift"; type: MappingPropertyDescriptor.Boolean; value: false }
    Wire { from: "%surface%.shift";  to: DirectPropertyAdapter { path: propertiesPath + ".shift"  } }

    S3Deck
    {
      id: topDeck
      name: "topDeck"
      surface: module.surface
      deckPropertiesPath: propertiesPath + "." + topDeckIdx
      shift: shiftProp.value
      deckIdx: topDeckIdx
      active: topDeckFocus.value
      onDeckTypeChanged:
      {
        updatePads();
      }
      onPadsModeChanged:
      {
        updatePads();
      }
    }

    S3Deck
    {
      id: bottomDeck
      name: "bottomDeck"
      surface: module.surface
      deckPropertiesPath: propertiesPath + "." + bottomDeckIdx
      shift: shiftProp.value
      deckIdx: bottomDeckIdx
      active: !topDeckFocus.value
      onDeckTypeChanged:
      {
        updatePads();
      }
      onPadsModeChanged:
      {
        updatePads();
      }
    }
}

