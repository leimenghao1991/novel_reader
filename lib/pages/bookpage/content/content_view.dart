import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:novel_reader/bloc/bloc_provider.dart';
import 'package:novel_reader/db/provider/db_bean.dart';
import 'package:novel_reader/pages/PageUtils.dart';
import 'package:novel_reader/pages/bookpage/content/content_bloc.dart';

class ContentView extends StatefulWidget {
  ContentView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ContentViewState();
  }
}

class ContentViewState extends State<ContentView> {
  ContentBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
    _bloc.getChapters();
  }

  Widget _buildChapters() {
    return StreamBuilder(
      initialData: _bloc.cache,
      stream: _bloc.dataStream,
      builder: (context, snapshot) {
        List<DBChapter> chapters = _bloc.cache.chapters;
        if (chapters.isEmpty) {
          return loadingPage();
        }
        return ListView.builder(
            itemCount: chapters.length,
            itemBuilder: (context, position) {
              DBChapter chapter = chapters[position];
              return ListTile(
                title: new Text(chapter.title),
                subtitle: new Text(chapter.url),
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildChapters(),
    );
  }
}
