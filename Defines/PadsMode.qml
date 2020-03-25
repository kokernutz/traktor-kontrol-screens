pragma Singleton

import QtQuick 2.0
import CSI 1.0

QtObject
{
  readonly property int disabled:    0
  readonly property int hotcues:     1
  readonly property int remix:       2
  readonly property int stems:       3
  readonly property int freeze:      4
  readonly property int loop:        5

  function isPadsModeSupported(padMode, deckType)
  {
    switch(padMode)
    {
      case disabled:
        return deckType == DeckType.Live
      case hotcues:
        return deckType == DeckType.Stem || deckType == DeckType.Track;
      case remix:
        return deckType == DeckType.Remix;
      case stems:
        return deckType == DeckType.Stem;
      case freeze:
      case loop:
        return deckType != DeckType.Live;
    }
  }

  function defaultPadsModeForDeck(deckType)
  {
    switch(deckType)
    {
      case DeckType.Stem:
        return stems;
      case DeckType.Remix:
        return remix;
      case DeckType.Track:
        return hotcues;
      case DeckType.Live:
      default:
        return disabled;
    }
  }
}

  
