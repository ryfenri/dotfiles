/**
 * Pixie SDDM - Clock Component (Single Line)
 * Author: xCaptaiN09
 */
import QtQuick

Item {
    id: clock

    property string backgroundSource: ""
    property color defaultHoursColor: "#AED68A"
    property color defaultMinutesColor: "#D4E4BC"
    property string fontFamily: "FlexRounded"
    property color baseAccent: config.accentColor
    property color smartHoursColor: defaultHoursColor
    property color smartMinutesColor: defaultMinutesColor
    property string timeStr: ""

    implicitWidth: singleLineRow.implicitWidth
    implicitHeight: singleLineRow.implicitHeight
    width: implicitWidth
    height: implicitHeight

    function updateTime() {
        var date = new Date();
        var hours = date.getHours();
        var minutes = date.getMinutes();

        if (config.use24HourClock !== "true") {
            hours = hours % 12;
            if (hours === 0) hours = 12;
        }

        var hStr = hours < 10 ? "0" + hours : "" + hours;
        var mStr = minutes < 10 ? "0" + minutes : "" + minutes;

        clock.timeStr = hStr + mStr;
    }

    function updateColors() {
        var base = clock.baseAccent;

        if (base.hsvSaturation < 0.15) {
            clock.smartHoursColor = Qt.lighter(base, 1.3);
            clock.smartMinutesColor = Qt.darker(base, 1.4);
            return;
        }

        if (base.hsvValue < 0.5) {
            clock.smartHoursColor = Qt.hsva(base.hsvHue, 0.7, 0.9, 1.0);
            clock.smartMinutesColor = Qt.hsva(base.hsvHue, 0.45, 0.85, 1.0);
        } else if (base.hsvValue > 0.8 && base.hsvSaturation < 0.2) {
            clock.smartHoursColor = Qt.hsva(base.hsvHue, 0.8, 0.7, 1.0);
            clock.smartMinutesColor = Qt.hsva(base.hsvHue, 0.5, 0.75, 1.0);
        } else {
            clock.smartHoursColor = Qt.hsva(base.hsvHue, Math.min(1.0, base.hsvSaturation * 1.3), 0.95, 1.0);
            clock.smartMinutesColor = Qt.hsva(base.hsvHue, Math.min(1.0, base.hsvSaturation * 0.75), 0.92, 1.0);
        }
    }

    onBaseAccentChanged: updateColors()
    Component.onCompleted: {
        updateColors();
        updateTime();
    }

    Row {
        id: singleLineRow
        anchors.centerIn: parent
        spacing: 2

        Text {
            text: clock.timeStr.slice(0, 2)
            color: clock.smartHoursColor
            font.pixelSize: 120
            font.family: clock.fontFamily
            font.weight: Font.Medium
            antialiasing: true
        }

        Text {
            text: ":"
            color: clock.smartHoursColor
            opacity: 0.75
            font.pixelSize: 110
            font.family: clock.fontFamily
            font.weight: Font.Medium
            antialiasing: true
        }

        Text {
            text: clock.timeStr.slice(2, 4)
            color: clock.smartMinutesColor
            font.pixelSize: 120
            font.family: clock.fontFamily
            font.weight: Font.Medium
            antialiasing: true
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: updateTime()
    }
}
