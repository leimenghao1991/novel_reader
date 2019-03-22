import 'package:flutter/material.dart';
import 'package:novel_reader/bloc/bloc_provider.dart';
import 'package:novel_reader/constants.dart';
import 'package:novel_reader/pages/community_view.dart';
import 'package:novel_reader/pages/find_view.dart';
import 'package:novel_reader/pages/shelf/shelf_bloc.dart';
import 'package:novel_reader/pages/shelf_search_view.dart';
import 'package:novel_reader/pages/shelf/shelf_view.dart';
import'package:flutter/rendering.dart';

void main(){
//  debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(alignment: Alignment.center,
          child: IconButton(icon: Icon(Icons.book), onPressed: () {
            Navigator.push(context, new MaterialPageRoute(builder: (context) => new MyHomePage(title: 'Flutter Demo Home Page')) );
          })),
    );
  }

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        buttonTheme: ButtonThemeData(minWidth: 0, height: 32),
        primarySwatch: Colors.blue,
        primaryColor: PRIMARY_COLOR,
        backgroundColor: Color(0xFFEEEEEE),
        dividerColor: Color(0xFFEEEEEE),
        scaffoldBackgroundColor: Color(0xFFFAFAFA),
      ),
      home: TestPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
//    _viewModel = new ShelfViewModel();
//    _viewModel.shelfBookSteam().listen((data){
//      print("lemon ===> "  + data.toString());
//    });


//    _repo = new BookRepo();
//    _repo.createShelfStream().listen((data) => data.documents.forEach((doc) => print(BookBean.fromJson(doc.data))));
//
//    _repo.getShelfBooks("male", (data){}, (data){}, (){});

  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 3,
        child: new Scaffold(
          appBar: new AppBar(
            backgroundColor: Color(0xFF3F51B5),
            leading: Container(
              child: new ImageIcon(
                AssetImage("assets/images/logo.png"),
              ),
              margin: const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
            ),
            actions: <Widget>[
              IconButton(
                icon: new ImageIcon(
                  AssetImage("assets/images/ic_menu_search.png"),
                  color: Colors.white,
                ),
                tooltip: "搜索",
                onPressed: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (context) => new SearchView()));
                },
              ),
              IconButton(
                icon: ImageIcon(
                  AssetImage("assets/images/ic_menu_overflow.png"),
                  color: Colors.white,
                ),
                tooltip: "更多选项",
                onPressed: () {},
              )
            ],
            bottom: new TabBar(
              tabs: [Tab(text: "书架"), Tab(text: "社区"), Tab(text: "发现")],
              indicatorColor: Colors.white,
            ),
            elevation: 0,
          ),
          body: new TabBarView(
              children: [BlocProvider(child: ShelfView(), bloc: ShelfBloc()) , new CommunityView(), new FindView()]),
        ));
  }
}
