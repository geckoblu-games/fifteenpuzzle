import QtQuick 6.0
import QtQuick.Controls 6.0

Button {
    id: control

    font.pixelSize: 16
    // font.bold: true

    contentItem: Text {
        id: buttonText
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        //color: control.down ? '#17a81a' : '#21be2b'
        color: '#000000'
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        color: 'darkgray' //backgroundColorDark
        radius: 8
        implicitWidth:  200
        implicitHeight: 38
    }
}
