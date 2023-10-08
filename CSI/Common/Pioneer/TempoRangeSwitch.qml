import CSI 1.0

// Map the `tempo_range` button of a xdj to switch betweed supported tempo ranges.

Module
{
  id: module

  property int deck: 1
  property bool enabled: true

  // Array of supported Temo Range Selections, must be sorted.
  property var supportedTempoRange: [TempoRangeSelection.Range6ct, TempoRangeSelection.Range10ct, TempoRangeSelection.Range16ct, TempoRangeSelection.Range100ct]

  AppProperty { id: tempoRange; path:"app.traktor.decks." + deck + ".tempo.range_select" }

  function getNextSupportedRange()
  {
      // search for the fist supported range that is bigger then the current range
      for (var i = 0; i < module.supportedTempoRange.length; i++)
      {
          if(module.supportedTempoRange[i] > tempoRange.value)
          {
              return module.supportedTempoRange[i];
          }
      }

      return supportedTempoRange[0]; // in case we don't find a higher supported range we go back to the first element
  }

  function enforceSupportedRange()
  {
      if(!supportedTempoRange.includes(tempoRange.value))
      {
          tempoRange.value = getNextSupportedRange();
      }
  }

  Wire
  {
      from: "surface.tempo_range";
      to: ButtonScriptAdapter { onPress: { tempoRange.value = getNextSupportedRange(); } }
      enabled: module.enabled
  }

}
