import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:intl/intl.dart' as intl;

class Active {
  static bool activeLink = true;
}

class GitHubStarCounter extends StatefulWidget {
  /// The full repository name, e.g. torvalds/linux
  String repositoryName;
  GitHubStarCounter({
    @required this.repositoryName,
  });

  @override
  _GitHubStarCounterState createState() => _GitHubStarCounterState();
}

class _GitHubStarCounterState extends State<GitHubStarCounter> {
  // The GitHub API

  GitHub github;
  // The repository information
  Repository repository;

  // A human-readable error when the repository isn't found.
  String errorMessage;

  void initState() {
    super.initState();
    github = GitHub();
  }

  void didUpdateWidget(GitHubStarCounter oldWidget) {
    super.didUpdateWidget(oldWidget);

    // When this widget's [repositoryName] changes,
    // load the Repository information.
    if (widget.repositoryName == oldWidget.repositoryName) {
      return;
    }
    if (widget.repositoryName != 'GitHub') {
      fetchRepository();
    }
  }

  Future<void> fetchRepository() async {
    setState(() {
      repository = null;
      errorMessage = null;
    });
    try {
      var repo = await github.repositories
          .getRepository(RepositorySlug.full(widget.repositoryName));
      setState(() {
        repository = repo;
        Active.activeLink = true;
      });
    } on RepositoryNotFound {
      setState(() {
        repository = null;
        errorMessage = '${widget.repositoryName} not found.';
        Active.activeLink = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textStyle = textTheme.headline4.apply(color: Colors.green);
    final errorStyle = textTheme.bodyText1.apply(color: Colors.red);
    final numberFormat = intl.NumberFormat.decimalPattern();

    if (errorMessage != null) {
      return Text(errorMessage, style: errorStyle);
    }

    if (widget.repositoryName != null &&
        widget.repositoryName.isNotEmpty &&
        repository == null) {
      return Text('loading...');
    }

    if (repository == null) {
      // If no repository is entered, return an empty widget.
      return SizedBox();
    }

    return Text(
      '${numberFormat.format(repository.stargazersCount)}',
      style: textStyle,
    );
  }
}
