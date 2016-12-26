import QtQuick 2.4
import QtQuick.Controls 1.2
import "main.js" as Scripts
import "openseed.js" as OpenSeed

import QtQuick.LocalStorage 2.0 as Sql



Rectangle {

    id:popup
    color:"lightgray"
    border.color:"gray"
    border.width:10
    radius:8

    property int type:0
    property int newstatus:0
    property int alert:0

    states: [
        State {
            name: "Show"
            PropertyChanges {
                target:popup
                visible:true
            }
        },
        State {
            name: "Hide"
            PropertyChanges {
                    target:popup
                    visible:false
            }
        }


    ]
    state:"Hide"

    Text {

        id:title
        anchors.top:parent.top
        anchors.topMargin:parent.height * 0.04
        anchors.horizontalCenter: parent.horizontalCenter
        text:if(alert == 1){"Enter Differen't Pin"} else {"Enter Pin"}
        font.pixelSize:if(alert == 1){parent.height * 0.2 - text.length} else {parent.height * 0.33 - text.length}

    }
    TextField {
        anchors.top:title.bottom
        anchors.horizontalCenter: title.horizontalCenter
        text:pin
        onTextChanged: pin = text
        maximumLength: 4
        placeholderText: "0000"
        height:parent.height * 0.3
        width:title.width
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: height * 0.8
    }

    Rectangle {
        id:cancel
        anchors.bottom:parent.bottom
        anchors.left:parent.left
        anchors.margins: parent.height * 0.08
        width:parent.width * 0.40
        height:parent.height * 0.15
        color:"lightgray"
        radius:6
        visible:if(type != 0) {true} else {false}

        Text {
            anchors.centerIn: parent
            font.pixelSize: parent.height * 0.5
            text:"Cancel"
            color:"black"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: popup.state = "Hide"
        }
    }

    Rectangle {
        id:add
        anchors.bottom:parent.bottom
        anchors.right:parent.right
        anchors.margins: parent.height * 0.08
        width:parent.width * 0.40
        height:parent.height * 0.15
        color:"lightgray"
        radius:6

        Text {
            anchors.centerIn: parent
            font.pixelSize: parent.height * 0.5
            text:"Add"
            color:"black"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                        if(type == 0) {
                        OpenSeed.check_pin(pin)
                        } else {
                            popup.state = "Hide"
                            currentinfo = pin
                            currentstatus = newstatus
                            previousauthor = currentauthor
                            previousbook = currentbook

                           Scripts.library_update(currentbook,currentauthor,newstatus)
                           OpenSeed.send_book(currentbook,currentauthor,newstatus,currentinfo)
                           Scripts.save_friend(pin)
                            OpenSeed.get_friend(pin)
                        }

            }
            }
        }

}
