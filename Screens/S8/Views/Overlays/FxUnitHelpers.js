
// Label for the first parameter is not dynamically set by the FxUnits
// So we need to set it manually
function fxUnitFirstParameterLabel(fxUnitMode, fxSelect1)
{
  if (fxUnitMode.value == FxType.Group)
  {
    return "DRY/WET";
  }
  else if (fxUnitMode.value == FxType.Single)
  {
    return fxSelect1.description;
  }
  else if (fxUnitMode.value == FxType.PatternPlayer)
  {
    return "VOL";
  }
  else
  {
    return "";
  }
}
