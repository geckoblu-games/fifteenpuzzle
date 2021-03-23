import QtQuick 6.0
import QtQuick.Window 6.0
import QtQuick.Controls 6.0

import Qt.labs.settings 1.1

import 'fifteenpuzzle.js' as Model

Window {

    readonly property color backgroundColor: 'gray'

    readonly property color boardBackgroundColor: '#222520'

    readonly property color backgroundColorLight: '#dbdbd5'
    readonly property color fontColorLight: '#556'
    readonly property color borderColorLight: '#7f7f6d'
    readonly property color backgroundColorDark: '#832525'
    readonly property color fontColorDark: '#d80'
    readonly property color borderColorDark: '#471414'

    readonly property int boardSize: 4    

    id: mainWindow

    visible: false

    title: qsTr('Fifteen Puzzle')

    color: backgroundColor

    height: 558
    width: 520

    Settings {
        id: settings
        property bool firstRun: true

        property int mainWindowX: (Screen.width - width) / 2
        property int mainWindowY: (Screen.height - height) / 2
        property int mainWindowHeight: 558
        property int mainWindowWidth: 520
    }

    Item {
        id: mainScene
        visible: true
        height: parent.height
        width: board.width

        anchors.horizontalCenter: parent.horizontalCenter

        Item {
            id: toolbar
            width: parent.width
            height: shuffleButton.height + 20

            MyButton {
                id: shuffleButton
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter

                width: boardCanvas.width / boardSize

                text: qsTr('Shuffle')

                onClicked: Model.shuffle()
            }
        }

        Rectangle {
            id: board

            color: mainWindow.boardBackgroundColor
            anchors.top: toolbar.bottom
            radius: 15

            height: Math.min(mainWindow.height - toolbar.height, mainWindow.width) - 10
            width: height

            Rectangle {
                id: boardCanvas

                color: Qt.lighter(mainWindow.boardBackgroundColor, 1.4)
                anchors.centerIn: parent
                height: parent.height - 20
                width: height
                radius: 15
            }

            Rectangle {
                id: curtain

                color: 'black'
                opacity: .5

                anchors.fill: parent
                radius: parent.radius

                MouseArea {
                    anchors.fill: parent

                    hoverEnabled: true
                }

                function hide() {
                    curtain.visible = false
                    curtain.enabled = false
                }

                function show() {
                    curtain.visible = true
                    curtain.enabled = true
                }

            }
        }

    }

    VictoryDialog {
        id: victoryDialog

        anchors.fill: parent

        onClicked: {curtain.show()}
    }

    Loader {
        id: firstRunDialogLoader
    }   

    Component.onCompleted: {
        x = settings.mainWindowX;
        y = settings.mainWindowY;
        height = settings.mainWindowHeight;
        width = settings.mainWindowWidth;

        if (settings.firstRun) {
            firstRunDialogLoader.setSource('FirstRun.qml');
        }

        Model.createBoard();        

        visible = true;
    }

    Component.onDestruction: {
        settings.firstRun = false;

        settings.mainWindowX = x;
        settings.mainWindowY = y;
        settings.mainWindowHeight = height;
        settings.mainWindowWidth = width;
    }
}
