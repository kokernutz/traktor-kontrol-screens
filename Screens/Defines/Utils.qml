import QtQuick

QtObject {

  function convertToTimeString(inSeconds)
  {
    return Math.floor(inSeconds / 60).toString() + ":" + ("0" + Math.abs(Math.floor(inSeconds % 60)).toString()).slice(-2);
  }

  function computeRemainingTimeString(length, elapsed)
  {
    return elapsed > length ? convertToTimeString(0) : convertToTimeString( Math.floor(length) - Math.floor(elapsed));
  }

  function getKeyOffset(offset)
  {
    return (((offset - 1) + 12) % 12) + 1;
  }

  function getMasterKeyOffset(masterKey, trackKey) {
    var masterKeyMatches = masterKey.match(/(\d+)(d|m)/);
    var trackKeyMatches = trackKey.match(/(\d+)(d|m)/);

    if (!masterKeyMatches || !trackKeyMatches) return;

    if (masterKeyMatches[1] == trackKeyMatches[1]) return 0;

    if (masterKeyMatches[2] == trackKeyMatches[2]) {
      if (getKeyOffset(trackKeyMatches[1] - 1) == masterKeyMatches[1]) return  1;
      if (getKeyOffset(trackKeyMatches[1] - 2) == masterKeyMatches[1]) return  2;
      if (getKeyOffset(masterKeyMatches[1] - 1) == trackKeyMatches[1]) return -1;
      if (getKeyOffset(masterKeyMatches[1] - 2) == trackKeyMatches[1]) return -2;
    }
  }

  function convertToCamelot(keyToConvert)
  {
    if (keyToConvert == "") return "-";

    switch(keyToConvert)
    {
      case "1d"  : return "8B";
      case "2d"  : return "9B";
      case "3d"  : return "10B";
      case "4d"  : return "11B";
      case "5d"  : return "12B";
      case "6d"  : return "1B";
      case "7d"  : return "2B";
      case "8d"  : return "3B";
      case "9d"  : return "4B";
      case "10d" : return "5B";
      case "11d" : return "6B";
      case "12d" : return "7B";

      case "1m"  : return "8A";
      case "2m"  : return "9A";
      case "3m"  : return "10A";
      case "4m"  : return "11A";
      case "5m"  : return "12A";
      case "6m"  : return "1A";
      case "7m"  : return "2A";
      case "8m"  : return "3A";
      case "9m"  : return "4A";
      case "10m" : return "5A";
      case "11m" : return "6A";
      case "12m" : return "7A";
    }
    return "ERR";
  }

  function convertToOpenKey(keyToConvert)
  {
    if (keyToConvert == "") return "-";

    switch(keyToConvert.toLowerCase().trim())
    {
      case "8B"  : return "1d";
      case "9B"  : return "2d";
      case "10B" : return "3d";
      case "11B" : return "4d";
      case "12B" : return "5d";
      case "1B"  : return "6d";
      case "2B"  : return "7d";
      case "3B"  : return "8d";
      case "4B"  : return "9d";
      case "5B"  : return "10d";
      case "6B"  : return "11d";
      case "7B"  : return "12d";

      case "8A"  : return "1m";
      case "9A"  : return "2m";
      case "10A" : return "3m";
      case "11A" : return "4m";
      case "12A" : return "5m";
      case "1A"  : return "6m";
      case "2A"  : return "7m";
      case "3A"  : return "8m";
      case "4A"  : return "9m";
      case "5A"  : return "10m";
      case "6A"  : return "11m";
      case "7A"  : return "12m";
    }
    return "ERR";
  }

  function returnKeyIndex(keyToConvert)
  {
    switch(keyToConvert)
    {
      case "1d"  : return 0;
      case "8d"  : return 1;
      case "3d"  : return 2;
      case "10d" : return 3;
      case "5d"  : return 4;
      case "12d" : return 5;
      case "7d"  : return 6;
      case "2d"  : return 7;
      case "9d"  : return 8;
      case "4d"  : return 9;
      case "11d" : return 10;
      case "6d"  : return 11;

      case "10m" : return 12;
      case "5m"  : return 13;
      case "12m" : return 14;
      case "7m"  : return 15;
      case "2m"  : return 16;
      case "9m"  : return 17;
      case "4m"  : return 18;
      case "11m" : return 19;
      case "6m"  : return 20;
      case "1m"  : return 21;
      case "8m"  : return 22;
      case "3m"  : return 23;
    }
    return null;
  }
}
