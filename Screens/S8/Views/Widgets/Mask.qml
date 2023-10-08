import QtQuick 2.0
import Qt5Compat.GraphicalEffects

ShaderEffect {
  id: mask
  anchors.fill: parent
  visible:      false

  property variant source: entireScreenOverlay
  property variant src:    overlaySource

  ShaderEffectSource { id: overlaySource;  sourceItem: mask.source }

  vertexShader:
    "
    uniform highp    mat4  qt_Matrix;
    attribute highp  vec4  qt_Vertex;
    attribute highp  vec2  qt_MultiTexCoord0;
    varying highp    vec2  coord;

    void main()
    {
      coord  =  qt_MultiTexCoord0;
      gl_Position  =  qt_Matrix * qt_Vertex;
    }
    "

  fragmentShader:
    "
    varying highp   vec2        coord;
    uniform         sampler2D   src;

    void main()
    {
      lowp vec4 tex  =  texture2D(src, coord);
      gl_FragColor = vec4(0,0,0, tex.a > 0. ? 1. : 0. );
    }
    "
}