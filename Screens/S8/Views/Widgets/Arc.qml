import QtQuick 2.0

Canvas {
  property real lineWidth:     1.0
  property real startAngle:    0.0
  property real endAngle:      45.0
  property bool anticlockwise: false
  property variant strokeStyle: '#00FF00'
  property variant fillStyle: 'transparent'


  
  onPaint: {
    var ctx = getContext("2d");
    ctx.reset();

    var centerX = width / 2;
    var centerY = height / 2;
    var arcRadius = width / 2 - lineWidth;

    ctx.beginPath();
    ctx.fillStyle = fillStyle;
    ctx.arc(centerX, centerY, arcRadius, Math.PI * startAngle/180, Math.PI * endAngle/180, anticlockwise);
    ctx.lineWidth = lineWidth;
    ctx.strokeStyle = strokeStyle;
    ctx.stroke();
  }
}
