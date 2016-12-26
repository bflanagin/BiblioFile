import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.2

import "openseed.js" as OpenSeed
import "main.js" as Scripts

import QtQuick.LocalStorage 2.0 as Sql

Item {

    id:window_container

    states: [

       State {
            name:"Show"

            PropertyChanges {
                target:window_container
                height:parent.height * 0.5
                opacity:1

            }
        },

        State {
             name:"Hide"

             PropertyChanges {
                 target:window_container
                 height:parent.height * 0.08
                 opacity:1
         }
        },

        State {
             name:"Shade"

             PropertyChanges {
                 target:window_container
                 height:parent.height * 0.08
                    opacity: 0.6
         }
        }

    ]



    transitions: [

        Transition {
            from: "Hide"
            to: "Show"

            NumberAnimation {
                target: window_container
                property: "height"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        },


        Transition {
            from: "Show"
            to: "Hide"

            NumberAnimation {
                target: window_container
                property: "height"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    ]

state:"Hide"



Column {
    width:parent.width
    height:parent.height
    clip:true
    spacing:parent.height * 0.05

    Rectangle {
        width:parent.width
        height:parent.width
        radius : parent.width / 2
        color:"lightgray"
        border.color:Qt.rgba(0.5,0.5,0.5,0.4)
        border.width:parent.width * 0.1

        Image {
            anchors.centerIn: parent
            source:if(newbook.state == "Show" || friends.state == "Show" || book.state == "Show") {"graphics/close.svg"} else {"graphics/contextual-menu.svg"}
            fillMode:Image.PreserveAspectFit
            width:parent.width * 0.5
            height:parent.height * 0.5
        }

        MouseArea {
            anchors.fill:parent
            onClicked: {Scripts.clear_current()
                        if(window_container.state == "Hide"|| window_container.state == "Shade")
                       {window_container.state = "Show", book.state = "Hide",friends.state = "Hide",newbook.state = "Hide",info.state = "Hide",library.state = "Show"} else {window_container.state = "Hide"}
                    }
        }
    }
    Rectangle {
        width:parent.width
        height:parent.width
        radius : parent.width / 2
        color:"lightgray"
        border.color:Qt.rgba(0.5,0.5,0.5,0.4)
        border.width:parent.width * 0.1

        Image {
            anchors.centerIn: parent
            source:"graphics/add.svg"
            fillMode:Image.PreserveAspectFit
            width:parent.width * 0.5
            height:parent.height * 0.5
        }

        MouseArea {
            anchors.fill:parent
            onClicked: {Scripts.clear_current()
                if(newbook.state == "Hide") {newbook.type = 0,newbook.state = "Show",library.state = "Hide",window_container.state = "Shade"}
                }
        }
    }
    Rectangle {
        width:parent.width
        height:parent.width
        radius : parent.width / 2
        color:"lightgray"
        border.color:Qt.rgba(0.5,0.5,0.5,0.4)
        border.width:parent.width * 0.1

        Image {
            anchors.centerIn: parent
            source:if(setlibrary == 0) {"graphics/non-starred.svg" } else {"graphics/books.png"}
            fillMode:Image.PreserveAspectFit
            width:parent.width * 0.5
            height:parent.height * 0.5
        }

        MouseArea {
            anchors.fill:parent
            onClicked: if(newbook.state == "Hide") {if(setlibrary == 0) {setlibrary = 1;
                               if(library.state == "Reload") {library.state = "Show"} else {library.state = "Reload" }
                                    } else {setlibrary = 0;
                                        if(library.state == "Reload") {library.state = "Show"} else {library.state = "Reload" }
                                        }
                           }

        }
    }
    Rectangle {
        width:parent.width
        height:parent.width
        radius : parent.width / 2
        color:"lightgray"
        border.color:Qt.rgba(0.5,0.5,0.5,0.4)
        border.width:parent.width * 0.1

        Image {
            anchors.centerIn: parent
            source:"graphics/contact.svg"
            fillMode:Image.PreserveAspectFit
            width:parent.width * 0.5
            height:parent.height * 0.5
        }

        MouseArea {
            anchors.fill:parent
            onClicked: if(friends.state == "Hide") {friends.state = "Show",window_container.state = "Shade"}

        }
    }

    Rectangle {
        width:parent.width
        height:parent.width
        radius : parent.width / 2
        color:"lightgray"
        border.color:Qt.rgba(0.5,0.5,0.5,0.4)
        border.width:parent.width * 0.1

        Text {
            anchors.centerIn: parent
            font.pixelSize: parent.height * 0.6
            text: "G"
            horizontalAlignment: Text.AlignHCenter
            color:"gray"
            //width:parent.width * 0.8
            //height:parent.height * 0.8
        }

        MouseArea {
            anchors.fill:parent
            onClicked: if(genres.state == "Hide") {genres.type = 0;genres.state = "Show",window_container.state = "Show"}

        }
    }

}

}

