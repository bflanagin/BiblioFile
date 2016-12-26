import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.2

import "openseed.js" as OpenSeed
import "main.js" as Scripts

import QtQuick.LocalStorage 2.0 as Sql

Item {
    id:window_container

    property string searchfriends:""

    states: [

       State {
            name:"Show"

            PropertyChanges {
                target:window_container

                y:0
            }
        },

        State {
             name:"Hide"

             PropertyChanges {
                 target:window_container
                 y:0 - window_container.height
         }
        }

    ]



    transitions: [

        Transition {
            from: "Hide"
            to: "Show"

            NumberAnimation {
                target: window_container
                property: "y"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        },


        Transition {
            from: "Show"
            to: "Hide"

            NumberAnimation {
                target: window_container
                property: "y"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }


    ]

state:"Hide"

onStateChanged: if(window_container.state == "Show") {library.state = "Hide",friendsync.running = true,Scripts.load_friendlibrary()}


MouseArea {
 anchors.fill:parent

 onDoubleClicked: window_container.state = "Hide",library.state = "Show",themenu.state = "Show"
 //propagateComposedEvents: true
}

Item {
    anchors.centerIn: parent
    width:parent.width * 0.98
    height:parent.height * 0.98

    Rectangle {
        anchors.fill:parent
        color:"lightgray"
        border.color:Qt.rgba(0.1,0.1,0.1,0.5)
        border.width:parent.height * 0.01
        radius:4

    }

    Image {
        id:bgimg
        anchors.centerIn: parent
        width:parent.width * 0.60
        height:parent.height * 0.60
        source:"graphics/share.png"
        opacity:0.8
        fillMode: Image.PreserveAspectFit
    }


    Text {
        id:title
        text:"Friends"
        color:"black"
        anchors.top:parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: parent.height * 0.06

    }
    Rectangle {
        id:title_border
        anchors.top:title.bottom
        width:parent.width * 0.95
        height:parent.height * 0.005
        color:"black"
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        id:message
        anchors.bottom:parent.bottom
        anchors.bottomMargin: parent.height * 0.10
        anchors.horizontalCenter: parent.horizontalCenter
        text:"(Double Tap to close)"
        color:"gray"
        font.pixelSize: parent.height * 0.03

    }



        ListView {
            anchors.top:title_border.bottom
            anchors.topMargin: parent.height * 0.01
            width:parent.width * 0.95
            anchors.horizontalCenter: parent.horizontalCenter
            //height:parent.height
             height:parent.height - title_border.y + title_border.height


             clip:true


             MouseArea {
              anchors.fill:parent

              //onDoubleClicked: window_container.state = "Hide",library.state = "Show",themenu.state = "Show"
              propagateComposedEvents: true
             }

            model: ListModel {
                id:friendlist

            }

            delegate: Item {
                id:friendindex


                width:parent.width
                height:window_container.height * 0.08

                Rectangle {
                    anchors.fill:parent
                    color:if(index %2 == 0) {"gray"} else {"lightgray"}
                    border.color:"gray"
                    opacity:0.3
                }

                Item {
                    width:parent.width
                    height:parent.height

                    clip:true

                    Text {
                        id:friendname
                        text:if(name.length < 2) {thepin} else {name}
                        width:(parent.width * 0.50) + text.length
                        clip:true
                        wrapMode:Text.WordWrap
                        anchors.top: parent.top
                        anchors.left:parent.left
                        anchors.leftMargin:parent.height * 0.02
                        font.pixelSize: parent.height * 0.4

                    }

                    Rectangle {
                        anchors.top:friendname.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        height:parent.height * 0.02
                        width:parent.width * 0.96
                        color:"gray"
                    }

                    Row {
                        anchors.top:friendname.bottom
                        anchors.topMargin:parent.height * 0.01

                        width:parent.width
                        height:parent.height - friendname.height

                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        height:parent.height * 0.94
                        width:parent.width * 0.002
                        color:"gray"
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text:"Lent: "+numloaned
                         width:parent.width * 0.30 + text.length
                        clip:true
                        wrapMode:Text.WordWrap

                        horizontalAlignment: Text.AlignHCenter

                    }

                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        height:parent.height * 0.94
                        width:parent.width * 0.002
                        color:"gray"
                    }

                    Text {
                         width:parent.width * 0.30 + text.length
                        text:"Borrowed: "+numhave
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        height:parent.height * 0.94
                        width:parent.width * 0.002
                        color:"gray"
                    }


                    Text {
                        width:parent.width * 0.30 + text.length
                        text:"Wanting: "+numwishes
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Rectangle {
                        anchors.verticalCenter: parent.verticalCenter
                        height:parent.height * 0.94
                        width:parent.width * 0.002
                        color:"gray"
                    }

                    }

                }
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked:info.friend = name,info.pin = thepin,info.state = "Show"
                }


            }

    }





    Text {
        anchors.bottom:parent.bottom
        anchors.left:parent.left
        anchors.margins: parent.height * 0.02
        text:"Search:"
        font.pixelSize: parent.height * 0.03
        TextField {
            anchors.left:parent.right
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: parent.height * 0.8
            width:(window_container.width - parent.width) * 0.90
            text:searchfriends
            placeholderText: "Search for your Friends here"

        }
    }

}
}

