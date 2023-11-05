import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 2.12
import Qt.labs.folderlistmodel 2.6

ApplicationWindow {
    id: root
    width: 640
    height: 480
    visible: true
    title: stackView.currentItem.title

    header: ToolBar {
        Label {
            text: stackView.depth > 0 ? stackView.currentItem.title : ""
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            anchors.centerIn: parent
        }
        RowLayout {
            width: parent.width
            ToolButton {
                visible: enabled
                text: "\u2630"
                font.pixelSize: Qt.application.font.pixelSize * 1.6
                onClicked: {
                    drawer.open()
                }
            }
            ToolButton {
                visible: enabled
                enabled: stackView.depth > 0
                text: "返回"
                onClicked: {
                    console.log(stackView.get(stackView.depth - 1, StackView.ForceLoad).title, "pop")
                    if(stackView.depth > 1) stackView.pop()
                    else stackView.clear()
                }
            }
            ToolButton {
                visible: enabled
                enabled: stackView.depth > 0
                text: "主页"
                onClicked: {
                    stackView.clear()
                }
            }
            Item {
                Layout.fillWidth: true
            }

            ToolButton {
                action: Action {
                    icon.name: "menu"
                    onTriggered: optionsMenu.open()
                }
                text: "⋮"
                font.pixelSize: 28
                Menu {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight
                    Action {
                        text: "退出"
                        onTriggered: {
                            stackView.clear()
                            Qt.exit(0)
                        }
                    }
                }
            }
        }
    }

    Drawer {
        id: drawer
        width: 200
        height: root.height

        ListView {
            anchors.fill: parent
            spacing: 5
            model: $api.getModule()
            header: Pane {

            }
            footer: MenuSeparator {

            }
            delegate: ToolButton {
                width: parent.width
                text: modelData.name
                onClicked: {
                    stackView.push(modelData.path, StackView.PushTransition)
                    drawer.close()
                }
                Component.onCompleted: console.log(JSON.stringify(modelData))
            }
        }
    }

    Item {
        anchors.fill: parent
        StackView {
            id: stackView
            anchors.fill: parent
            onDepthChanged: {
                console.log("Pages list:")
                for(let i = 0; i < depth; i++) {
                    let item = get(i, StackView.ForceLoad)
                    console.log(i, item.title)
                }
            }
        }
    }
}
