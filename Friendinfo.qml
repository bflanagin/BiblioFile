import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.2

import "openseed.js" as OpenSeed
import "main.js" as Scripts

import QtQuick.LocalStorage 2.0 as Sql

Item {
    id:window_container


    property string list:""
    property string pin:""
    property string friend:""

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

onStateChanged: if(window_container.state == "Show") {OpenSeed.friend_list(pin,"borrowed")}

Rectangle {

    anchors.centerIn: parent
    width:parent.width * 0.94
    height:parent.height * 0.94
    color:"lightgray"
    border.color: Qt.rgba(0.1,0.1,0.1,0.5)
    border.width: 8
    radius:4

    Image {
        anchors.centerIn: parent
        source:"graphics/addressbook.png"
        width:parent.height * 0.4
        height:parent.height * 0.4
        opacity: 0.05
    }


    Text {
        text:list
        anchors.centerIn: parent
        color:"white"
        font.pixelSize: parent.height * 0.05

    }

    MouseArea {
        anchors.fill:parent

    }


}

Item {
    anchors.centerIn:parent
    width:parent.width * 0.90
    height:parent.height * 0.90
    clip:true

    Column {
        width:parent.width
        height:parent.height
        spacing:3

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        //anchors.top:parent.top
        text:friend
        font.pixelSize: parent.height * 0.05
    }

    Row {
        width:parent.width
        height:parent.height * 0.05

        Rectangle {
            id:borrowed_button
            height:parent.height
            width:parent.width / 3
            color:"gray"

            Text {
                anchors.centerIn: parent
                text:"Borrowed"
                color:"white"
                font.pixelSize: parent.height * 0.5

            }
            MouseArea {
                anchors.fill:parent
                onClicked: {parent.color ="gray",lent_button.color = "darkgray",wish_button.color = "darkgray"

                                OpenSeed.friend_list(pin,"borrowed");
                }
            }

        }
        Rectangle {
            id:lent_button
            height:parent.height
            width:parent.width / 3
            color:"darkgray"

            Text {
                anchors.centerIn: parent
                text:"Lent"
                color:"white"
                font.pixelSize: parent.height * 0.5

            }
            MouseArea {
                anchors.fill:parent
                onClicked: {parent.color ="gray",borrowed_button.color = "darkgray",wish_button.color = "darkgray"

                             OpenSeed.friend_list(pin,"lent");
                }
            }

        }
        Rectangle {
            id:wish_button
            height:parent.height
            width:parent.width / 3
            color:"darkgray"

            Text {
                anchors.centerIn: parent
                text:"Wish List"
                color:"white"
                font.pixelSize: parent.height * 0.5

            }

            MouseArea {
                anchors.fill:parent
                onClicked: {parent.color ="gray", borrowed_button.color = "darkgray",lent_button.color = "darkgray"

                                 OpenSeed.friend_list(pin,"wish");
                            }
            }

        }
    }

    Rectangle {
        height:parent.height * 0.008
        width:parent.width * 0.95
        anchors.horizontalCenter: parent.horizontalCenter
        color:"gray"
    }

    ListView {

        width:parent.width
        height:parent.height
        clip:true

        model: ListModel {
            id:booklist

        }

        delegate: Item {

            width:parent.width
            height:window_container.height * 0.1

            Item {
                width:parent.width * 0.95
                height:parent.height * 0.95
                anchors.centerIn: parent

            Rectangle {
                anchors.fill:parent
                color:if(index % 2) {"gray"} else {"darkgray"}
                opacity:0.3
            }

            Row {
                width:parent.width
                height:parent.height

                Image {
                    width:parent.height * 0.98
                    height:parent.height * 0.98
                    source:bookcover
                    fillMode:Image.PreserveAspectFit


                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: parent.height * -0.2
                    text:name
                    font.pixelSize: (parent.height * 0.4) - (name.length * 0.50)

                    Text {
                        anchors.top:parent.bottom
                        x:parent.width * 0.50

                        text:author
                        font.pixelSize: parent.height * 0.4
                    }
                }

            }

            }

            MouseArea {
                anchors.fill:parent
                /*onClicked:{currentauthor = author.replace(/&#x27;/g,"'"),currentbook = name.replace(/&#x27;/g,"'"),
                          book.state = "Show",themenu.state = "Shade"
                            } */
            }
        }


    }


    }


    Text {
        id:message
        anchors.bottom:parent.bottom
        anchors.bottomMargin: parent.height * 0.1
        anchors.horizontalCenter: parent.horizontalCenter
        text:"(Double Tap to close)"
        color:"gray"
        font.pixelSize: parent.height * 0.03

    }

    MouseArea {
     anchors.fill:parent

     onDoubleClicked: window_container.state = "Hide",library.state = "Hide",themenu.state = "Show"
     propagateComposedEvents: true
    }

}

}
