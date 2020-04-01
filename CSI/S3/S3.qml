import CSI 1.0
import QtQuick 2.0

import "../../Defines"
import "../Common/Settings"

Mapping
{

  S3 { name: "s3" }

  S3Mixer
  {
    name: "mixer"
    shift: left.shift.value || right.shift.value
  }

  S3Side
  {
      id: left
      name: "left"
      surface: "s3.left"
      propertiesPath: "mapping.state.left"
      topDeckIdx: 1
      bottomDeckIdx: 3
  }

  S3Side
  {
      id: right
      name: "right"
      surface: "s3.right"
      propertiesPath: "mapping.state.right"
      topDeckIdx: 2
      bottomDeckIdx: 4
  }

  MappingPropertyDescriptor { path: "mapping.settings.tempo_fader_relative"; type: MappingPropertyDescriptor.Boolean; value: true; }

} // mapping

