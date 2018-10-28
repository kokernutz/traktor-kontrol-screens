import QtQuick 2.5

Item {
    property real value: 0.0
    property color valueColor: "white"
    property color backgroundColor: "#3e3e3e"
    property int lineWidth: 5
    property real radius: Math.min(width, height) / 2.0 - lineWidth / 2.0
    property real base: 0.0

    readonly property real startPhi: Math.PI * 0.75
    readonly property real basePhi: Math.PI * (0.75 + base * 1.5)
    readonly property real endPhi: Math.PI * 0.25
    readonly property real valuePhi: Math.PI * (0.75 + value * 1.5)
    readonly property real centerX: width / 2.0;
    readonly property real centerY: height / 1.75;

    onValueChanged: {
        canvas.requestPaint()
    }

    Canvas {
        id: canvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");

            ctx.reset();
            ctx.lineWidth = lineWidth
            ctx.strokeStyle = backgroundColor

            if (base > 0.0 && value > 0.0) {
                ctx.beginPath();
                ctx.moveTo(centerX, centerY);
                ctx.arc(centerX, centerY, radius, valuePhi, startPhi, true);
                ctx.stroke()
            }

            if (base < 1.0 && value < 1.0) {
                ctx.beginPath();
                ctx.moveTo(centerX, centerY);
                ctx.arc(centerX, centerY, radius, valuePhi, endPhi, false);
                ctx.stroke()
            }

            if (value != base) {
                ctx.strokeStyle = valueColor
                ctx.beginPath();
                ctx.moveTo(centerX, centerY);
                ctx.arc(centerX, centerY, radius, valuePhi, basePhi, base < value);
                ctx.stroke()
            }
        }
    }
}
