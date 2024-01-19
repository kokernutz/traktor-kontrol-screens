import CSI 1.0
import QtQuick 2.5

import "Defines"

Module
{
  id: module
  property string surface: ""
  property string propertiesPath: ""
  property alias state: deviceSetupStateProp.value

  readonly property int leftDeckIdx: DeviceAssignment.leftDeckIdx(deckAssignmentProp.value)
  readonly property int rightDeckIdx: DeviceAssignment.rightDeckIdx(deckAssignmentProp.value)

  readonly property int leftPrimaryFxIdx: DeviceAssignment.leftPrimaryFxIdx(fxAssignmentProp.value)
  readonly property int rightPrimaryFxIdx: DeviceAssignment.rightPrimaryFxIdx(fxAssignmentProp.value)

  readonly property int leftSecondaryFxIdx: DeviceAssignment.leftSecondaryFxIdx(fxAssignmentProp.value)
  readonly property int rightSecondaryFxIdx: DeviceAssignment.rightSecondaryFxIdx(fxAssignmentProp.value)

  function reset()
  {
    deviceSetupStateProp.value = DeviceSetupState.unassigned;
  }

  MappingPropertyDescriptor {
    id: deckAssignmentProp
    type: MappingPropertyDescriptor.Integer
    path: mapping.propertiesPath + ".deck_assignment"

    value: DeviceAssignment.decks_a_b
    min: DeviceAssignment.decks_a_b
    max: DeviceAssignment.decks_a_c
  }

  MappingPropertyDescriptor {
    id: fxAssignmentProp
    type: MappingPropertyDescriptor.Integer
    path: mapping.propertiesPath + ".fx_assignment"

    value: DeviceAssignment.fx_1_2
    min: DeviceAssignment.fx_1_2
    max: DeviceAssignment.fx_1_3
  }

  MappingPropertyDescriptor {
    id: deviceSetupStateProp
    type: MappingPropertyDescriptor.Integer
    path: module.propertiesPath + ".device_setup_state"

    value: DeviceSetupState.unassigned
    min: DeviceSetupState.unassigned
    max: DeviceSetupState.assigned
  }

  RelativePropertyAdapter { name: "deck_selector"; path: deckAssignmentProp.path; mode: RelativeMode.Stepped; wrap: true }
  RelativePropertyAdapter { name: "fx_selection_prev"; path: fxAssignmentProp.path; mode: RelativeMode.Decrement; wrap: true }
  RelativePropertyAdapter { name: "fx_selection_next"; path: fxAssignmentProp.path; mode: RelativeMode.Increment; wrap: true }

  Timer {
    id: deviceSetupCompleted;
    interval: 1000;
    onTriggered:
    {
      // Device has finally been assigned!
      deviceSetupStateProp.value = DeviceSetupState.assigned;
    }
  }

  ButtonScriptAdapter {
    name: "complete_device_setup";
    onPress: {
      // Decks have been assigned, temporarily go into just_assigned state
      deviceSetupStateProp.value = DeviceSetupState.just_assigned;
      deviceSetupCompleted.restart();
    }
  }

  WiresGroup
  {
    enabled: module.state == DeviceSetupState.unassigned

    Wire { from: "%surface%.left.loop"; to: "deck_selector" }
    Wire { from: "%surface%.left.loop.push"; to: "complete_device_setup" }

    Wire { from: "%surface%.left.browse"; to: "deck_selector" }
    Wire { from: "%surface%.left.browse.push"; to: "complete_device_setup" }

    Wire { from: "%surface%.right.loop"; to: "deck_selector" }
    Wire { from: "%surface%.right.loop.push"; to: "complete_device_setup" }

    Wire { from: "%surface%.right.browse"; to: "deck_selector" }
    Wire { from: "%surface%.right.browse.push"; to: "complete_device_setup" }

    Wire { from: "%surface%.left.assign.left";   to: "fx_selection_prev" }
    Wire { from: "%surface%.left.assign.right";  to: "fx_selection_next" }
    Wire { from: "%surface%.right.assign.left";  to: "fx_selection_prev" }
    Wire { from: "%surface%.right.assign.right"; to: "fx_selection_next" }
  }
}
