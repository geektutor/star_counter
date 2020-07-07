import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'star_counter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

void main() {
  runApp(StarCounterApp());
}

class StarCounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isPlatformDark =
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    final initTheme = isPlatformDark ? darkTheme : lighterTheme;
    return ThemeProvider(
      initTheme: initTheme,
      child: Builder(builder: (context) {
        return MaterialApp(
          theme: ThemeProvider.of(context),
          routes: {
            '/': (context) => HomePage(),
          },
        );
      }),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _repositoryName = "GitHub";

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'GitHub Star Counter',
          ),
          actions: <Widget>[
            ThemeSwitcher(
              builder: (context) {
                return IconButton(
                  icon: Icon(Icons.brightness_3, size: 25, color: Colors.black),
                  onPressed: () {
                    ThemeSwitcher.of(context).changeTheme(
                      theme: ThemeProvider.of(context).brightness ==
                              Brightness.light
                          ? darkTheme
                          : lighterTheme,
                    );
                  },
                );
              },
            ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                        FlatButton(
                          color: Colors.transparent,
                          textColor: Colors.blue,
                          onPressed: () => launch(
                            '/#/privacypolicy',
                            enableJavaScript: true,
                            enableDomStorage: true,
                          ),
                          child: Text('Privacy Policy'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
