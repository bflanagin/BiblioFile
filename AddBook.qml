import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.2

import "openseed.js" as OpenSeed
import "main.js" as Scripts

import QtQuick.LocalStorage 2.0 as Sql

Item {
    id:window_container

    property string location: " "
    property string isbn: " "
    property string author: " "
    property string title:" "

    property int type:0

    clip:true


    Timer {
        id:onlinesearch
        interval:2000
        running:false
        repeat:false
        onTriggered:if(window_container.state == "Show") {OpenSeed.get_info(title.replace(/\'/g,"%27"),author.replace(/\'/g,"%27"),isbn),onlinesearch.running = false}
    }

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

//onStateChanged: if(window_container.state == "Hide") {author = "",location ="",title="",isbn=""}

Item {
    anchors.centerIn: parent
    width:parent.width * 0.98
    height:parent.height * 0.98

    Rectangle {
        anchors.fill:parent
        color:"lightgray"
        border.color:"darkgray"
        border.width:parent.height * 0.008


    }


    Image {
        id:cover
        width:parent.height * 0.50
        height:parent.height * 0.60
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom:parent.bottom
        anchors.bottomMargin:parent.height * 0.15
        opacity:0.2
        source:bookcover
        fillMode: Image.PreserveAspectFit

        Image {
            anchors.centerIn: parent
            width:parent.height * 0.5
            height:parent.height * 0.5
            source:"graphics/add.svg"
            fillMode:Image.PreserveAspectFit
        }
    }

    Column {
        id:usercolumn
        width:parent.width * 0.97
        anchors.horizontalCenter: parent.horizontalCenter
        clip:true
        spacing:parent.height * 0.02

        Text {
            width:parent.width
            horizontalAlignment: Text.AlignHCenter

            text:if(type == 0) {"Add Book"} else {"Edit Book"}
            height:window_container.height * 0.06
            font.pixelSize: height

        }
        Rectangle {
            color:"black"
            width:parent.width * 0.96
            height:2
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text:" Title:"
            height:window_container.height * 0.04
            font.pixelSize: height

            TextField {
                anchors.left:parent.right
                width:(window_container.width - parent.width) * 0.90

                text:title
                font.pixelSize: parent.height * 0.8
                onTextChanged:{ title = text,onlinesearch.running = true,onlinesearch.restart()
                }
            }
        }
        Text {
            text:" Author:"
            height:window_container.height * 0.04
            font.pixelSize: height

            TextField {
                anchors.left:parent.right
                width:(window_container.width - parent.width) * 0.90
                font.pixelSize: parent.height * 0.8
                text:author
                onTextChanged: {author = text,onlinesearch.running = true,onlinesearch.restart()


                }


            }
        }
        Text {
            text:" ISBN:"
            height:window_container.height * 0.04
            font.pixelSize: height

            TextField {
                anchors.left:parent.right
                width:(window_container.width - parent.width) * 0.90
                font.pixelSize: parent.height * 0.8
                placeholderText: "Optional"
                text:isbn
                onTextChanged: isbn = text,onlinesearch.running = true,onlinesearch.restart()
            }
        }

        Text {
            text:" Location:"
            height:window_container.height * 0.04
            font.pixelSize: height
            TextField {
                anchors.left:parent.right
                width:(window_container.width - parent.width) * 0.90

                placeholderText: "Optional"
                text:currentinfo
                onTextChanged: currentinfo = text
                font.pixelSize: parent.height * 0.8
            }
        }
        Rectangle {
            color:"black"
            width:parent.width * 0.96
            height:2
            anchors.horizontalCenter: parent.horizontalCenter
        }

    }

    Flickable {
        anchors.top:usercolumn.bottom
        anchors.topMargin:parent.height * 0.02
        anchors.horizontalCenter: parent.horizontalCenter
        width:parent.width * 0.95
       // contentWidth: parent.width
        height:parent.height * 0.60
        contentHeight: infocolumn.height * 1.5
        clip:true

    Column {
        id:infocolumn
        width:window_container.width * 0.90
       height:window_container.height
        spacing:4
        //clip:true

        Text {
            text:"Title: "+currentbook
            width:parent.width
            wrapMode:Text.WordWrap
            font.pixelSize: parent.contentHeight * 0.08
        }

        Text {
            text:"Author: "+currentauthor
            width:parent.width
            wrapMode:Text.WordWrap
        }

        Text {
            text:"Publisher: "+currentpubdate
            width:parent.width
            wrapMode:Text.WordWrap
        }

        Text {
            text:"Genre:<br>"+currentgenre
            width:parent.width
            wrapMode:Text.WordWrap
        }

        Text {
            text:"Synopsis:"+currentdiscription
            width:parent.width
            wrapMode:Text.WordWrap

        }

    }

    }

    Rectangle {

        anchors.bottom: parent.bottom
        anchors.left:parent.left
        width:parent.width
        height:parent.height * 0.08
        color:"darkgray"
    }


Rectangle {
    id:cancel
    anchors.bottom:parent.bottom
    anchors.left:parent.left
    anchors.margins: parent.height * 0.01
    width:parent.width * 0.40
    height:parent.height * 0.06
    color:"lightgray"
    radius:6

    Text {
        anchors.centerIn: parent
        font.pixelSize: parent.height * 0.5
        text:"Cancel"
        color:"black"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: window_container.state = "Hide",themenu.state = "Show",library.state = "Show",book.state = "Hide"
    }
}

Rectangle {
    id:add
    anchors.bottom:parent.bottom
    anchors.right:parent.right
    anchors.margins: parent.height * 0.01
    width:parent.width * 0.40
    height:parent.height * 0.06
    color:"lightgray"
    radius:6

    Text {
        anchors.centerIn: parent
        font.pixelSize: parent.height * 0.5
        text:if(type == 0) {"Add"} else {"Update"}
        color:"black"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {window_container.state = "Hide",themenu.state = "Hide"
                    switch(setlibrary) {
                    case 0:if(type ==0 ) {
                            currentstatus = 1;
                            Scripts.save_library(title.replace(/\'/g,"&#x27;"),currentauthor.replace(/\'/g,"&#x27;"),isbn,currentpubdate.replace(/\'/g,"&#x27;"),"><"+currentgenre+"><"+currentdiscription.replace(/\'/g,"&#x27;"),location,currentheight)
                            OpenSeed.send_book(title.replace(/\'/g,"&#x27;").trim(),currentauthor.replace(/\'/g,"&#x27;").trim(),currentstatus,currentinfo.replace(/\'/g,"&#x27;"))
                            themenu.state = "Show",book.state = "Hide"
                             if(library.state == "Show") {library.state = "Reload"} else {library.state = "Show"}
                        }else {

                            Scripts.library_update(title.replace(/\'/g,"&#x27;").trim(),currentauthor.replace(/\'/g,"&#x27;").trim(),currentstatus.trim())
                            OpenSeed.send_book(title.replace(/\'/g,"&#x27;").trim(),currentauthor.replace(/\'/g,"&#x27;").trim(),currentstatus,currentinfo.replace(/\'/g,"&#x27;"))
                            themenu.state = "Show",book.state = "Hide"
                             if(library.state == "Show") {library.state = "Reload"} else {library.state = "Show"}
                        }break;

                    case 1:currentstatus = 0,Scripts.save_wishlist(title.replace(/\'/g,"&#x27;").trim(),currentauthor.replace(/\'/g,"&#x27;").trim(),isbn,currentpubdate.replace(/\'/g,"&#x27;"),"><"+currentgenre.trim()+"><"+currentdiscription.replace(/\'/g,"&#x27;").trim(),location,currentheight)
                            OpenSeed.send_book(title.replace(/\'/g,"&#x27;").trim(),currentauthor.replace(/\'/g,"&#x27;").trim(),0,currentinfo.replace(/\'/g,"&#x27;")),themenu.state = "Show",book.state = "Hide";
                                    if(library.state == "Show") {library.state = "Reload"} else {library.state = "Show"}
                                    break;
                    default:break;
                    }
                    //OpenSeed.get_info(title.replace(/\'/g,"%27"),author.replace(/\'/g,"%27"))

        }
    }
}


}

}
