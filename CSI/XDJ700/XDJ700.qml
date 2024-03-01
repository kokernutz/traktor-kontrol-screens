import CSI 1.0
import "../Common/Pioneer"

Mapping
{
    id: mapping
    XDJ700 { name: "surface" }

    DeckSelectionModule { name: "deck_selection"; id: deckSelection }

    XDJ700Deck { name:"deck_a"; id: deckA; deck: 1; enabled: deckSelection.selectedDeck === 1 }
    XDJ700Deck { name:"deck_b"; id: deckB; deck: 2; enabled: deckSelection.selectedDeck === 2 }
    XDJ700Deck { name:"deck_c"; id: deckC; deck: 3; enabled: deckSelection.selectedDeck === 3 }
    XDJ700Deck { name:"deck_d"; id: deckD; deck: 4; enabled: deckSelection.selectedDeck === 4 }

} //Mapping
