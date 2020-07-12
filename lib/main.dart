import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'star_counter.dart';
import 'package:url_launcher/url_launcher.dart';

bool darkMode = false;

void main() {
  runApp(StarCounterApp());
}

class StarCounterApp extends StatefulWidget {
  @override
  _StarCounterAppState createState() => _StarCounterAppState();
}

class _StarCounterAppState extends State<StarCounterApp> {
  String _repositoryName = "GitHub";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: darkMode ? ThemeData.dark() : ThemeData.light(),
      routes: {
        '/': (context) => Scaffold(
              appBar: AppBar(
                title: Text('GitHub Star Counter'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.brightness_3),
                    onPressed: () {
                      setState(() {
                        darkMode = !darkMode;
                      });
                    },
                  )
                ],
              ),
              body: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Enter a GitHub repository',
                              hintText: 'geektutor/wewe',
                            ),
                            onSubmitted: (text) {
                              setState(() {
                                _repositoryName = text;
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 32.0),
                            child: GitHubStarCounter(
                              repositoryName: _repositoryName, // New
                            ),
                          ),
                          FlatButton(
                            color: Colors.transparent,
                            textColor: Colors.blue,
                            onPressed: () => launch(
                              Active.activeLink
                                  ? 'https://github.com/$_repositoryName'
                                  : 'https://github.com/',
                              enableJavaScript: true,
                              enableDomStorage: true,
                            ),
                            child: Text('Go to GitHub'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
      },
    );
  }
}
