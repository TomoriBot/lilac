import 'package:Lilac/http_requests.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/http_models.dart';

void main() {
  runApp(MyApp());
}

String clicked_icon_url = "-";

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lilac',
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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Lilac'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

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

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<News>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageIcon(AssetImage("images/lilac.png")),
              Text(
                widget.title,
                style: TextStyle(fontFamily: "Coiny 2.0"),
              )
            ]),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<List<News>>(
          future: futureNews,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<News>? data = snapshot.data;
              return ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        title: Text(data[index].title),
                        subtitle: Linkify(
                            onOpen: _onOpen,
                            // overflow: TextOverflow.fade,
                            textScaleFactor: 0.92,
                            text: data[index].description),
                        leading: GestureDetector(
                          child: Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                            ),
                            child: CachedNetworkImage(
                                imageUrl: data[index].iconUrl,
                                errorWidget: (context, url, error) => ImageIcon(
                                    AssetImage("images/news_back.png"))),
                          ),
                          onTap: () {
                            clicked_icon_url = data[index].iconUrl;
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return DetailScreen();
                            }));
                          },
                        ));
                  });
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
}

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
          ),
          alignment: Alignment.center,
          child: CachedNetworkImage(
              imageUrl: clicked_icon_url,
              errorWidget: (context, url, error) =>
                  ImageIcon(AssetImage("images/news_back.png"))),
        ),
        onTap: () {
          clicked_icon_url = "-";
          Navigator.pop(context);
        },
      ),
    );
  }
}
