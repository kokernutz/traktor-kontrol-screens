import CSI 1.0
import "../Common/Pioneer"

Mapping {
    id: mapping
    CDJ3000 { name: "surface" }

    DeckSelectionModule { name: "deck_selection"; id: deckSelection }

    MappingPropertyDescriptor { path: "mapping.settings.jogwheel_sensitivity"; type: MappingPropertyDescriptor.Float; value: 100.0; min: 0.0; max: 100.0 }

    Wire { from: DirectPropertyAdapter{ path: "mapping.settings.jogwheel_sensitivity"; input: false }
           to: "surface.jogwheel.sensitivity" }

    CDJ3000Deck { name:"deck_a"; id: deckA; deck: 1; enabled: deckSelection.selectedDeck === 1 }
    CDJ3000Deck { name:"deck_b"; id: deckB; deck: 2; enabled: deckSelection.selectedDeck === 2 }
    CDJ3000Deck { name:"deck_c"; id: deckC; deck: 3; enabled: deckSelection.selectedDeck === 3 }
    CDJ3000Deck { name:"deck_d"; id: deckD; deck: 4; enabled: deckSelection.selectedDeck === 4 }

} //Mapping
