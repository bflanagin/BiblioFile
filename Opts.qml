import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.2

import "openseed.js" as OpenSeed
import "main.js" as Scripts

import QtQuick.LocalStorage 2.0 as Sql


Item {
    id:window_container

    property string booksearch:""
    property int type: 0
    clip:true


    states: [

       State {
            name:"Show"

            PropertyChanges {
                target:window_container

                y:0 + (window_container.height * 0.25)
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

Item {
    anchors.fill:parent
    visible:if(type == 0) {true} else {false}
    Rectangle {
        anchors.centerIn: parent
        width:parent.width
        height:parent.height
        border.color: Qt.rgba(0.1,0.1,0.1,0.5)
        border.width:4
        color:"lightgray"
        radius:4

        Image {
            anchors.centerIn: parent
            source:"graphics/share.png"
            fillMode:Image.PreserveAspectFit
            width:parent.width * 0.80
            height:parent.width * 0.80
            opacity:0.2
        }
    }

    MouseArea {
        //anchors.fill:parent
        anchors.centerIn: parent
        width:parent.width * 1.5
        height:parent.height * 1.5
        onClicked:window_container.state = "Hide"
        enabled:if(window_container.state == "Show") {true} else {false}

    }

    Text {
        id:title
        text:"Genres"
        anchors.top:parent.top
        anchors.topMargin:parent.height * 0.03
        anchors.horizontalCenter: parent.horizontalCenter
        width:parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode:Text.WordWrap
        font.pixelSize: (parent.height + text.length) * 0.065

    }

    Rectangle {
        anchors.top:title.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        height:parent.height * 0.01
        width:parent.width * 0.96
        color:"gray"
        id:title_border
    }

    ListView {
        id:genre_container
        anchors.top:title_border.bottom
        anchors.topMargin:parent.height * 0.01
        anchors.horizontalCenter: parent.horizontalCenter
        width:parent.width
        height:(parent.height * 0.80)
        clip:true
        model:thegenres.split(";;")

            /* ListModel {
            id:genrelist

            ListElement {
                genre: "All"
            }

            ListElement {
                genre: "Fiction"
            }
            ListElement {
                genre: "Non-Fiction"
            }
            ListElement {
                genre: "Drama"
            }
            ListElement {
                genre: "Reference"
            }


        } */

        delegate: Item {
                            anchors.horizontalCenter: parent.horizontalCenter
                         height:window_container.height * 0.2
                        width:parent.width * 0.96

                  Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    height:parent.height *0.96
                    width:parent.width * 0.96
                    color:"gray"
                    border.color:Qt.rgba(0.1,0.1,0.1,0.6)
                    border.width:parent.height * 0.05
                    radius:4

                    Text {
                        anchors.centerIn: parent
                        text:modelData
                        color:"white"
                        width:parent.width * 0.9
                        wrapMode:Text.WordWrap
                        font.pixelSize: (parent.height * 0.5 - text.length) * 0.9
                        horizontalAlignment: Text.AlignHCenter
                    }

                    MouseArea {
                        anchors.fill:parent
                        onClicked:{if(modelData != "All") {sort = modelData} else {sort = " "}
                                    if(library.state == "Show") {library.state = "Reload"} else {library.state = "Show"}
                                    window_container.state = "Hide"
                        }
                    }
        }
        }
    }

    Rectangle {
        anchors.top:genre_container.bottom
        anchors.topMargin:parent.height * 0.01

        anchors.horizontalCenter: parent.horizontalCenter
        height:parent.height * 0.01
        width:parent.width * 0.96
        color:"gray"

    }


}

Item {
    anchors.fill:parent
    visible:if(type == 1) {true} else {false}
    Rectangle {
        anchors.centerIn: parent
        width:parent.width
        height:parent.height
        border.color: Qt.rgba(0.1,0.1,0.1,0.5)
        border.width:4
        color:"lightgray"
        radius:4

        Image {
            anchors.centerIn: parent
            source:"graphics/books.png"
            fillMode:Image.PreserveAspectFit
            width:parent.width * 0.80
            height:parent.width * 0.80
            opacity:0.2
        }
    }

    MouseArea {
        //anchors.fill:parent
        anchors.centerIn: parent
        width:parent.width * 1.5
        height:parent.height * 1.5
        onClicked:window_container.state = "Hide"
        enabled:if(window_container.state == "Show") {true} else {false}

    }

    Text {
        id:ltitle
        text:"Library Options"
        anchors.top:parent.top
        anchors.topMargin:parent.height * 0.03
        anchors.horizontalCenter: parent.horizontalCenter
        width:parent.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode:Text.WordWrap
        font.pixelSize: (parent.height + text.length) * 0.065

    }

    Rectangle {
        anchors.top:ltitle.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        height:parent.height * 0.01
        width:parent.width * 0.96
        color:"gray"
        id:ltitle_border
    }

    ListView {
        id:o_container
        anchors.top:ltitle_border.bottom
        anchors.topMargin:parent.height * 0.01
        anchors.horizontalCenter: parent.horizontalCenter
        width:parent.width
        height:(parent.height * 0.80)
        clip:true
        model: ListModel {
            id:olist

            ListElement {
                genre: "Reload from server"
            }
            ListElement {
                genre: "Send All"
            }

        }

        delegate: Item {
                            anchors.horizontalCenter: parent.horizontalCenter
                         height:window_container.height * 0.2
                        width:parent.width * 0.96

                  Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    height:parent.height *0.96
                    width:parent.width * 0.96
                    color:"gray"
                    border.color:Qt.rgba(0.1,0.1,0.1,0.6)
                    border.width:parent.height * 0.05
                    radius:4

                    Text {
                        anchors.centerIn: parent
                        text:genre
                        color:"white"
                        font.pixelSize: parent.height * 0.5 - text.length
                    }

                    MouseArea {
                        anchors.fill:parent
                        onClicked:if (genre == "Send All") {OpenSeed.send_all()} else {OpenSeed.flush();
                        }
                    }
        }
        }
    }

    Rectangle {
        anchors.top:o_container.bottom
        anchors.topMargin:parent.height * 0.01

        anchors.horizontalCenter: parent.horizontalCenter
        height:parent.height * 0.01
        width:parent.width * 0.96
        color:"gray"

    }


}

}

