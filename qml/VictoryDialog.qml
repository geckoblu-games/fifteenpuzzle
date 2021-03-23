import QtQuick 6.0

Item {
    id: container

    visible: false
    enabled: false

    signal clicked()

    Rectangle {
        color: 'black'
        opacity: .5

        anchors.fill: parent

    }

    Rectangle {
        width: dialogText.width + 20
        height: dialogText.height + 20
        opacity: 1
        color: mainWindow.backgroundColorDark
        border.color: mainWindow.fontColorDark
        //border.width: 3
        radius: 15

        anchors.centerIn: parent

        Text {
            id: dialogText

            anchors.centerIn: parent
            //horizontalAlignment: Text.AlignHCenter
            //verticalAlignment: Text.AlignVCenter

            text: '<h1>' + qsTr('Puzzle solved!') + '</h1>'
            color: mainWindow.fontColorDark
        }
    }

    MouseArea {
        anchors.fill: parent

        hoverEnabled: true

        onClicked: {
            hide();
            parent.clicked()
        }
    }

    function show() {
        container.visible = true;
        container.enabled = true;
    }

    function hide() {
        container.visible = false;
        container.enabled = false;
    }
}
