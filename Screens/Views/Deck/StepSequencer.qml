import QtQuick 2.0
import CSI 1.0
import './../Widgets' as Widgets
import './../Definitions' as Definitions

//----------------------------------------------------------------------------------------------------------------------
//                                               STEP SEQUENCER
//----------------------------------------------------------------------------------------------------------------------

Item
{
  id: step_sequencer
  property var playerPropertyPath:    ""
  property var activeSamplePath:      ""
  property var remixDeckPropertyPath: ""

  property int numberOfEditableSteps: 8
  property bool selected: false

  AppProperty     { id: current_step;   path: playerPropertyPath + ".sequencer.current_step"              }
  AppProperty     { id: pattern_length; path: playerPropertyPath + ".sequencer.pattern_length"            }
  AppProperty     { id: color_id;       path: activeSamplePath   + ".color_id"                            }
  MappingProperty { id: sequencer_page; path: propertiesPath     + deck_position + ".sequencer_deck_page" }

  Grid
  {
    anchors.left: parent.left
    anchors.leftMargin: 6
    anchors.top: parent.top
    anchors.topMargin: 1
    columns: 4
    spacing: 4
    Repeater
    {
      model: pattern_length.value
      Rectangle
      {
        AppProperty   { id: step; path: playerPropertyPath    + ".sequencer.steps." + (index + 1) }

        radius: 2
        width:  22
        height: 22
        color:  ( current_step.value === index  ) ? colors.colorWhite85 : calculate_base_color()

        function calculate_base_color()
        {
          if ( current_step.value === index  ) return "white"

          if ( step_sequencer.selected ) // the current column is selected for editing
          {
            if ( ( index >= (sequencer_page.value - 1)*numberOfEditableSteps && index < sequencer_page.value*numberOfEditableSteps ) )
            {
              return step.value ? colors.palette(1.0, color_id.value) : colors.colorWhite19
            }
            else
            {
              return step.value ? colors.palette(0.5, color_id.value) : colors.colorGrey24
            }
          }
          return step.value ? colors.palette(1.0, color_id.value) : colors.colorWhite19
        }
      }
    }
  }
}
