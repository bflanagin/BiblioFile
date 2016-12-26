var updateinterval = 20;



function oseed_auth(name,email) {

    var http = new XMLHttpRequest();
    //var url = "http://openseed.vagueentertainment.com/corescripts/auth.php?devid=" + devId + "&appid=" + appId + "&username="+ name + "&email=" + email ;
    var url = "http://openseed.vagueentertainment.com/corescripts/authPOST.php";
   // console.log(url)
    http.onreadystatechange = function() {
        if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {
              //  console.log(http.responseText);
                id = http.responseText;
                createdb();
            }

        }
    }
    http.open('POST', url.trim(), true);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&username="+ name + "&email=" + email);

    //be sure to remove this when the internet is back and before we distribute//
    //id = "00010101";

    //createdb();
}

function createdb() {

    var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1);
    var userStr = "INSERT INTO USER VALUES(?,?,?,?)";


    var updateUser = "UPDATE USER SET name='"+username+"',public_name='"+pubname+"',pin='"+pin+"' WHERE id='"+id+"'";
    var data = [id,username,pubname,pin];

    var testStr = "SELECT  *  FROM USER WHERE id= '"+id+"'";

        db.transaction(function(tx) {
          //tx.executeSql("DROP TABLE USER");
            tx.executeSql('CREATE TABLE IF NOT EXISTS USER (id TEXT, name TEXT, public_name TEXT,pin TEXT)');


                        var test = tx.executeSql(testStr);


                            if(test.rows.length == 0) {
                                if (id.length > 4) {
                                tx.executeSql(userStr,data);
                                }
                            } else {

                            tx.executeSql(updateUser);




                                }



        });

    firstrun.restart();


}



function heartbeat() {

    var http = new XMLHttpRequest();
    var url = "http://openseed.vagueentertainment.com/corescripts/heartbeat.php";
   // console.log(url)

    http.onreadystatechange = function() {

       if(http.status == 200) {
        if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {

                heart = http.responseText;
                updateinterval = 2000;

                if(roomid != " ") {
                 if (playing == 0) {retrieve_chat(roomid,currentid); }
                }
                check_requests();

            }

        }
            } else {
                    heart = "Offline";
                    updateinterval = 2000 + updateinterval;

        }
    }
    http.open('POST', url.trim(), true);
   // console.log(http.statusText);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&userid="+ id);

    heartbeats.interval = updateinterval;

}


function retrieve_users(search) {

    var http = new XMLHttpRequest();
    var url = "http://openseed.vagueentertainment.com/devs/"+devId+"/"+appId+"/scripts/info.php";
   // console.log(url)
    http.onreadystatechange = function() {
        if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {
                //console.log(http.responseText);
                var server = http.responseText;
                var fromserver = server.split("><");
                var users = 0;
                findpeeps.clear();

                while(users < fromserver.length - 1) {

                findpeeps.append({
                            name:fromserver[users].split("::")[1],
                            theid:fromserver[users].split("::")[0],
                            avatar:"default",
                            lastseen:"yesterday"
                                 });

                users = users +1;
                }

            }

        }
    }
    http.open('POST', url.trim(), true);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&id="+ id +"&search="+search+"&type=users" );

}



function send_request(room,requestid) {

    var http = new XMLHttpRequest();
    var url = "http://openseed.vagueentertainment.com/devs/"+devId+"/"+appId+"/scripts/areas.php";
   // console.log(url)
    http.onreadystatechange = function() {
        if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {
               // console.log(http.responseText);
               // var server = http.responseText;
                requests.state = "Hide";

            }

        }
    }
    http.open('POST', url.trim(), true);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&id="+ id +"&roomid="+room+"&requestid="+requestid+"&name="+username+"&type=send" );


}
function check_requests() {


    var http = new XMLHttpRequest();
    var url = "http://openseed.vagueentertainment.com/devs/"+devId+"/"+appId+"/scripts/areas.php";
   // console.log(url)
    http.onreadystatechange = function() {
        if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {
                //console.log(http.responseText);
               var server = http.responseText;
                if(server != 0) {
                    requests.type = 1;
                    requests.state = "Show";

                    chat_controls = "Hide";
                    theme_controls.state = "Hide";

                    var requestedby = server.split("><")[1].split("::")[0];
                    requests.theroom = server.split("><")[1].split("::")[2];
                    requests.invitename = server.split("><")[1].split("::")[1];
                }
            }

        }
    }
    http.open('POST', url.trim(), true);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&id="+ id +"&type=check" );

}

function accept_request(room) {


   var d = new Date();

 requests.state = "Hide";
    roomid = room;


    var http = new XMLHttpRequest();
    var url = "http://openseed.vagueentertainment.com/devs/"+devId+"/"+appId+"/scripts/areas.php";
   // console.log(url)
    http.onreadystatechange = function() {
        if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {
                console.log(http.responseText);

            }

        }
    }
    http.open('POST', url.trim(), true);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&id="+ id + "&roomid="+room+"&type=recieved" );

}

function decline_request(room) {

    var http = new XMLHttpRequest();
    var url = "http://openseed.vagueentertainment.com/devs/"+devId+"/"+appId+"/scripts/areas.php";
   // console.log(url)
    http.onreadystatechange = function() {
        if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {
                console.log(http.responseText);

            }

        }
    }
    http.open('POST', url.trim(), true);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&id="+ id + "&roomid="+room+"&type=recieved" );


}



function get_info(title,author,isbn) {

         //console.log(title+" "+author+" "+isbn);

        var http = new XMLHttpRequest();
        var t = title.replace(/\ /g,"+");
        var a = author.replace(/\ /g,"+");
        var url = "https://www.worldcat.org/search?q=ti%3A"+t+"&fq=x0%3Abook+au%3A"+a+"+bn%3A"+isbn+"";
        console.log(url);

        http.onreadystatechange = function() {

         if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {
               var data = (http.responseText);

                var nexturl = "https://www.worldcat.org"+data.split('<a id="result-1" href="')[1].split('"><')[0];


                 currentbook = title;
                //currentauthor = author;
                currentgenre = " ";
                currentpubdate = " ";
                currentdiscription = " ";
                currentheight = " ";

                get_summary(nexturl);

                }

            }
     }
        http.open('POST', url.trim(), true);
        http.send(null);
        http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");


}

function get_summary(url) {

    var http = new XMLHttpRequest();



    http.onreadystatechange = function() {
        if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {
               var data = (http.responseText);
                var pages;
                var height;
                currentauthor = data.split('Author:')[1].split("Publisher:")[0].trim().split(";")[0];
                currentgenre = data.split('<th>Genre/Form:</th>')[1].split('</tr>')[0].trim();
                currentpubdate = data.split('<td id="bib-publisher-cell">')[1].split("</td>")[0].trim();
                currentdiscription = data.split('<div id="summary">')[1].split("</div")[0].trim();

                pages = data.split('<th>Description:</th>')[1].split('</td>')[0].split('<td>')[1].split("pages")[0];

                if(pages.split("p.").length > 1) {
                    pages = pages.split("p")[0].trim();
                }

                height = data.split('<th>Description:</th>')[1].split('</td>')[0].split('<td>')[1].split(";")[1].split(" ")[1];

                currentheight = pages.trim()+":"+height.trim();

            }

        }
    }
    http.open('POST', url.trim(), true);
    http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");

}


function send_book(book,author,status,info) {

    var http = new XMLHttpRequest();
    var url = "http://openseed.vagueentertainment.com/devs/"+devId+"/"+appId+"/scripts/library.php";
    //console.log(url)

    var fixdiscription

    if(currentdiscription.split("><").length > 1) {
        fixdiscription = currentdiscription
    } else {
        fixdiscription = "><"+currentgenre+"><"+currentdiscription.replace(/&#x27;/g,"'");
    }

    http.onreadystatechange = function() {
        if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {
                //console.log(http.responseText);

            }

        }
    }

    //console.log(author);
    http.open('POST', url.trim(), true);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&id="+ id + "&name="+ username + "&book="+ book.replace(/&#x27;/g,"'").trim() + "&author="+ author.replace(/&#x27;/g,"'").trim() + "&status="+ status +
              "&info="+ info.replace(/\'/g,"&#x27;") + "&pin="+ userpin + "&size="+currentheight+ "&discription= "+fixdiscription.trim()+ "&pubdate="+currentpubdate+"&type=sending" );


}

function sync_library() {

        //library.state = "Hide";

    var http = new XMLHttpRequest();
    var url = "http://openseed.vagueentertainment.com/devs/"+devId+"/"+appId+"/scripts/library.php";
   // console.log(url)
    http.onreadystatechange = function() {
        if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {
                var data = http.responseText;
                //console.log(data);
                var books = data.split(">!<");
                var books2 = books;
                var num = 1;

                while(num < books.length) {

                    var book = books[num].replace(/\'/g,"&#x27;").split("::");
                   // console.log(book);
                        if(book[2].length > 1) {
                                if(book[4] != 0) {
                            save_library(book[2].trim(),book[3].trim()," ",book[9].trim(),book[7].trim(),book[4].trim(),book[5].trim(),book[8].trim());


                                }

                        }


                    num = num + 1;
                }

                 if(library.state =="Show") {library.state = "Reload"} else {library.state = "Show"}
            }

        }
    }
    http.open('POST', url.trim(), true);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&id="+ id + "&pin="+ userpin + "&type=sync" );



}

function save_library(title,author,isbn,date,discription,status,info,size) {

    var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1);



    var fixauthor;

            if(discription.length < 2) {
                discription = "><><";
            }

            fixauthor = author.replace(/\&#x27;/g,"'").split(";")[0];
            fixauthor = fixauthor.replace(/\'/g,"&#x27;").trim();

            var testStr = "SELECT  *  FROM LIBRARY WHERE title='"+title.replace(/\'/g,"&#x27;")+"' AND author='"+fixauthor+"'";


    var data = [title.replace(/\'/g,"&#x27;"),fixauthor,isbn,date.replace(/\'/g,"&#x27;"),discription.replace(/\'/g,"&#x27;"),status,info.replace(/\'/g,"&#x27;"),size];

    var libStr = "INSERT INTO LIBRARY VALUES(?,?,?,?,?,?,?,?)";

    db.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS LIBRARY (title TEXT, author TEXT, isbn TEXT,date TEXT, discription TEXT,status TEXT,info TEXT,size TEXT)');

         var pull =  tx.executeSql(testStr);

        if(pull.rows.length == 0) {

            if(title.length != undefined) {

                tx.executeSql(libStr,data);

                reload.running = true;

            }

        }



    });

   //get_info(title.replace(/\'/g,"&#x27;").trim(),author.replace(/\'/g,"&#x27;").trim(),isbn.trim())

}

function friend_list(pin,type) {

    booklist.clear();

    var http = new XMLHttpRequest();
    var url = "http://openseed.vagueentertainment.com/devs/"+devId+"/"+appId+"/scripts/library.php";
    //console.log(url)
    http.onreadystatechange = function() {
        if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {
                var data = http.responseText;


                if(data == "0") {
                        window_container.list = "No books found";
                } else {
                     window_container.list = "";
                    var num = 1;
                        var liststuff = data.split("><");
                    while(liststuff.length > num) {
                            var stuff = liststuff[num].split("::");

                                booklist.append({
                                                    name:stuff[2],
                                                    author:stuff[3]

                                                });

                        num = num + 1;
                    }

                }


            }

        }
    }
    http.open('POST', url.trim(), true);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&id="+ id + "&userpin="+userpin+"&pin="+ pin + "&type="+type );


}

function check_pin(pin) {


    var http = new XMLHttpRequest();
    var url = "http://openseed.vagueentertainment.com/devs/"+devId+"/"+appId+"/scripts/library.php";
    //console.log(url)
    http.onreadystatechange = function() {
        if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {
                var data = http.responseText;

                if (data == "0") {
                    createdb();
                    pin_entry.state = "Hide";
                } else {
                    pin_entry.alert = 1;

                }

            }

        }
    }
    http.open('POST', url.trim(), true);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&id="+ id + "&userpin="+ pin + "&type=pincheck" );

}

function get_friend(pin) {

    var mode;
    if(pin == "All") {

        mode = "syncfriends";
    } else {
        mode ="friendcheck";
    }

    var http = new XMLHttpRequest();
    var url = "http://openseed.vagueentertainment.com/devs/"+devId+"/"+appId+"/scripts/library.php";
    //console.log(url)
    http.onreadystatechange = function() {
        if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {
                var data = http.responseText;
                      //console.log(pin + mode + ":"+ data);
                        if(data !="0") {
                    if(pin != "All") {
                       update_friend(pin,data.split("::")[0],data.split("::")[1],data.split("::")[2],data.split("::")[3]);
                    } else {
                        var thefriend=data.split("><");
                        var num = 0;
                        while(num < thefriend.length) {
                        update_friend(thefriend[num].split("::")[0],thefriend[num].split("::")[1],thefriend[num].split("::")[2],thefriend[num].split("::")[3],thefriend[num].split("::")[4]);
                        num = num + 1;
                        }
                    }

                        }

            }

        }
    }
    http.open('POST', url.trim(), true);
    //http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send("devid=" + devId + "&appid=" + appId + "&id="+ id + "&pin="+ pin + "&userpin="+userpin+"&type="+mode );


}

function update_friend(pin,name,checkin,checkout,wish) {

    var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1);

    var testStr = "SELECT  *  FROM FLIBRARY WHERE pin='"+pin+"'";


     var updateStr = "UPDATE FLIBRARY SET name='"+name+"', comingin='"+checkin+"',goingout='"+checkout+"',wish='"+wish+"' WHERE pin ='"+pin+"'";

    var data = [pin,name,checkin,checkout,wish];

    var libStr = "INSERT INTO FLIBRARY VALUES(?,?,?,?,?)";


    db.transaction(function(tx) {

         var pull =  tx.executeSql(testStr);

        if(pull.rows.length == 0) {
                if(pin.length != 0) {
            tx.executeSql(libStr,data);
                }
        } else {
         tx.executeSql(updateStr);

        }

    });
}


function find_image(author,ind) {

    var http = new XMLHttpRequest();
    var url = "https://en.wikipedia.org/wiki/"+author.replace(/\ /g,"_").split(";")[0];
    //console.log(url)
    http.onreadystatechange = function() {
        if (http.readyState == 4) {
            //console.log(http.responseText);
            //userid = http.responseText;
            if(http.responseText == 100) {
                console.log("Incorrect DevID");
            } else if(http.responseText == 101) {
                console.log("Incorrect AppID");
            } else {
                var data = http.responseText;


                var image = "http:"+data.split('class="image"><img alt=')[1].split('src="')[1].split('"')[0];

                if(image.split("Wiktionary-logo-en.png").length  <= 1 &&
                   image.split("Disambig_gray.svg").length  <= 1 &&
                   image.split("Question_book-new.svg").length  <= 1 &&
                   image.split("Quill_and_ink.svg").length  <= 1 ) {
                library_list.setProperty(ind,"author_image",image);

                //console.log(author.split(";")[0],image);
                }
            }

        }
    }
    http.open('POST', url.trim(), true);
    http.send(null);
    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    //http.send("devid=" + devId + "&appid=" + appId + "&id="+ id + "&userpin="+ pin + "&type=pincheck" );

}

function flush () {
    var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1);
    var libStr = "DROP TABLE LIBRARY";
    library.state = "Hide";
    db.transaction(function(tx) {
        tx.executeSql(libStr);
    });

    sync_library()

}

function send_all() {


    var testStr;

    var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1);


        testStr = "SELECT  *  FROM LIBRARY WHERE 1 ORDER by author";

    db.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS LIBRARY (title TEXT, author TEXT, isbn TEXT,date TEXT, discription TEXT,status TEXT,info TEXT,size TEXT)');

         var pull =  tx.executeSql(testStr);
        var num = 0;

        while(num < pull.rows.length ) {

                //
            var book = pull.rows.item(num).title;
             currentpubdate = pull.rows.item(num).date;
            var author = pull.rows.item(num).author;
             var theinfo = pull.rows.item(num).info;
             currentdiscription = pull.rows.item(num).discription;
             var bstatus = pull.rows.item(num).status;
             var thesize = pull.rows.item(num).size;
             var theisbn = pull.rows.item(num).isbn;

                send_book(book,author,bstatus,theinfo);

            num = num + 1;
        }

    });

}
