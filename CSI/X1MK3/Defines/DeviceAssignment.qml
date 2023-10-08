pragma Singleton

import QtQuick 2.0

QtObject {
  // Constants to describe deck pair assignments
  readonly property int decks_a_b: 0
  readonly property int decks_c_d: 1
  readonly property int decks_c_a: 2
  readonly property int decks_b_d: 3
  readonly property int decks_a_c: 4

  // Constants to describe fx units pair assignments
  readonly property int fx_1_2: 0
  readonly property int fx_3_4: 1
  readonly property int fx_3_1: 2
  readonly property int fx_2_4: 3
  readonly property int fx_1_3: 4

  function leftDeckIdx(assignment)
  {
    switch (assignment)
    {
      case decks_a_b:
        return 1; // A

      case decks_c_d:
        return 3; // C

      case decks_c_a:
        return 3; // C

      case decks_b_d:
        return 2; // B

      case decks_a_c:
        return 1; // A
    }
  }

  function rightDeckIdx(assignment)
  {
    switch (assignment)
    {
      case decks_a_b:
        return 2; // B

      case decks_c_d:
        return 4; // D

      case decks_c_a:
        return 1; // A

      case decks_b_d:
        return 4; // D

      case decks_a_c:
        return 3; // C
    }
  }

  function leftPrimaryFxIdx(assignment)
  {
    switch (assignment)
    {
      case fx_1_2:
        return 1;

      case fx_3_4:
        return 3;

      case fx_3_1:
        return 3;

      case fx_2_4:
        return 2;

      case fx_1_3:
        return 1;
    }
  }

  function rightPrimaryFxIdx(assignment)
  {
    switch (assignment)
    {
      case fx_1_2:
        return 2;

      case fx_3_4:
        return 4;

      case fx_3_1:
        return 1;

      case fx_2_4:
        return 4;

      case fx_1_3:
        return 3;
    }
  }

  function leftSecondaryFxIdx(assignment)
  {
    switch (assignment)
    {
      case fx_1_2:
        return 3;

      case fx_3_4:
        return 1;

      case fx_3_1:
        return 2;

      case fx_2_4:
        return 3;

      case fx_1_3:
        return 2;
    }
  }

  function rightSecondaryFxIdx(assignment)
  {
    switch (assignment)
    {
      case fx_1_2:
        return 4;

      case fx_3_4:
        return 2;

      case fx_3_1:
        return 4;

      case fx_2_4:
        return 1;

      case fx_1_3:
        return 4;
    }
  }
} 
