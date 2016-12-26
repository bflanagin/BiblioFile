import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.2

import "openseed.js" as OpenSeed
import "main.js" as Scripts

import QtQuick.LocalStorage 2.0 as Sql

ApplicationWindow {

    visible: true
    width: Screen.width
    height: Screen.height
    title: qsTr("BiblioFile")


    //openseed gobals
    property string id: ""
    property string username: "" //this might need to have a secondary variable for those that RP
    property string useremail:""
    property string devId: "Vag-01001011" //given by the OpenSeed server when registered
    property string appId: "VagBib-0523" //given by the OpenSeed server when registered

    property string heart: ""

    property string bookcover: "graphics/book1.png"

    property int setlibrary:0

    property string currentlibrary: username+"'s Library"
    property string pin:""
    property string userpin:""
    property string passfail: ""

    property string sort:""

     property string pubname:" "

    property string previousbook:" "
    property string previousauthor: " "

    property string sendingto: ""
    property string currentbook:" "
    property string currentstatus: " "
    property string currentauthor: " "
    property string currentdiscription: " "
    property string currentpubdate: " "
    property string currentheight: " "
    property string currentisbn: " "

    property string currentgenre:" "
    property string currentinfo: " "

    property string searchtype: "Title"

    property var thegenres: ""


    //friend variables //

    property string currentfriend: "Friend"


    Timer {
        id:firstrun
        interval:10
        running:true
        repeat:false
       onTriggered:Scripts.firstload()

    }

    Timer {
        id:sync
        interval: 1000
        running:true
        repeat:false
        onTriggered:OpenSeed.sync_library()
    }

    Timer {
        id:friendsync
        interval:10
        running:false
        repeat:false
        onTriggered:OpenSeed.get_friend("All")
    }

    Timer {
        id:reload
        interval: 20
        running:false
        repeat:false
        onTriggered:if(library.state == "Show") {library.state = "Reload"} else {library.state = "Show"}
    }



Item {
    id:titlebar
    width:parent.width
    height:parent.height * 0.05
    clip:true
    Rectangle {
       anchors.fill:parent
       color:Qt.rgba(0.1,0.1,0.1,0.8)
    }
    Image {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left:parent.left
        anchors.leftMargin:parent.width * 0.01
        fillMode:Image.PreserveAspectFit
        source:"graphics/books.png"
        width:parent.height
        height:parent.height

        Text {
            anchors.left:parent.right
            anchors.leftMargin:parent.width * 0.04
            text:if(setlibrary == 0) {currentlibrary} else {username+"'s WishList"}
            color:Qt.rgba(0.7,0.7,0.7,1)
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: parent.height * 0.6
        }
    }

    MouseArea {
        anchors.fill:parent
        onClicked:genres.type = 1,genres.state = "Show"
    }
}

Rectangle {
    anchors.top:titlebar.bottom
    width:parent.width
    height:parent.height - titlebar.height
    color:"#302521"
}

Library {
    id:library
    y:titlebar.height+ titlebar.y
    width:parent.width
    height:parent.height - titlebar.height
    state:"Hide"
}


BibMenu {
    id:themenu
    anchors.top:parent.top
    anchors.right:parent.right
    anchors.margins: parent.height * 0.01
    state:"Show"
    width:parent.height * 0.08
    height:parent.height * 0.5
}

Friend {
    id:friends
    width:if(parent.width > parent.height) {parent.height * 0.8} else {parent.width}
    height:parent.height
    state: "Hide"

    anchors.horizontalCenter: parent.horizontalCenter
}


Book {
    id:book
    anchors.horizontalCenter: parent.horizontalCenter
    width:if(parent.width > parent.height) {parent.height * 0.8} else {parent.width}
    height:parent.height
    state:"Hide"
}


AddBook {
    id:newbook
     width:if(parent.width > parent.height) {parent.height * 0.8} else {parent.width}
    height:parent.height
    state: "Hide"
    anchors.horizontalCenter: parent.horizontalCenter
}

Friendinfo {
    id:info

     width:if(parent.width > parent.height) {parent.height * 0.8} else {parent.width}
    height:parent.height
    state: "Hide"
    anchors.horizontalCenter: parent.horizontalCenter
}

Opts {
    id:genres
    state:"Hide"
    width:parent.height * 0.50
    height:parent.height * 0.70
    anchors.horizontalCenter:parent.horizontalCenter
}


Auth {
    id:os_connect
    state:"Hide"
    anchors.centerIn: parent
    width:parent.width * 0.98
    height:parent.height * 0.60
}

Pin {
    id:pin_entry
    state:"Hide"
    anchors.centerIn: parent
    width:parent.width * 0.98
    height:parent.height * 0.30
}


}

