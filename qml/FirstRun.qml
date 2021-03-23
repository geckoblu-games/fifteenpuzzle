import QtQuick 6.0
import QtQuick.Controls 6.0

Rectangle {
    id: firstLoadDialog

    visible: false

    width: mainWindow.width
    height: mainWindow.height

    color: Qt.rgba(0, 0, 0, 0.7)

    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        color: palette.window

        width: mainScene.width / 5 * 3
        height: mainScene.height / 5 * 3.5

        radius: 5
        anchors.centerIn: parent

        Column {
            anchors.centerIn: parent            

            Image {
                source: 'qrc:/icon.png'
                width: btn1.width
                height: width

                anchors.horizontalCenter: parent.horizontalCenter

                visible: true;                
            }

            Text {
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter

                text: qsTr('<h1>' + qsTr('Fifteen Puzzle') + '</h1>' + qsTr('v') +' ' + '0.1')

            }

            Text {
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 10

                text:qsTr(
'<br/>by<br/>
<a href="https://www.geckoblu.net">geckoblu</a><br/>
<br/>' +
qsTr('Released under') +  ' <a href="http://www.gnu.org/licenses/gpl-3.0.en.html">GPL v3.0</a> ' + qsTr('or later.') + '<br/>
<br/>' +
qsTr('More info and credits at:') + '<br/>
<a href="https://github.com/geckoblu-games/fifteenpuzzle-qml">fifteenpuzzle-qml</a><br>
<br/>
')

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton // we don't want to eat clicks on the Text
                    cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                }

                onLinkActivated: Qt.openUrlExternally(link)

            }

            Button {
                id: btn1
                text: 'Ok'

                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: {
                    firstLoadDialog.visible = false;
                    firstLoadDialog.z = -1;
                    mainScene.forceActiveFocus();
                }
            }

        }


    }

    Component.onCompleted: {
        console.log('Show FirstLoad Dialog');

        visible = true;
        firstLoadDialog.z = 100;
        forceActiveFocus();
    }
}
