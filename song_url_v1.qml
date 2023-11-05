import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 2.12
import QtMultimedia

Page {
    id: root
    property var model: getModel(129194941)
    function getModel(id) {
        return $api.invoke("song_url_v1",
                           {
                               "id": [
                                   id
                               ],
                               "level": "exhigh"
                           }
                           )["body"]
    }
    MediaPlayer {
        id: mediaPlayer
        audioOutput: AudioOutput {}
        source: model["data"][0]["url"]
    }
    Column {
        anchors.fill: parent
        Row {
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: {
                    let date = new Date(mediaPlayer.position)
                    return date.toLocaleString(Qt.locale("zh_CN"), "mm:ss")
                }
            }
            Slider {
                from: 0
                to: model["data"][0]["time"]
                value: mediaPlayer.position
                onMoved: {
                    mediaPlayer.setPosition(value)
                }
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: {
                    let date = new Date(model["data"][0]["time"])
                    return date.toLocaleString(Qt.locale("zh_CN"), "mm:ss")
                }
            }
        }



        Button {
            text: "play"
            onClicked: mediaPlayer.play()
        }
        Button {
            text: "pause"
            onClicked: mediaPlayer.pause()
        }
        Button {
            text: "stop"
            onClicked: mediaPlayer.stop()
        }
    }

    footer: RowLayout {
        TextField {
            id: textField
            text: "2090086774"
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
