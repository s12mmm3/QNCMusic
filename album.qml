import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 2.12

Page {
    id: root
    property var model: getModel(129194941)
    function getModel(id) {
        return $api.invoke("album",
                           {
                               "id": id
                           }
                           )["body"]
    }
    ListView {
        anchors.fill: parent
        anchors.leftMargin: 5
        anchors.rightMargin: 5
        clip: true
        spacing: 5
        model: root.model["songs"]
        header: ColumnLayout {
            width: parent.width
            spacing: 5
            Image {
                Layout.maximumWidth: parent.width
                Layout.preferredWidth: 320
                Layout.preferredHeight: width
                Layout.alignment: Qt.AlignHCenter
                source: root.model["album"]["blurPicUrl"]
            }
            Text {
                text: root.model["album"]["name"]
                width: parent.width
                elide: Text.ElideRight
                font.pixelSize: 20
            }
            Text {
                text: {
                    let result = ""
                    let ar = root.model["album"]["artists"]
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
        }

        delegate: RowLayout {
            spacing: 5
            width: parent.width
            Image {
                Layout.preferredWidth: 80
                Layout.preferredHeight: Layout.preferredWidth
                source: modelData["al"]["picUrl"]
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
                        let ar = modelData["ar"]
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
                    text: modelData["al"]["name"]
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
            text: "129194941"
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
