import QtQuick 2.0

QtObject {

  function convertToTimeString(inSeconds)
  {
    var neg = (inSeconds < 0);
    var roundedSec = Math.floor(inSeconds);

    if (neg)
    {
      roundedSec = -roundedSec;
    }

    var sec = roundedSec % 60;
    var min = (roundedSec - sec) / 60;
      
    var secStr = sec.toString();
    if (sec < 10) secStr = "0" + secStr;
      
    var minStr = min.toString();
//    if (min < 10) minStr = "0" + minStr;
    
    return (neg ? "-" : "") + minStr + ":" + secStr;
  }

  function computeRemainingTimeString(length, elapsed)
  {
    return ((elapsed > length) ? convertToTimeString(0) : convertToTimeString( Math.floor(elapsed) - Math.floor(length)));
  }

  function getKeyOffset(offset)
  {
    if (offset <= 0) return offset + 12;
    if (offset > 12) return offset - 12;

    return offset;
  }

  function getMasterKeyOffset(masterKey, trackKey) {
    var masterKeyMatches = masterKey.match(/(\d+)(d|m)/);
    var trackKeyMatches = trackKey.match(/(\d+)(d|m)/);

    if (!masterKeyMatches || !trackKeyMatches) return null;

    if (masterKeyMatches[1] == trackKeyMatches[1]) return 0;

    if (masterKeyMatches[2] != trackKeyMatches[2])
    {
      if (trackKeyMatches[2] == "d" && +trackKeyMatches[1] == getKeyOffset(+masterKeyMatches[1] + 3)) return 3;
      if (trackKeyMatches[2] == "m" && +trackKeyMatches[1] == getKeyOffset(+masterKeyMatches[1] - 3)) return -3;
      if (trackKeyMatches[2] == "d" && +trackKeyMatches[1] == getKeyOffset(+masterKeyMatches[1] - 1)) return 1;
      if (trackKeyMatches[2] == "m" && +trackKeyMatches[1] == getKeyOffset(+masterKeyMatches[1] + 1)) return -1;
      return null;
    }

    switch (+trackKeyMatches[1])
    {
      case getKeyOffset(+masterKeyMatches[1] + 1): return 1;
      case getKeyOffset(+masterKeyMatches[1] - 1): return -1;
      case getKeyOffset(+masterKeyMatches[1] + 2): return 2;
      case getKeyOffset(+masterKeyMatches[1] - 2): return -2;
      case getKeyOffset(+masterKeyMatches[1] + 7): return 7;
      case getKeyOffset(+masterKeyMatches[1] - 7): return -7;
    }

    return null;
  }

  function getKeyMatchText(masterKey, trackKey)
  {
      var keyOffset = getMasterKeyOffset(masterKey, trackKey);

      if (keyOffset == 0) return ">";
      else if (keyOffset > 0) return "U";
      else if (keyOffset < 0) return "D";
      else return "-";
  }

  function convertToCamelot(keyToConvert)
  {
    if (keyToConvert == "") return "-";

    switch(keyToConvert)
    {
      case "1d" : return "8B";
      case "2d" : return "9B";
      case "3d" : return "10B";
      case "4d" : return "11B";
      case "5d" : return "12B";
      case "6d" : return "1B";
      case "7d" : return "2B";
      case "8d" : return "3B";
      case "9d" : return "4B";
      case "10d" : return "5B";
      case "11d" : return "6B";
      case "12d" : return "7B";
      case "1m" : return "8A";
      case "2m" : return "9A";
      case "3m" : return "10A";
      case "4m" : return "11A";
      case "5m" : return "12A";
      case "6m" : return "1A";
      case "7m" : return "2A";
      case "8m" : return "3A";
      case "9m" : return "4A";
      case "10m" : return "5A";
      case "11m" : return "6A";
      case "12m" : return "7A";
    }
    return "ERR";
  }

  function getListItemKeyTextColor() {
    if (model.dataType != BrowserDataType.Track) {
      return textColor;
    }

    var keyOffset = utils.getMasterKeyOffset(qmlBrowser.getMasterKey(), model.key);

    switch (keyOffset) {
      case -7:
      case -2:
        return colors.colorOrange;
      case -1:
      case  0:
      case  1:
        return colors.color11MusicalKey;
      case  2:
      case  7:
        return colors.color07MusicalKey; // Green
    }

    if (keyOffset == 3 || keyOffset == -3) {
      return colors.colorRed;
    }

    return textColor;
  }

}
