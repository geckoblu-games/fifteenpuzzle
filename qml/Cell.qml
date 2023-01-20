import QtQuick 6.0

Rectangle {

    signal clicked(int idx)

    property int value: 0
    property int idx: 0

    property bool dark: ((value % mainWindow.boardSize + Math.floor(value / mainWindow.boardSize)) % 2) <= 0
    property bool empty: value == (mainWindow.boardSize * mainWindow.boardSize -1)

    property color backgroundColor: dark ? backgroundColorDark : backgroundColorLight
    property color fontColor: dark ? fontColorDark : fontColorLight
    property color borderColor: dark ? borderColorDark : borderColorLight

    property int column: idx % mainWindow.boardSize
    property int row: idx / mainWindow.boardSize

    height: parent.height / mainWindow.boardSize
    width: parent.width / mainWindow.boardSize
    x: column * width
    y: row * height

    visible: ! empty
    enabled: ! empty

    property bool moving: false
    property bool hovered: false

    Behavior on x {
        enabled: moving
        SmoothedAnimation { duration: 250 }
    }

    Behavior on y {
        enabled: moving
        SmoothedAnimation { duration: 250 }
    }

    color: 'transparent'

    Rectangle {
        id: cell

        anchors.centerIn: parent
        height: parent.height - 3
        width: parent.width - 3

        color: hovered ? Qt.lighter(backgroundColor, dark ? 1.2 : 1.1) : backgroundColor
        border.color: hovered ? Qt.lighter(borderColor, 1.1) : borderColor
        radius: 15

        Text {
            id: label
            anchors.centerIn: parent

            font.pointSize: parent.height > 0 ? parent.height / 10 * 4 : 1

            color: hovered ? Qt.lighter(fontColor, 1.1) : fontColor

            text: value + 1
        }
    }

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true

        onEntered: {           
            hovered = true
        }
        onExited:  {            
            hovered = false
        }

        onClicked: {
            parent.clicked(parent.idx)
        }
    }

    function moveTo(newIdx) {
        moving = true
        idx = newIdx;
        moving = false
    }
}
