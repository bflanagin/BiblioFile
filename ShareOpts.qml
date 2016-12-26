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
        text:currentbook
        anchors.top:parent.top
        anchors.topMargin:parent.height * 0.03
        anchors.horizontalCenter: parent.horizontalCenter
        width:parent.width - editbutton.width
        horizontalAlignment: Text.AlignHCenter
        wrapMode:Text.WordWrap
        font.pixelSize: (parent.width + text.length) * 0.045
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.bottom
            text:currentinfo
            color:"black"
            font.pixelSize: parent.height * 0.4
        }
    }

        Rectangle {
            id:editbutton
            anchors.right:parent.right
            anchors.top:parent.top
            anchors.margins: parent.height * 0.03

            width:parent.width * 0.1
            height:parent.width * 0.1
            radius:width / 2
            color:"lightgray"

            Image {
                anchors.centerIn: parent
                width:parent.width * 0.80
                height:parent.width * 0.80
                source:"graphics/edit.svg"

            }

            MouseArea {
                anchors.fill:parent
                onClicked: window_container.state = "Hide",previousauthor = currentauthor,previousbook = currentbook,
                           newbook.isbn = currentisbn, newbook.author = currentauthor,
                           newbook.title = currentbook, newbook.type = 1,newbook.state = "Show"
            }

        }


    Column {
        anchors.centerIn: parent
        width:parent.width * 0.95
       // height:parent.height * 0.98
        spacing:parent.height * 0.02

        visible:if(type == 0) {true} else {false}


        Rectangle {
            width:parent.width
            height:window_container.height * 0.2
            color:"darkgray"
            radius:4

            visible:if(currentstatus == "4") {false} else {true}


            Text {
                anchors.centerIn: parent
                text:if(currentstatus == "1") {"Loan"} else { if(currentstatus == "2"){"Retrieved"} else {"Returned :("}}
                color:"white"
                font.pixelSize: parent.height * 0.5

            }

            MouseArea {
                anchors.fill:parent
                onClicked: { if(currentstatus == "1") {pin_entry.newstatus = 2,pin_entry.type = 1,pin_entry.state = "Show"}
                          else {currentstatus = "1",currentinfo = " "
                                previousauthor = currentauthor, previousbook = currentbook
                                Scripts.library_update(currentbook,currentauthor,currentstatus)
                                OpenSeed.send_book(currentbook,currentauthor,currentstatus,currentinfo)
                               }
                    window_container.state = "Hide",themenu.state = "Show"

                }

            }
        }
        Rectangle {
            width:parent.width
            height:window_container.height * 0.2
            color:"darkgray"
            radius:4
            visible:if(currentstatus == "3" || currentstatus == "4") {false} else {true}

            Text {
                anchors.centerIn: parent
                text:"Give"
                color:"white"
                font.pixelSize: parent.height * 0.5
            }

            MouseArea {
                anchors.fill:parent
                onClicked:{if(currentstatus == "1" || currentstatus == "2") {pin_entry.newstatus = 3,pin_entry.type = 1,pin_entry.state = "Show"}
                        window_container.state = "Hide",themenu.state = "Show"
                }
            }
        }
        Rectangle {
            width:parent.width
            height:window_container.height * 0.2
            color:"darkgray"
            radius:4


            Text {
                anchors.centerIn: parent
                text:if(currentstatus == 4 || currentstatus == 3) {"Replaced"} else {"Discard"}
                color:"white"
                font.pixelSize: parent.height * 0.5
            }

            MouseArea {
                anchors.fill:parent
                onClicked:{

                            if(currentstatus == 4 || currentstatus == 3) {

                                currentstatus = "1",currentinfo = " "
                                  Scripts.library_update(currentbook,currentauthor,currentstatus)
                                  OpenSeed.send_book(currentbook,currentauthor,currentstatus,currentinfo)
                             } else {


                            currentstatus = "4",currentinfo = " "
                              Scripts.library_update(currentbook,currentauthor,currentstatus)
                              OpenSeed.send_book(currentbook,currentauthor,currentstatus,currentinfo)
                                window_container.state = "Hide",book.state = "Hide",library.state = "Show"
                             }
                            window_container.state = "Hide",themenu.state = "Show"
                }
            }
        }
    }


    Column {
        anchors.centerIn: parent
        width:parent.width * 0.95
       // height:parent.height * 0.98
        spacing:parent.height * 0.02

        visible:if(type == 1) {true} else {false}


        Rectangle {
            width:parent.width
            height:window_container.height * 0.2
            color:"darkgray"
            radius:4

            Text {
                anchors.centerIn: parent
                text:"Purchased"
                color:"white"
                font.pixelSize: parent.height * 0.5
            }

            MouseArea {
                anchors.fill:parent
                onClicked:{ if(currentstatus == "1") {pin_entry.newstatus = 2,pin_entry.type = 1,pin_entry.state = "Show"}
                          else {currentstatus = "1",currentinfo = " "
                                //Scripts.library_update(currentbook,currentauthor,currentstatus)
                                Scripts.save_library(currentbook,currentauthor,currentisbn,currentpubdate,currentdiscription,currentinfo,currentheight)
                                Scripts.library_delete(currentbook,currentauthor,0,1)
                                OpenSeed.send_book(currentbook,currentauthor,currentstatus,currentinfo)
                               }
                 window_container.state = "Hide",themenu.state = "Show"
                }

            }
        }
        Rectangle {
            width:parent.width
            height:window_container.height * 0.2
            color:"darkgray"
            radius:4

            Text {
                anchors.centerIn: parent
                text:"Recieved"
                color:"white"
                font.pixelSize: parent.height * 0.5
            }

            MouseArea {
                anchors.fill:parent
                onClicked:{if(currentstatus == "1") {pin_entry.newstatus = 2,pin_entry.type = 1,pin_entry.state = "Show"}
                          else {currentstatus = "1",currentinfo = " "
                                Scripts.save_library(currentbook,currentauthor,currentisbn,currentpubdate,currentdiscription,currentinfo,currentheight)
                                Scripts.library_delete(currentbook,currentauthor,0,1)
                                OpenSeed.send_book(currentbook,currentauthor,currentstatus,currentinfo)
                               }
                    window_container.state = "Hide",themenu.state = "Show"
                }

            }
        }
        Rectangle {
            width:parent.width
            height:window_container.height * 0.2
            color:"darkgray"
            radius:4

            Text {
                anchors.centerIn: parent
                text:"Discard"
                color:"white"
                font.pixelSize: parent.height * 0.5
            }

            MouseArea {
                anchors.fill:parent
                onClicked:{currentstatus = "4",currentinfo = " "
                              Scripts.library_update(currentbook,currentauthor,currentstatus)
                              OpenSeed.send_book(currentbook,currentauthor,currentstatus,currentinfo)
                                window_container.state = "Hide",book.state = "Hide",themenu.state = "Show"
                             }
            }
        }
    }


}

}

