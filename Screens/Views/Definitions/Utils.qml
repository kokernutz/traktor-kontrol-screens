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
}
