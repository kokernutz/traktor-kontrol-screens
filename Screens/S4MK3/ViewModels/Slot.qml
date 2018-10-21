import QtQuick 2.5
import CSI 1.0

Item
{
  id: slot

  property int deckId: 0
  property int slotId: 0
  
  readonly property bool muted:         propMuted.value
  readonly property real volume:        propVolume.value
  readonly property bool filterOn:      propFilterOn.value
  readonly property real filterValue:   propFilterValue.value
  readonly property int  activeCellIdx: propSelectedCellIdx.value + 1
  
  //fetch traktor properties
  AppProperty { id: propMuted;            path: slotPath() + ".muted" }
  AppProperty { id: propVolume;           path: slotPath() + ".volume" }
  AppProperty { id: propFilterOn;         path: slotPath() + ".filter_on" }
  AppProperty { id: propFilterValue;      path: slotPath() + ".filter_value" }
  AppProperty { id: propSelectedCellIdx;  path: slotPath() + ".sequencer.selected_cell" } 

  Cell        { id: cell1;  deckId: slot.deckId; slotId: slot.slotId; cellId: 1  }
  Cell        { id: cell2;  deckId: slot.deckId; slotId: slot.slotId; cellId: 2  }
  Cell        { id: cell3;  deckId: slot.deckId; slotId: slot.slotId; cellId: 3  }
  Cell        { id: cell4;  deckId: slot.deckId; slotId: slot.slotId; cellId: 4  }
  Cell        { id: cell5;  deckId: slot.deckId; slotId: slot.slotId; cellId: 5  }
  Cell        { id: cell6;  deckId: slot.deckId; slotId: slot.slotId; cellId: 6  }
  Cell        { id: cell7;  deckId: slot.deckId; slotId: slot.slotId; cellId: 7  }
  Cell        { id: cell8;  deckId: slot.deckId; slotId: slot.slotId; cellId: 8  }
  Cell        { id: cell9;  deckId: slot.deckId; slotId: slot.slotId; cellId: 9  }
  Cell        { id: cell10; deckId: slot.deckId; slotId: slot.slotId; cellId: 10 }
  Cell        { id: cell11; deckId: slot.deckId; slotId: slot.slotId; cellId: 11 }
  Cell        { id: cell12; deckId: slot.deckId; slotId: slot.slotId; cellId: 12 }
  Cell        { id: cell13; deckId: slot.deckId; slotId: slot.slotId; cellId: 13 }
  Cell        { id: cell14; deckId: slot.deckId; slotId: slot.slotId; cellId: 14 }
  Cell        { id: cell15; deckId: slot.deckId; slotId: slot.slotId; cellId: 15 }
  Cell        { id: cell16; deckId: slot.deckId; slotId: slot.slotId; cellId: 16 }

  property var cells: [cell1, cell2, cell3, cell4, cell5, cell6, cell7, cell8, cell9, cell10, cell11, cell12, cell13, cell14, cell15, cell16];
  
  function isCellIdValid( cellId ) { return cellId > 0 && cellId < 17; }
  function getCell( cellId ) { return slot.cells[cellId-1]; }
  function getActiveCell() { return slot.getCell( slot.activeCellIdx ); }

  function slotPath() { return "app.traktor.decks." + slot.deckId + ".remix.players." + slot.slotId; }
}