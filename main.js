

function firstload() {

    var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1);



    var testStr = "SELECT  *  FROM USER WHERE 1";

        db.transaction(function(tx) {

            tx.executeSql('CREATE TABLE IF NOT EXISTS USER (id TEXT, name TEXT, public_name TEXT,pin TEXT)');

             var pull =  tx.executeSql(testStr);



            if(pull.rows.length == 0) {
                os_connect.state = "Show";
            } else {
                id = pull.rows.item(0).id;
                username = pull.rows.item(0).name;
                if(pull.rows.item(0).pin != null) {
                        pin = pull.rows.item(0).pin;
                        userpin = pull.rows.item(0).pin;
                } else {
                    pin_entry.state = "Show";
                }

                library.state = "Show";

                heart.running = true;
            }

        });

}


function load_library(search) {

    thegenres = "All;;None";
    library_list.clear();

    var testStr;
    var whatsearch;

    if(searchtype == "Author") {
        whatsearch = "author";
    } else {
        whatsearch = "title";
    }

    var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1);


        testStr = "SELECT  *  FROM LIBRARY WHERE `"+whatsearch+"` LIKE '%"+search+"%' ORDER by author";

    db.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS LIBRARY (title TEXT, author TEXT, isbn TEXT,date TEXT, discription TEXT,status TEXT,info TEXT,size TEXT)');

         var pull =  tx.executeSql(testStr);
        var num = 0;

        if(pull.rows.length > 0) {
            var previous;

        while(num < pull.rows.length ) {

            var fixsize;
        if(pull.rows.item(num).size == null || pull.rows.item(num).size.length < 3) {
            fixsize = "100:22";
        } else {fixsize = pull.rows.item(num).size;

                     if(fixsize.split("volumes").length > 1) {
                                fixsize = "200:22";
                             } else  if(fixsize.split(",").length > 1) {
                            fixsize = fixsize.split(",")[1].trim();
                                 }
                        if(fixsize.split("p.").length > 1) {
                            fixsize = fixsize.split("p")[0].trim()+":"+fixsize.split(":")[1].trim();
                        }
                            if(fixsize.split(":") > 1) {
                                fixsize = fixsize+":22";
                            }

                            //console.log(fixsize);
                    }

        var fixdiscription;
            if(pull.rows.item(num).discription.replace(/&#x27;/g,"'").split("<p>").length > 1) {
                     fixdiscription = pull.rows.item(num).discription.replace(/&#x27;/g,"'").split("<p>")[1].split("</span>")[0];
             } else {
                     fixdiscription = pull.rows.item(num).discription.replace(/&#x27;/g,"'");
                }
                 //console.log(fixdiscription);


                   /* if(pull.rows.item(num).discription.split("><").length > 1) {

                    var genres = pull.rows.item(num).discription.split("><")[1].trim(); */

                        if(fixdiscription.split("><").length > 1) {

                        var genres = fixdiscription.split("><")[1].trim();

                    var primary_genre;
                    if(genres.length == 0) {
                        primary_genre = "None;';"
                    } else {
                        var gnum = 0;
                        primary_genre ="";

                        while(gnum < genres.split("<td>")[1].split("</td>")[0].split("<br>").length) {

                                //console.log(genres.split("<td>")[1].split("</td>")[0].split("<br>")[gnum]);

                                if(thegenres.search(genres.split("<td>")[1].split("</td>")[0].split("<br>")[gnum].trim()) == -1 ||
                                   genres.split("<td>")[1].split("</td>")[0].split("<br>")[gnum].trim() == "etc.") {



                                thegenres = thegenres+";;"+genres.split("<td>")[1].split("</td>")[0].split("<br>")[gnum].trim();

                                }

                                primary_genre = genres.split("<td>")[1].split("</td>")[0].split("<br>")[gnum]+";';"+primary_genre;

                            gnum = gnum + 1;
                        }
                    }
                    }


                    if(sort.length < 2 || primary_genre.search(sort) != -1) {

                    if(search.length < 1) {

                if(pull.rows.item(num).status != "4" ) {
                    if(pull.rows.item(num).status != "3") {

                        if(pull.rows.item(num).author != previous) {
                            library_list.append ({
                            name:" ",
                            cover:"",
                            date:" ",
                             author:pull.rows.item(num).author,
                             theinfo:" ",
                             discription:" ",
                             bstatus:"1",
                             thesize:"2:22",
                             isbn:" ",
                             breaker: 1,
                             author_image:"graphics/contact.svg"
                        });

                             previous = pull.rows.item(num).author }



                      library_list.append ({
                              name:pull.rows.item(num).title.replace(/&#x27;/g,"'"),
                              cover:"graphics/book1.png",
                              date:pull.rows.item(num).date.replace(/&#x27;/g,"'"),
                               author:pull.rows.item(num).author.replace(/&#x27;/g,"'"),
                               theinfo:pull.rows.item(num).info,
                               discription:fixdiscription,
                               bstatus:pull.rows.item(num).status,
                               thesize:fixsize,
                               isbn:pull.rows.item(num).isbn,
                               breaker: 0,
                               author_image:""
                          });
                      }
                }

                    } else {

                        if(pull.rows.item(num).author != previous) {
                            library_list.append ({
                            name:" ",
                            cover:"",
                            date:" ",
                             author:pull.rows.item(num).author,
                             theinfo:" ",
                             discription:" ",
                             bstatus:"1",
                             thesize:"2:22",
                             isbn:" ",
                             breaker: 1,
                             author_image:"graphics/contact.svg"
                        });

                             previous = pull.rows.item(num).author }

                            else {                    }



                            if(pull.rows.item(num).title.search(search) != -1) {
                                library_list.append ({
                                name:pull.rows.item(num).title.replace(/&#x27;/g,"'"),
                                cover:"graphics/book1.png",
                                date:pull.rows.item(num).date.replace(/&#x27;/g,"'"),
                                 author:pull.rows.item(num).author.replace(/&#x27;/g,"'"),
                                 theinfo:pull.rows.item(num).info,
                                 discription:fixdiscription,
                                 bstatus:pull.rows.item(num).status,
                                 thesize:fixsize,
                                 isbn:pull.rows.item(num).isbn,
                                 breaker: 0,
                                author_image:""
                            });

                            }


                    }
                    }

            num = num + 1;
        }
        } else {
          sync.running = true;
        }

    });



  /*  if(thegenres.search("All") == -1) {

    thegenres ="All;;"+thegenres;
    } */

}

function save_library(title,author,isbn,date,discription,info,size) {

    var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1);

    var testStr = "SELECT  *  FROM LIBRARY WHERE title='"+title+"' AND author='"+author+"'";

    if (author.length < 2) {author = currentauthor}
    if (info.length < 2) {info = currentinfo }
    if (size.length < 2) {size = currentheight}


    var data = [title.replace(/\'/g,"&#x27;").trim(),author.replace(/\'/g,"&#x27;").trim(),isbn.trim(),date.trim(),"><"+currentgenre.trim()+"><"+discription.trim(),1,info.trim(),size.trim()];

    var libStr = "INSERT INTO LIBRARY VALUES(?,?,?,?,?,?,?,?)";

    db.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS LIBRARY (title TEXT, author TEXT, isbn TEXT,date TEXT, discription TEXT,status TEXT,info TEXT,size TEXT)');

         var pull =  tx.executeSql(testStr);

        if(pull.rows.length == 0) {

            if(title.length != undefined) {

                tx.executeSql(libStr,data);

            }

        }



    });

}

function load_wishlist(search) {

    var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1);

    library_list.clear();



    var testStr;

    if(search.length > 2) {
      testStr = "SELECT  *  FROM WISHLIST WHERE `title` LIKE '%"+search+"%'";
    } else {
        testStr = "SELECT  *  FROM WISHLIST WHERE 1";
    }

    db.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS WISHLIST (title TEXT, author TEXT, isbn TEXT,date TEXT, discription TEXT,status TEXT,info TEXT,size TEXT)');

         var pull =  tx.executeSql(testStr);

        var num = 0;

        if(pull.rows.length == 0 ) {
            clear_current();
            newbook.state = "Show";

        } else {

        while(pull.rows.length > num) {
                var fixsize;
               // console.log(pull.rows.item(num).size);
            if(pull.rows.item(num).size.length < 3) {
                fixsize = "200:22";
            } else { fixsize = pull.rows.item(num).size;}

            if(search.length < 1) {

        if(pull.rows.item(num).status != "4" ) {
            if(pull.rows.item(num).status != "3") {

              library_list.append ({
                      name:pull.rows.item(num).title.replace(/&#x27;/g,"'"),
                      cover:"graphics/book1.png",
                      date:pull.rows.item(num).date.replace(/&#x27;/g,"'"),
                       author:pull.rows.item(num).author.replace(/&#x27;/g,"'"),
                       theinfo:pull.rows.item(num).info,
                       discription:pull.rows.item(num).discription.replace(/&#x27;/g,"'"),
                       bstatus:pull.rows.item(num).status,
                       thesize:fixsize,
                       isbn:pull.rows.item(num).isbn,
                        breaker: 0
                  });
              }
        }

            } else {



                    if(pull.rows.item(num).title.search(search) != -1) {
                library_list.append ({
                        name:pull.rows.item(num).title.replace(/&#x27;/g,"'"),
                        cover:"graphics/book1.png",
                        date:pull.rows.item(num).date.replace(/&#x27;/g,"'"),
                         author:pull.rows.item(num).author.replace(/&#x27;/g,"'"),
                         theinfo:pull.rows.item(num).info,
                         discription:pull.rows.item(num).discription.replace(/&#x27;/g,"'"),
                         bstatus:pull.rows.item(num).status,
                         thesize:pull.rows.item(num).size,
                         isbn:pull.rows.item(num).isbn,
                         breaker: 0
                    });

                    }


            }

            num = num + 1;
        }
    }

    });


}

function save_wishlist(title,author,isbn,date,discription,info,size) {

    var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1);


    var testStr = "SELECT  *  FROM WISHLIST WHERE title='"+title+"' AND author='"+author+"'";


    var data = [title.trim(),author.trim(),isbn.trim(),date.trim(),"><"+currentgenre.trim()+"><"+discription.trim(),0,info.trim(),size.trim()];

    var libStr = "INSERT INTO WISHLIST VALUES(?,?,?,?,?,?,?,?)";


    db.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS WISHLIST (title TEXT, author TEXT, isbn TEXT,date TEXT, discription TEXT,status TEXT,info TEXT,size TEXT)');

         var pull =  tx.executeSql(testStr);


        if(pull.rows.length == 0) {

                tx.executeSql(libStr,data);

        }



    });

}


function load_friendlibrary(search) {

    var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1);

    friendlist.clear();

     var testStr = "SELECT  *  FROM FLIBRARY WHERE 1";


    db.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS FLIBRARY (pin TEXT, name TEXT, comingin TEXT, goingout TEXT,wish TEXT)');

         var pull =  tx.executeSql(testStr);
        var num = 0;

            while (pull.rows.length > num) {


                friendlist.append ({

                                       name:pull.rows.item(num).name,
                                       numloaned:pull.rows.item(num).goingout,
                                       numhave: pull.rows.item(num).comingin,
                                       numwishes: pull.rows.item(num).wish,
                                       thepin:pull.rows.item(num).pin
                                   });

                num = num + 1;
            }



    });

}

function load_friendwishlist(search) {

    var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1);

    library_list.clear();

     var testStr = "SELECT  *  FROM FWISHLIST WHERE 1";


    db.transaction(function(tx) {

       tx.executeSql('CREATE TABLE IF NOT EXISTS FLIBRARY (pin TEXT, name TEXT,comingin TEXT, goingout TEXT,wish TEXT');

         var pull =  tx.executeSql(testStr);





    });

}

function library_update(title,author,status) {

    var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1);
    var dbname;
        if(setlibrary == 0) {
            dbname = "LIBRARY"
        } else { dbname = "WISHLIST"}

        //console.log(title+":"+author+":"+status);
        //console.log(previousbook+":"+previousauthor);

     var testStr = "SELECT  *  FROM "+dbname+" WHERE title='"+previousbook.replace(/\'/g,"&#x27;").trim()+"' AND author='"+previousauthor.replace(/\'/g,"&#x27;").trim()+"'";
    var updateStr = "UPDATE "+dbname+" SET author ='"+author.replace(/\'/g,"&#x27;").trim()+"', title ='"+title.replace(/\'/g,"&#x27;").trim()+"', status='"+status+"', discription='"+"><"+currentgenre.trim()+"><"+currentdiscription.replace(/\'/g,"&#x27;").trim()+
    "', date='"+currentpubdate.replace(/\'/g,"&#x27;").trim()+"', info='"+currentinfo.replace(/\'/g,"&#x27;").trim()+"', size='"+currentheight.trim()+
    "' WHERE author='"+previousauthor.replace(/\'/g,"&#x27;").trim()+"' AND title='"+previousbook.replace(/\'/g,"&#x27;").trim()+"'";


    db.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS '+dbname+' (title TEXT, author TEXT, isbn TEXT,date TEXT, discription TEXT,status TEXT,info TEXT,size TEXT)');

         var pull =  tx.executeSql(testStr);

            if(pull.rows.length == 1) {
                tx.executeSql(updateStr);
            }

    });


}


function library_delete(title,author,status,library) {

    var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1);
    var dbname;
        if(library == 0) {
            dbname = "LIBRARY"
        } else { dbname = "WISHLIST"}

     var testStr = "SELECT  *  FROM "+dbname+" WHERE title='"+title.replace(/\'/g,"&#x27;").trim()+"' AND author='"+author.replace(/\'/g,"&#x27;").trim()+"'";

        var delStr = "DELETE FROM "+dbname+" WHERE title='"+title.replace(/\'/g,"&#x27;").trim()+"' AND author='"+author.replace(/\'/g,"&#x27;").trim()+"'";

    db.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS '+dbname+' (title TEXT, author TEXT, isbn TEXT,date TEXT, discription TEXT,status TEXT,info TEXT,size TEXT)');

         var pull =  tx.executeSql(testStr);

            if(pull.rows.length == 1) {
                tx.executeSql(delStr);
            }

    });


}



function save_friend(pin) {

    var db = Sql.LocalStorage.openDatabaseSync("UserInfo", "1.0", "Local UserInfo", 1);

    //library_list.clear();

     var testStr = "SELECT  *  FROM FLIBRARY WHERE pin='"+pin+"'";


    var data = [pin," "," "," "," "];

    var libStr = "INSERT INTO FLIBRARY VALUES(?,?,?,?,?)";


    db.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS FLIBRARY (pin TEXT, name TEXT, comingin TEXT, goingout TEXT,wish TEXT)');

         var pull =  tx.executeSql(testStr);

        if(pull.rows.length == 0) {

                tx.executeSql(libStr,data);

        }

    });

}



function clear_current() {
    sendingto= ""
    currentbook=" "
    currentstatus= " "
    currentauthor= " "
    currentdiscription= " "
    currentpubdate= " "
    currentinfo= " "

    currentgenre= " "
    newbook.author = " "
    newbook.title = " "
    newbook.location = " "
    newbook.isbn = " "

    previousauthor = " "
    previousbook = " "
}


