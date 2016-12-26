import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Window 2.2

import "openseed.js" as OpenSeed
import "main.js" as Scripts

import QtQuick.LocalStorage 2.0 as Sql


Item {
    id:window_container

    property string booksearch:""




    onStateChanged:{ //if( window_container.state == "Reload") {

                switch(setlibrary) {
                case 0: Scripts.load_library(booksearch); break;
                case 1: Scripts.load_wishlist(booksearch); break;
                case 2: Scripts.load_friendlibrary(booksearch);break;
                case 3: Scripts.load_friendwishlist(booksearch);break;
                default: break;
                }
        }
    //}



    states: [

       State {
            name:"Show"

            PropertyChanges {
                target:window_container

                x:0

            }
        },

        State {
             name:"Hide"

             PropertyChanges {
                 target:window_container
                 x:parent.width
         }
        },

        State {
            name:"Reload"

            PropertyChanges {
                target:window_container

                x:0

            }

        }

    ]



    transitions: [

        Transition {
            from: "Hide"
            to: "Show"

            NumberAnimation {
                target: window_container
                property: "x"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        },


        Transition {
            from: "Show"
            to: "Hide"

            NumberAnimation {
                target: window_container
                property: "x"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }


    ]

state:"Hide"

    Rectangle {

        anchors.fill:parent
        color:"darkgray"

        Image {
            id:location_image
            anchors.centerIn: parent
            opacity: 0.2
            source:if(setlibrary == 0){"graphics/books.png"} else {"graphics/non-starred.svg"}
            width:parent.height * 0.50
            height:parent.height * 0.50
            fillMode:Image.PreserveAspectFit

        Text {
            anchors.top:location_image.bottom
            anchors.bottomMargin: 10
            anchors.horizontalCenter: location_image.horizontalCenter
            text: if(setlibrary == 0){"Library"} else {"Wish List"}
            color:"white"
            font.pixelSize: parent.height * 0.30
        }

        }


    }

    Item {
        anchors.fill:parent



        GridView {
            id:libgrid
            width:parent.width * 0.98
            height:parent.height * 0.90
            //anchors.verticalCenter: parent.verticalCenter
            anchors.bottom:bottomsearch.top
            anchors.left:parent.left
            anchors.leftMargin:parent.width * 0.01
            cellHeight: parent.height * 0.35
            cellWidth: parent.height * 0.24

            visible:if(parent.width > parent.height) {true} else {false}

            clip:true

            model: ListModel {
                id:library_list


            }

            delegate: Item {

                        width:libgrid.cellWidth * 0.98
                        height:libgrid.cellHeight * 0.98


                        Rectangle {


                            anchors.horizontalCenter: parent.horizontalCenter
                            //id:bookbg
                            width:parent.width * 0.70
                            height:parent.height * 0.75
                            color:Qt.rgba(0.1,0.1,0.1,0.5)
                            visible:if(breaker == 1) {true} else {false}


                            Rectangle {
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.top:parent.bottom
                                width:parent.width * 1
                                height:parent.height * 0.1
                                anchors.topMargin:parent.height * 0.085
                                radius:8
                                color:Qt.rgba(0.1,0.1,0.1,0.5)

                            }

                          /*  Image {
                                anchors.fill:parent
                                source:"graphics/contact.svg"
                                fillMode:Image.PreserveAspectFit
                            } */

                            Image {
                                anchors.fill:parent
                                source:author_image
                                fillMode:if(author_image == "graphics/contact.svg") {Image.PreserveAspectFit} else {Image.PreserveAspectCrop}
                                onSourceChanged: OpenSeed.find_image(author,index)
                            }
                        }



                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            id:bookbg
                            width:parent.width * 0.90
                            height:parent.height * 0.95
                            color:"black"
                            visible:if(breaker == 0) {true} else {false}

                            Image {
                                anchors.fill:parent
                                //anchors.centerIn: parent
                                //fillMode:Image.PreserveAspectFit
                                source:cover
                                clip:true

                                Rectangle {


                                       anchors.fill:parent

                                       color: if(name.length % 13 == 0) {"green"} else
                                                  if (name.length % 11 == 0) {"red"} else
                                                   if (name.length % 7 == 0) {"blue"} else
                                                       if (name.length % 5 == 0) {"darkred"} else
                                                           if (name.length % 2 == 0) {"darkpurple"}
                                                                else {"darkbrown"}
                                       opacity:0.3

                                   }

                                Image {
                                    anchors.top:parent.top
                                    anchors.right:parent.right
                                    anchors.margins: parent.width * -0.2
                                    source: switch(bstatus) {
                                                case "0":return "graphics/wish.png";break;
                                                case "1":return "graphics/blank.png";break;
                                                case "2":return "graphics/share_ribbon.png";break;
                                                case "3":return "graphics/given_ribbon.png";break;
                                                case "4":return "graphics/discard_ribbon.png";break;
                                                case "5":return "graphics/share_ribbon.png";break;

                                             }
                                    fillMode:Image.PreserveAspectFit
                                }
                            }
                        }


                        Text {
                            anchors.top:bookbg.top
                            anchors.horizontalCenter: bookbg.horizontalCenter
                            anchors.topMargin:parent.height * 0.16
                            color:"white"
                            font.pixelSize: (parent.width + text.length) * 0.1
                            text:name.replace(/&#x27;/g,"'").split(";")[0]
                            width:bookbg.width * 0.90
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode:Text.WordWrap
                        }

                        Text {
                            anchors.bottom:bookbg.bottom
                            anchors.horizontalCenter: bookbg.horizontalCenter
                            anchors.bottomMargin:parent.height * 0.08
                            color:"white"
                            font.pixelSize: (parent.width + text.length) * 0.05
                            text:author.replace(/&#x27;/g,"'").split(";")[0]
                            width:bookbg.width * 0.90
                            horizontalAlignment: Text.AlignHCenter
                            wrapMode:Text.WordWrap
                        }

                        MouseArea {
                            anchors.fill:parent
                            onClicked: {
                                currentbook = name.replace(/&#x27;/g,"'");

                                switch(bstatus) {
                                case "0": currentstatus = 0;break;
                                case "1": currentstatus = 1;break;
                                case "2": currentstatus = 2;break;
                                case "3": currentstatus = 3;break;
                                case "4": currentstatus = 4;break;
                                case "5": currentstatus = 5;break;
                                default: break;
                                }


                                currentauthor = author.replace(/&#x27;/g,"'");
                                currentdiscription = discription.replace(/&#x27;/g,"'");
                                currentpubdate = date.replace(/&#x27;/g,"'");
                                currentinfo = theinfo;
                                currentheight = thesize;
                                currentisbn = isbn;

                                book.state = "Show",themenu.state = "Shade"
                                library.state = "Hide"

                            }
                        }
            }

        }


        ListView {
            width:parent.width * 0.85
            height:parent.height * 0.90
            //anchors.verticalCenter: parent.verticalCenter
            anchors.bottom:bottomsearch.top
            anchors.left:parent.left
            visible:if(parent.width <= parent.height) {true} else {false}
            clip:true
            model:library_list
            spacing:parent.height * 0.002

            delegate:Item {
                       width : parent.width
                       height: if(breaker == 0) {(window_container.height * 0.1) + (thesize.split(":")[0])}
                                else {window_container.height * 0.05}
                    Text {
                        id:breaker_text
                        visible:if(breaker == 0) {false} else {true}
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignLeft
                        width:parent.width * 0.90
                        wrapMode: Text.WordWrap
                        color:"black"
                        text:"Author: "+author.replace(/&#x27;/g,"'").split(";")[0]
                        font.pixelSize: 16

                        opacity:0.7

                        Rectangle {
                            width:parent.width
                            height:parent.height * 0.1
                            color:"black"
                            anchors.top:parent.bottom
                        }
                    }

                Item {
                visible:if(breaker == 0) {true} else {false}
                width:parent.width * (0.70 + thesize.split(":")[1] / 100)
                height:(window_container.height * 0.1) + (thesize.split(":")[0])
                clip:true
                anchors.horizontalCenter: parent.horizontalCenter
                Item {
                    width:parent.width * 0.99
                    height:parent.height * 0.99
                    anchors.centerIn: parent

                    clip:true

                Rectangle {
                    anchors.fill:parent
                    color:if(index % 2) {"gray"} else {"darkgray"}
                    opacity:0.3
                }

                Image {
                    width:parent.width
                    height:parent.height

                    source:"graphics/book2.png"

                 Rectangle {


                        anchors.fill:parent

                        color: if(name.length % 13 == 0) {"green"} else
                                   if (name.length % 11 == 0) {"red"} else
                                    if (name.length % 7 == 0) {"blue"} else
                                        if (name.length % 5 == 0) {"darkred"} else
                                            if (name.length % 2 == 0) {"darkpurple"}
                                                 else {"darkbrown"}
                        opacity:0.3

                    }
                }


                    Text {
                        id:booktitle
                        anchors.top: parent.top
                        anchors.topMargin:parent.height * 0.02

                        text:name
                        width:parent.width  * 0.98
                        height:parent.height * 0.75
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 28
                        color:"white"
                        opacity:0.7
                        wrapMode:Text.WordWrap
                        clip:true
                    }
                        Text {
                            anchors.top:booktitle.bottom
                            anchors.right:booktitle.right
                            horizontalAlignment: Text.AlignHCenter
                            width:parent.width * 0.90
                            wrapMode: Text.WordWrap
                            color:"white"
                            text:author.split(";")[0]
                            font.pixelSize: 16

                            opacity:0.7
                        }




                Image {
                    anchors.top:parent.top
                    anchors.right:parent.right
                    anchors.margins: parent.width * -0.09
                    source: switch(bstatus) {
                                case "0":return "graphics/wish.png";break;
                                case "1":return "graphics/blank.png";break;
                                case "2":return "graphics/share_ribbon.png";break;
                                case "3":return "graphics/given_ribbon.png";break;
                                case "4":return "graphics/discard_ribbon.png";break;
                                case "5":return "graphics/share_ribbon.png";break;

                             }
                    fillMode:Image.PreserveAspectFit
                }

                }

                MouseArea {
                    anchors.fill:parent
                    onClicked: {
                        currentbook = name.replace(/&#x27;/g,"'");

                        switch(bstatus) {
                        case "0": currentstatus = 0;break;
                        case "1": currentstatus = 1;break;
                        case "2": currentstatus = 2;break;
                        case "3": currentstatus = 3;break;
                        case "4": currentstatus = 4;break;
                        case "5": currentstatus = 5;break;
                        default: break;
                        }


                        currentauthor = author.replace(/&#x27;/g,"'");
                        currentdiscription = discription.replace(/&#x27;/g,"'");
                        currentpubdate = date.replace(/&#x27;/g,"'");
                        currentinfo = theinfo;
                        currentheight = thesize;
                        currentisbn = isbn;

                        book.state = "Show",themenu.state = "Shade"
                        library.state = "Hide"

                    }
                }
            }

        }

        }

        Rectangle {
            color:Qt.rgba(0.2,0.2,0.2,1)
            width:parent.width
            height:parent.height * 0.09
            //anchors.bottomMargin: parent.height * 0.01
            anchors.bottom:parent.bottom
            anchors.left:parent.left
            id:bottomsearch
        }


        Text {
            text:searchtype
            color:"gray"
            anchors.bottom:parent.bottom
            anchors.left:parent.left
            anchors.leftMargin:parent.height * 0.02
            font.pixelSize: parent.height * 0.05
            anchors.bottomMargin: parent.height * 0.014

            TextField {
                anchors.left:parent.right
                anchors.leftMargin:parent.height * 0.25
                anchors.verticalCenter: parent.verticalCenter
                width:(window_container.width - parent.width) * 0.90
                height:parent.height
                placeholderText: if(searchtype == "Title") {"Find a book by Title"} else {"Find a book by Author"}
                text:booksearch
                onTextChanged: booksearch = text,Scripts.load_library(booksearch);
                font.pixelSize: height * 0.7

            }
            Rectangle {
                anchors.centerIn: parent
                width:parent.width * 1.2
                height:parent.height * 1.02
                color: Qt.rgba(0,0,0,0)
                border.color:"white"
                radius:5

                MouseArea {
                    anchors.fill:parent
                    onClicked: switch(searchtype) {
                               case "Title": searchtype = "Author";break;
                               case "Author": searchtype = "Title";break;
                               }
                }
            }

        }
    }
}

