import 'package:community/services/mlab.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: new homePage(),
    );
  }
}

class homePage extends StatefulWidget {
  @override
  homeState createState() => new homeState();
}

class homeState extends State<homePage> {
  int currentTab = 0; // Index of currently opened tab.
  PageOne pageOne = new PageOne(); // Page that corresponds with the first tab.
  PageTwo pageTwo = new PageTwo(); // Page that corresponds with the second tab.
  PageThree pageThree =
      new PageThree(); // Page that corresponds with the third tab.
  List<Widget>
      pages; // List of all pages that can be opened from our BottomNavigationBar.
  // Index 0 represents the page for the 0th tab, index 1 represents the page for the 1st tab etc...
  Widget currentPage; // Page that is open at the moment.

  @override
  void initState() {
    super.initState();
    pages = [pageOne, pageTwo, pageThree]; // Populate our pages list.
    currentPage =
        pageOne; // Setting the first page that we'd like to show our user.
    // Notice that pageOne is the 0th item in the pages list. This corresponds with our initial currentTab value.
    // These two should match at the start of our application.
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Here we create our BottomNavigationBar.
    final BottomNavigationBar navBar = new BottomNavigationBar(
      fixedColor: Colors.yellow,
      currentIndex:
          currentTab, // Our currentIndex will be the currentTab value. So we need to update this whenever we tab on a new page!
      onTap: (int numTab) {
        // numTab will be the index of the tab that is pressed.
        setState(() {
          // Setting the state so we can show our new page.
          print("Current tab: " +
              numTab.toString()); // Printing for debugging reasons.
          currentTab =
              numTab; // Updating our currentTab with the tab that is pressed [See 43].
          currentPage = pages[
              numTab]; // Updating the page that we'd like to show to the user.
        });
      },
      items: <BottomNavigationBarItem>[
        new BottomNavigationBarItem(
            //numTab 0
            icon: new Icon(Icons.assignment),
            title: new Text("New Requests")),
        new BottomNavigationBarItem(
            //numTab 1
            icon: new Icon(Icons.school),
            title: new Text("SCP")),
        new BottomNavigationBarItem(
            //numTab 2
            icon: new Icon(Icons.settings),
            title: new Text("Settings"))
      ],
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Third Eye",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: Colors.green,
              // sets the active color of the `BottomNavigationBar` if `Brightness` is light
              primaryColor: Colors.red,
              textTheme: Theme.of(context).textTheme.copyWith(
                  caption: new TextStyle(
                      color: Colors
                          .white))), // sets the inactive color of the `BottomNavigationBar`
          child: navBar),
      body:
          currentPage, // The body will be the currentPage. Which we update when a tab is pressed.
    );
  }
}

class PageOne extends StatefulWidget {
  @override
  pageOneState createState() => new pageOneState();
}

class pageOneState extends State<PageOne> {
  String url =
      'https://api.mlab.com/api/1/databases/thirdeye/collections/user_data?apiKey=AL0LTAZz88PTZwxwi74C-5BT1deihTgK';

  var data;

  Future<List<Mlab>> getAllPosts() async {
    final response = await http.get(url);
    // print(response.body);
    return mlabFromJson(response.body);
  }



  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
        future: getAllPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return createList(context, snapshot);
          } else {
            return new Container(child: new Center(child: new CircularProgressIndicator()));
          }
        });
  }

  Widget createList(BuildContext context, AsyncSnapshot snapshot) {
    List<Mlab> values = snapshot.data;
    return new ListView.builder(
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        return new myCard(
          title: values[index].userName,
          desc: values[index].purpose,
        );
      },
    );
  }

  // return new Container(
  //   padding: new EdgeInsets.fromLTRB(10, 20, 10, 10),
  //   child: new Column(
  //     children: <Widget>[

  //     ],
  //   )
  //   );
}

class myCard extends StatelessWidget {
  myCard({this.title, this.desc});

  final String title;
  final String desc;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: Padding(
                padding: EdgeInsets.only(top: 12), child: Text(this.title)),
            subtitle: Padding(
                padding: EdgeInsets.only(top: 10), child: Text(this.desc)),
          ),
          ButtonTheme.bar(
            // make buttons use the appropriate styles for cards
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('ACCEPT',
                      style: TextStyle(color: Colors.green, fontSize: 18)),
                  onPressed: () {/* ... */},
                ),
                FlatButton(
                  child: const Text('IGNORE',
                      style: TextStyle(color: Colors.red, fontSize: 18)),
                  onPressed: () {/* ... */},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  // Creating a simple example page.
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
        child: new Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: new Text("Social Credit Points",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.green))),
            Padding(
                padding: EdgeInsets.all(20),
                child: new Text(
                  "Social Credit Points are rewarded as a token of appreciation to your service to the society. Every request fulfilled will fetch you upto 5 points.",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                  textAlign: TextAlign.center,
                )),
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: new Text("Your Current Social Credit Points are",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: new Text("50",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        color: Colors.green))),
          ],
        ),
      ),
    );
  }
}

class PageThree extends StatefulWidget {
  @override
  PageThreeState createState() => new PageThreeState();
}

class PageThreeState extends State<PageThree> {
  bool isSwitched = true;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Center(
        child: new Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: new Text("Account Details",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.grey))),
            Padding(
                padding: EdgeInsets.only(top: 40),
                child: new Text(
                  "Pragnya Kondrakunta",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                )),
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: new Text(
                  "pragnya@gmail.com",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.center,
                )),
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: new Text(
                  "+91 - 9567834592",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  textAlign: TextAlign.center,
                )),
            Padding(
                padding: EdgeInsets.only(top: 10),
                child: new OutlineButton(
                  borderSide: BorderSide(color: Colors.grey),
                  onPressed: () => {},
                  child: new Text("Edit Details"),
                  highlightedBorderColor: Colors.grey,
                  splashColor: Colors.grey,
                  textColor: Colors.black,
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: new Divider(
                color: Colors.black,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(40, 20, 20, 30),
              child: new Center(
                child: new Row(
                  children: <Widget>[
                    new Text(
                      "Send Notifications for all requests",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
                      },
                      activeTrackColor: Colors.lightGreenAccent,
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: new EdgeInsets.only(top: 50),
              child: new OutlineButton(
                textColor: Colors.green,
                borderSide: BorderSide(color: Colors.green),
                child: new Text("Sign Out"),
                onPressed: () => {},
                splashColor: Colors.greenAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
