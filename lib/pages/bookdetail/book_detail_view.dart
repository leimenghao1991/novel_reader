import 'package:flutter/material.dart';
import 'package:novel_reader/bloc/bloc_provider.dart';
import 'package:novel_reader/constants.dart';
import 'package:novel_reader/service/book_detail_bean.dart';
import 'package:novel_reader/service/search_view_bean.dart';
import 'package:novel_reader/pages/PageUtils.dart';
import 'package:novel_reader/pages/bookdetail/book_detail_bloc.dart';

class BookDetailView extends StatefulWidget {
  BookDetailView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BookDetailState();
  }
}

class _BookDetailState extends State<BookDetailView> {
  final Color _textGrey = Color(0xFF727272);
  BookDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of(context);
  }

  Widget _buildNavigationBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "书籍详情",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildBookInfoView(BuildContext context) {
    BookDetailInfo book = _bloc.cache.book;
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 8),
            //IntrinsicHeight 会使Row内的子元素高度相等
            child: IntrinsicHeight(
              child: Row(
                //图片、作者等书籍信息，他们属于一个Row
                children: <Widget>[
                  //图片
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Image.network(
                      book.cover,
                      width: 55,
                      height: 75,
                    ),
                  ),

                  // 书名、作者、分类、字数、更新时间
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          book.title,
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "${book.author}| ",
                              style:
                                  TextStyle(color: Colors.orange, fontSize: 13),
                            ),
                            Text(
                              "${book.cate}| ",
                              style: TextStyle(color: _textGrey, fontSize: 13),
                            ),
                            Text(convertNum(book.wordCount),
                                style:
                                    TextStyle(color: _textGrey, fontSize: 13))
                          ],
                        ),
                        Text(convertTime(book.updateTime),
                            style: TextStyle(color: _textGrey, fontSize: 13))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),

          //追更和开始阅读按钮
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 5, 0),
                  child: FlatButton.icon(
                    color: PRIMARY_COLOR,
                    icon: Icon(Icons.add, color: Colors.white),
                    label: Text(
                      "追更",
                      style: TextStyle(color: Colors.white),
                    ),
                    padding: EdgeInsets.all(7),
                    onPressed: () {
                      print("追更！！！");
                    },
                  ),
                ),
                flex: 1,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(5, 0, 15, 0),
                  child: FlatButton.icon(
                    color: PRIMARY_COLOR,
                    icon: Icon(Icons.search, color: Colors.white),
                    label: Text(
                      "开始阅读",
                      style: TextStyle(color: Colors.white),
                    ),
                    padding: EdgeInsets.all(7),
                    onPressed: () {
                      print("开始阅读！！！");
                    },
                  ),
                ),
                flex: 1,
              )
            ],
          ),

          //按钮下面的分割线
          Container(
            color: DIVIDER_COLOR,
            height: 0.5,
            margin: EdgeInsets.all(10),
          ),

          //追书人数、读者留存率、日更字数
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "追书人数",
                      style: TextStyle(color: _textGrey, fontSize: 13),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                    ),
                    Text(
                      "${book.followerCount}",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "读者留存率",
                      style: TextStyle(color: _textGrey, fontSize: 13),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                    ),
                    Text("${book.retentionRadio}%",
                        style: TextStyle(color: Colors.black, fontSize: 15))
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "日更新字数",
                      style: TextStyle(color: _textGrey, fontSize: 13),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                    ),
                    Text("${book.serializeWordCount}",
                        style: TextStyle(color: Colors.black, fontSize: 15))
                  ],
                ),
              ],
            ),
          ),

          //追书人数、读者留存率、日更新字数下面的分割线
          Container(
            color: DIVIDER_COLOR,
            height: 0.5,
            margin: EdgeInsets.all(10),
          ),

          //假装这里是Tag布局

          //然后又一条分割线
          Container(
            color: DIVIDER_COLOR,
            height: 0.5,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
          ),

          //书籍简介
          Container(
            margin: EdgeInsets.fromLTRB(15, 10, 15, 12),
            child: Text(
              book.brief,
              style: TextStyle(fontSize: 15, color: Colors.black),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildNavigationBar(context),
      body: StreamBuilder(
          initialData: _bloc.cache,
          stream: _bloc.data,
          builder: (context, data) {
            if (!_bloc.isDataValid()) {
              return loadingPage();
            } else {
              return Container(
                child: ListView(
                  children: <Widget>[
                    //书籍信息
                    _buildBookInfoView(context),

                    //书籍和热评之间的分割线
                    Container(
                      color: LIGHT_WHITE,
                      height: 10,
                    ),

                    //热评
                    _buildHotCommentsView(context),

                    //热评和推荐书单之间的分割线
                    Container(
                      color: LIGHT_WHITE,
                      height: 10,
                    ),

                    //社区信息
                    _buildCommunityView(context),

                    //推荐书单
                    _buildRecommendBooks(context)
                  ],
                ),
              );
            }
          }),
    );
  }

  _buildHotCommentsView(BuildContext context) {
    List<CommentBean> comments = _bloc.cache.comments;
    if (comments.isEmpty) {
      return Container();
    }

    Color userNameColor = Color(0xFFA58D5E);

    List<Widget> tiles = comments.map((CommentBean comment) {
      User author = comment.author;
      return Container(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //热门书评用户图片
              Container(
                width: 60,
                height: 60,
                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                child: new ClipOval(
                  child: new FadeInImage.assetNetwork(
                    placeholder: "assets/images/ic_default_portrait.png",
                    //预览图
                    fit: BoxFit.fill,
                    image: author.avatar,
                  ),
                ),
              ),

              //图片右侧的控件
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "${author.nickName} lv.${author.level}",
                    style: TextStyle(color: userNameColor, fontSize: 13),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: Text(
                        comment.title,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        maxLines: 1,
                      )),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: StarRating(
                      rating: comment.rating.toDouble(),
                      color: Colors.orange,
                      height: 14,
                      space: 3,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                      comment.content,
                      style: TextStyle(color: _textGrey, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
//                        child: FlatButton.icon(onPressed: () {},
//                            icon: Image.asset(
//                              "assets/images/post_item_like.png", height: 13,),
//                            label: Text(
//                              comment.likeCount.toString(), style: TextStyle(
//                                color: Color(0xFFB2B2B2), fontSize: 13),)),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          "assets/images/post_item_like.png",
                          height: 13,
                        ),
                        Container(
                          width: 10,
                        ),
                        Text(
                          comment.likeCount.toString(),
                          style:
                              TextStyle(color: Color(0xFFB2B2B2), fontSize: 13),
                        )
                      ],
                    ),
                  )
                ],
              ))
            ],
          ));
    }).toList();

    return Container(
      child: Column(
        children: <Widget>[
          //热门书评 + 更多 row
          Container(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "热门书评",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                Text(
                  "更多",
                  style: TextStyle(color: _textGrey, fontSize: 15),
                )
              ],
            ),
          ),

          //评论列表
          ListView(
            children: tiles,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          )
        ],
      ),
    );
  }

  _buildCommunityView(BuildContext context) {
    BookDetailInfo book = _bloc.cache.book;
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  "${book.title}的社区",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
              Container(
                child: Text(
                  "共有${book.postCount}个帖子",
                  style: TextStyle(color: _textGrey, fontSize: 13),
                ),
              )
            ],
          ),
          Icon(
            Icons.keyboard_arrow_right,
            color: ICON_GRAY_COLOR,
          )
        ],
      ),
    );
  }

  _buildRecommendBooks(BuildContext context) {
    List<RecommendBookBean> recommends = _bloc.cache.recommends;
    if (recommends.isEmpty) {
      return Container();
    }

    List<Widget> widgets = recommends.map((RecommendBookBean recommend) {
      return Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Image.network(
                recommend.cover,
                width: 45,
                height: 60,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    recommend.title,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
                    child: Text(
                      recommend.author,
                      style: TextStyle(color: _textGrey, fontSize: 13),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 3, 0, 3),
                    child: Text(
                      recommend.desc,
                      style: TextStyle(color: _textGrey, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "共${recommend.bookCount}本书| ${recommend.collectorCount}人收藏",
                    style: TextStyle(color: Color(0xFFB2B2B2), fontSize: 13),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }).toList();

    widgets.insert(
        0,
        Container(
          padding: EdgeInsets.all(15),
          child: Text(
            "推荐书单",
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
        ));

    widgets.insert(
        0,
        Container(
          color: LIGHT_WHITE,
          height: 10,
        ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return CircularProgressIndicator();
  }
}

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final Color color;
  final int height;
  final double space;

  StarRating(
      {this.starCount = 5,
      this.rating = .0,
      this.color,
      this.height,
      this.space = 0});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = new Icon(
        Icons.star_border,
        color: color ?? Theme.of(context).buttonColor,
        size: height == null ? null : height.toDouble(),
      );
    } else if (index > rating - 1 && index < rating) {
      icon = new Icon(
        Icons.star_half,
        color: color ?? Theme.of(context).primaryColor,
        size: height == null ? null : height.toDouble(),
      );
    } else {
      icon = new Icon(
        Icons.star,
        color: color ?? Theme.of(context).primaryColor,
        size: height == null ? null : height.toDouble(),
      );
    }
    return Container(
      margin: EdgeInsets.fromLTRB(
          index == 0 ? 0 : space, 0, index == starCount - 1 ? 0 : space, 0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
        children:
            new List.generate(starCount, (index) => buildStar(context, index)));
  }
}
