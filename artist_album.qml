import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 2.12

Page {
    id: root
    property var model: getModel(15396)
    function getModel(id) {
        return $apiHelper.invoke("artist_album",
                           {
                               "id": id,
                               "limit": 5
                           }
                           )["body"]
    }
    ListView {
        anchors.fill: parent
        clip: true
        spacing: 5
        model: root.model["hotAlbums"]
        header: ColumnLayout {
            width: parent.width
            spacing: 5
            Image {
                Layout.maximumWidth: parent.width
                Layout.preferredWidth: 320
                Layout.preferredHeight: width
                Layout.alignment: Qt.AlignHCenter
                source: root.model["artist"]["picUrl"]
            }
            Text {
                text: root.model["artist"]["name"]
                width: parent.width
                elide: Text.ElideRight
                font.pixelSize: 20
            }
            Text {
                text: {
                    let result = ""
                    let ar = root.model["artist"]["alias"]
                    for(let i = 0; i < ar.length; i++) {
                        result = result + ar[i]
                        if(i < ar.length - 1) {
                            result = result + "/"
                        }
                    }
                    return result
                }
                width: parent.width
                elide: Text.ElideRight
                color: "#708090"
            }
        }

        delegate: RowLayout {
            spacing: 10
            width: parent.width
            Image {
                Layout.preferredWidth: 80
                Layout.preferredHeight: Layout.preferredWidth
                source: modelData["picUrl"]
            }
            Column {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                Text {
                    text: modelData["name"]
                    width: parent.width
                    elide: Text.ElideRight
                }
                Text {
                    text: {
                        let result = ""
                        let ar = modelData["artists"]
                        for(let i = 0; i < ar.length; i++) {
                            result = result + ar[i]["name"]
                            if(i < ar.length - 1) {
                                result = result + "/"
                            }
                        }
                        return result
                    }
                    width: parent.width
                    elide: Text.ElideRight
                    color: "#708090"
                }
                Text {
                    text: modelData["size"] + "歌曲"
                    color: "#708090"
                    width: parent.width
                    elide: Text.ElideRight
                }
            }
            ToolButton {
                text: "⋮"
                font.pixelSize: 28
            }
        }
    }
    footer: RowLayout {
        TextField {
            id: textField
            text: "15396"
        }
        Item {
            Layout.fillWidth: true
        }
        Button {
            text: "设置"
            onClicked: {
                model = getModel(textField.text)
                console.log(JSON.stringify(model))
            }
        }
    }
}
