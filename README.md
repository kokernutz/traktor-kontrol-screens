# Replacement screens for **Traktor Pro 3.10.x and 3.11.x** and **Kontrol D2/S5/S8 and S4 MK3**

**Contact:**

  - Twitter: [@tipesoft](http://twitter.com/tipesoft)

  - MrPatben8: https://github.com/MrPatben8

  - Twitter: [@kokernutz](http://twitter.com/kokernutz)
  - MixCloud: [@kokernutz](http://mixcloud.com/kokernutz)
  - SoundCloud: [@kokernutz](http://soundcloud.com/kokernutz)

**New features:**

  - Key text changes color. https://github.com/kokernutz/traktor-kontrol-screens/commit/aaf1dd9626a61c231b9af0702be4c31e303da0e7
  - Optimize time remaining calculation. https://github.com/jlertle/traktor-kontrol-screens/commit/c678a4550686cf2921f423858fed77bb5448e857
  - Enable prefs and camelot key for S4 MK3. https://github.com/jlertle/traktor-kontrol-screens/commit/e723b8b5fbacb80b23eef7e8ddd47a7950861c97
  - Updated the property path for track key. https://github.com/kokernutz/traktor-kontrol-screens/commit/65e7598568652f25a8285ff4d1fa54db12374ce4
  - Deck: Cycle through MixerFX on S5 by pressing SHIFT + FILTER-ON/OFF
  - Mixer FX Selector [S8 and S5]. https://github.com/kokernutz/traktor-kontrol-screens/pull/45
  - Stem Color Bars Fix. https://github.com/kokernutz/traktor-kontrol-screens/pull/42
  - Remix Deck Layout Fix & More Indicator Options. https://github.com/kokernutz/traktor-kontrol-screens/pull/23
  - Coarse BPM Adjust Setting. https://github.com/kokernutz/traktor-kontrol-screens/pull/44
  - Responsive Loop Indicator. https://github.com/kokernutz/traktor-kontrol-screens/pull/43
  - Dynamic font sizing in deck header fields. https://github.com/kokernutz/traktor-kontrol-screens/pull/22

**Fix:**

  - Fix Key text changes color on S8.
  - Fixing the phase meter. https://github.com/derzw3rg/traktor-kontrol-screens/commit/f64f6ae7822d858dc2d4f94366f3e3b3c9e2ba95

**Changes for Kontrol D2/S5/S8 and S4 MK3**

  - Preferences: Edit prefs file at qml/Screens/Defines/Prefs.qml
  - Global: Toggle between Open and Camelot key (toggle in prefs)

**Changes from D2/S5/S8 default screens:**

  - Global: User defined phrase length (set in prefs)
  - Browser: Gauges for Key/BPM match (toggle in prefs)
  - Browser: Display 7 or 9 items on screen (toggle in prefs)
  - Deck: Press SHIFT + FLUX to engage flux reverse
  - Deck: Layout more closely resembles main Traktor layout
  - Deck: All 9 data elements are configurable (set it prefs)
  - Deck: Spectrum colors (toggle in prefs)
  - Deck: Beat/phase meter (toggle in prefs)
  - Deck: Hide Album Art (toggle in prefs)
  - Deck: Hot Cue bar w/cue point names (toggle in prefs)
  - Deck: Added minute markers
  - Deck: Darkened portion of stripe already played
  - FX: Added 2 additional lines
  - FX: Text now left-justified

**Other Changes Included:**

  - Revamped deck header and added hot cue bar. https://github.com/jlertle/traktor-kontrol-screens/commit/9c0504de3b29db8b01a245536fae7abd262eca10
  - Slightly increased font size in browser and deck sub header. https://github.com/jlertle/traktor-kontrol-screens/commit/bd501f7ad3eefba4308492d4499f9064e01357b1

## How to install

**Download the mods:**

  - At the top of the github page, click the green button labeled **Clone or download**
  - Click **Download ZIP**
  - Unzip the download if your operating system does not automatically

**Mac:**

  - Quit Traktor
  - Navigate to **/Applications/Native Instruments/Traktor Pro 3**
  - Right click **Traktor**, then click **Show Package Contents**
  - Navigate to **Contents/Resources/**
  - Make a copy of the **qml** folder in case you need to restore it 
  - Copy the contents of the unzipped repo into **qml** folder, replacing the **CSI**, **Defines**, and **Screens** folders
  - Start Traktor

**Windows:**

  - Quit Traktor
  - Navigate to **C:\Program Files\Native Instruments\Traktor Pro 3\Resources64\\**
  - Make a copy of the **qml** directory in case you need to restore it
  - Create a directory named **qml**
  - Copy the contents of the unzipped repot into the **qml** directory, replacing the **CSI**, **Defines**, and **Screens** directories     
  - Start Traktor

## Screenshots

**General**
![Deck](https://user-images.githubusercontent.com/757885/47607125-e35e1000-d9e9-11e8-8005-36d73a504fa6.jpeg)
![Browser](https://user-images.githubusercontent.com/757885/47607126-e6f19700-d9e9-11e8-95cd-b26d9b72ca34.jpeg)
![FX Browser](https://user-images.githubusercontent.com/757885/33605793-1ce1edb8-d989-11e7-861a-869e0d495d5e.jpg)

**QTs dynamic font sizing**
![QTs dynamic font sizing](https://user-images.githubusercontent.com/1044267/50608377-cd2e6d80-0ecc-11e9-918a-416ccfed17d0.jpg)
![QTs dynamic font sizing](https://user-images.githubusercontent.com/1044267/50608389-d4ee1200-0ecc-11e9-90b6-a4e2b8a27bae.jpg)
![QTs dynamic font sizing](https://user-images.githubusercontent.com/1044267/50608412-e6cfb500-0ecc-11e9-9d25-a4a3d2ffd1b8.jpg)

**Display issue with Remix decks will be fixed.**
Before:
![Before: Display issue with Remix decks](https://user-images.githubusercontent.com/1044267/50618900-ffa09080-0ef5-11e9-89a0-ab1b6e412194.jpg)

After. You can see the Loop Length, and Tempo Master (Metronome) icon up top:
![After: Display issue with Remix decks](https://user-images.githubusercontent.com/1044267/50618902-03341780-0ef6-11e9-8363-bc4173275bf2.jpg)

**More Indicator Options**
  - Here is what a regular Stereo track looks like when displayDeckIndicators and displayPhaseMeter are true:
![More Indicator Options](https://user-images.githubusercontent.com/1044267/50618929-38d90080-0ef6-11e9-9076-d69a77a39301.jpg)

  - When displayDeckIndicators and displayPhaseMeter are false:
![More Indicator Options](https://user-images.githubusercontent.com/1044267/50618942-573efc00-0ef6-11e9-8724-d4686ee1d66f.jpg)

**Fixed the Stem color bars being oversized**
- Fixed the Stem color bars being oversized and therefore misaligned with the actual tracks, also fixed the gap between the waveform preview and the footer as to make it look cleaner and be more space efficient.

Before:
![Before: Fixed the Stem](https://user-images.githubusercontent.com/16992805/78146245-48e8d400-7408-11ea-9518-ecbab05333dd.jpg)

After:
![After: Fixed the Stem](https://user-images.githubusercontent.com/16992805/78146245-48e8d400-7408-11ea-9518-ecbab05333dd.jpg)
