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


onStateChanged: if(window_container.state == "Show") {if(currentdiscription.length < 6){/*OpenSeed.get_info(currentbook,currentauthor,currentisbn)*/}}


//onStateChanged: if(window_container.state == "Hide") {Scripts.clear_current()}

Rectangle {
    anchors.fill: parent
    color:Qt.rgba(1,1,1,1)
    border.color:Qt.rgba(0.1,0.1,0.1,0.5)
    border.width:parent.height * 0.01
}

Image {
    anchors.fill:parent
    fillMode:Image.PreserveAspectCrop
    source:"graphics/book1.png"
    opacity:0.3
}
Rectangle {
    anchors.fill: parent
    color:Qt.rgba(1,1,1,0.7)
}




Flickable {
    width:parent.width
    height:parent.height
    contentWidth: width


    Column {
        width:parent.width
        height:parent.height
        spacing: 4
        Image {
           x:10
           width:parent.height * 0.08
           height:parent.height * 0.08
           source:"graphics/books.png"
        Text {
            anchors.left:parent.right
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: parent.height * 0.5
            text: switch(currentstatus) {
                  case "0":"Not Owned";break;
                  case "1":"On Shelf";break;
                  case "2":"Loaned";break;
                  case "3":"Given";break;
                  case "4":"Removed/Discarded";break;
                  default: " ";break;
                  }

            Text {
                anchors.left:parent.right
                anchors.leftMargin:parent.width * 0.1
                anchors.verticalCenter: parent.verticalCenter
                text:"("+currentinfo+")"
                font.pixelSize: parent.height * 0.5
            }
        }
    }
        Rectangle {
            width:parent.width * 0.95
            height:parent.height * 0.008
            color:"gray"
            anchors.horizontalCenter: parent.horizontalCenter

        }
        Text {
            width:parent.width * 0.95
            horizontalAlignment: Text.AlignHCenter
            text:currentbook.replace(/&#x27;/g,"'")
            font.pixelSize: parent.height * 0.05
            wrapMode: Text.WordWrap
            anchors.horizontalCenter: parent.horizontalCenter

        }
        Text {
            width:parent.width * 0.95
            horizontalAlignment: Text.AlignHCenter
            text:"by "+currentauthor.replace(/&#x27;/g,"'")
            font.pixelSize: parent.height * 0.03
            wrapMode:Text.WordWrap
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Text {
            width:parent.width * 0.95
            horizontalAlignment: Text.AlignHCenter
            text:"Published: "+currentpubdate.replace(/&#x27;/g,"'")
            font.pixelSize: parent.height * 0.015
            wrapMode:Text.WordWrap
            anchors.horizontalCenter: parent.horizontalCenter
           // onTextChanged: Scripts.library_update(currentbook,currentauthor,currentstatus)
        }

        Rectangle {
            width:parent.width * 0.95
            height:parent.height * 0.008
            color:"gray"
            anchors.horizontalCenter: parent.horizontalCenter

        }
        Rectangle {
            width:parent.width
            height:parent.height * 0.01
            //color:"gray"
            opacity:0.0

        }

        //Flickable {
        Text {
            //x:10
            width:parent.width * 0.96
            horizontalAlignment: Text.AlignLeft
            text:if(currentdiscription.split("><").length > 1) {currentdiscription.split("><")[2].replace(/&#x27;/g,"'")} else {currentdiscription.replace(/&#x27;/g,"'")}
            //text:currentdiscription
            wrapMode: Text.WordWrap
            font.pixelSize: parent.height * 0.02
            anchors.horizontalCenter: parent.horizontalCenter
            //onTextChanged: Scripts.library_update(currentbook,currentauthor,currentstatus)
        }
       //}
    }
}

Text {
    id:message
    anchors.bottom:parent.bottom
    anchors.bottomMargin: parent.height * 0.01
    anchors.horizontalCenter: parent.horizontalCenter
    text:"(Press and hold for options)\n(Double Tap to close)"
    horizontalAlignment: Text.AlignHCenter
    color:"gray"
    font.pixelSize: parent.height * 0.03

}

MouseArea {
 anchors.fill:parent
 onPressAndHold: {if(setlibrary == 0) {opts.type = 0} else {opts.type = 1}
                    opts.state = "Show"
                }
 //onPressed: message.text = "(Press and hold for options)"
 //onReleased: message.text = "(Double Tap to close)"
 onDoubleClicked: window_container.state = "Hide",library.state = "Show",themenu.state = "Show"

}


ShareOpts {
    id:opts
    state:"Hide"
    width:parent.width * 0.90
    height:parent.height * 0.70
    anchors.horizontalCenter:parent.horizontalCenter
}

}
