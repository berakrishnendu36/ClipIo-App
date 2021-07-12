import 'package:clipio/store/clipstore.dart';
import 'package:clipio/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

class ClipEdit extends StatefulWidget {
  final String text;
  final String title;
  final int index;
  ClipEdit({@required this.text, @required this.title, @required this.index});
  _ClipEditState createState() => _ClipEditState();
}

class _ClipEditState extends State<ClipEdit> with TickerProviderStateMixin {
  TabController _tabController;

  AnimationController _animationController;
  Animation<Offset> _animation;

  TextEditingController _textController;
  TextEditingController _titleController;

  ClipStore _clipStore = Get.find<ClipStore>();

  String _mainText;

  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _textController = new TextEditingController();
    _titleController = new TextEditingController();
    _mainText = widget.text;
    _textController.text = _mainText;
    _titleController.text = widget.title;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();

    _tabController.addListener(() {
      if (_tabController.index == 1 && !_tabController.indexIsChanging) {
        _animationController.reverse();
      } else if (_tabController.index == 0 && !_tabController.indexIsChanging) {
        _animationController.forward();
      }
    });

    _textController.addListener(() {
      setState(() {
        _mainText = _textController.text;
      });
    });
  }

  void _surroundTextSelection(String left, String right) {
    final currentTextValue = _textController.value.text;
    final selection = _textController.selection;
    final middle = selection.textInside(currentTextValue);
    final newTextValue = selection.textBefore(currentTextValue) +
        '$left$middle$right' +
        selection.textAfter(currentTextValue);

    _textController.value = _textController.value.copyWith(
      text: newTextValue,
      selection: TextSelection.collapsed(
        offset: selection.baseOffset + left.length + middle.length,
      ),
    );
  }

  // void _addHeading(String type) {
  //   if (_textController.value.text.length != 0) {
  //     _textController.value =
  //         _textController.value.copyWith(text: _textController.text + "\n");
  //     _textController.selection = TextSelection.fromPosition(
  //         TextPosition(offset: _textController.text.length));
  //   }
  //   _surroundTextSelection(type, "");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Clip",
          style: AppStyle.secondaryHeading,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelStyle: AppStyle.buttonTextStyle,
          indicatorWeight: 1.5,
          // labelColor: AppStyle.primarySelectedColor,
          // unselectedLabelColor: AppStyle.unselectedWidgetColor,
          onTap: (value) {
            if (value == 0 && _tabController.indexIsChanging) {
              _animationController.forward();
            } else if (value == 1 && _tabController.indexIsChanging) {
              _animationController.reverse();
            }
          },
          labelPadding: EdgeInsets.only(left: 8, right: 8),
          tabs: [
            Tab(
              text: "EDIT",
            ),
            Tab(
              text: "PREVIEW",
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        child: TabBarView(controller: _tabController, children: [
          Column(
            children: [
              TextField(
                autocorrect: false,
                maxLength: 35,
                maxLines: 1,
                controller: _titleController,
                onChanged: (val) {
                  setState(() {});
                },
                cursorColor: Colors.white,
                style: AppStyle.textBoxTextStyle,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    fillColor: AppStyle.buttonBackgroundColor,
                    filled: true),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: TextField(
                  autocorrect: false,
                  maxLines: 99999,
                  controller: _textController,
                  onChanged: (val) {},
                  cursorColor: Colors.white,
                  style: AppStyle.textBoxTextStyle,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      fillColor: AppStyle.buttonBackgroundColor,
                      filled: true),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: TextButton(
                        onPressed: () {
                          _surroundTextSelection("# ", "");
                        },
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.grey.withOpacity(0.4)),
                            shape: MaterialStateProperty.all(CircleBorder())),
                        child: Text(
                          "H1",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: TextButton(
                        onPressed: () {
                          _surroundTextSelection("## ", "");
                        },
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.grey.withOpacity(0.4)),
                            shape: MaterialStateProperty.all(CircleBorder())),
                        child: Text(
                          "H2",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: TextButton(
                        onPressed: () {
                          _surroundTextSelection("### ", "");
                        },
                        style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.grey.withOpacity(0.4)),
                            shape: MaterialStateProperty.all(CircleBorder())),
                        child: Text(
                          "H3",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: IconButton(
                        splashRadius: 18,
                        onPressed: () {
                          _surroundTextSelection("  \n", "");
                        },
                        icon: Icon(Icons.keyboard_return),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: IconButton(
                        splashRadius: 18,
                        onPressed: () {
                          _surroundTextSelection('**', '**');
                        },
                        icon: Icon(
                          Icons.format_bold,
                          size: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: IconButton(
                        splashRadius: 18,
                        onPressed: () {
                          _surroundTextSelection("*", "*");
                        },
                        icon: Icon(Icons.format_italic),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: IconButton(
                        splashRadius: 18,
                        onPressed: () {
                          _surroundTextSelection("~~", "~~");
                        },
                        icon: Icon(Icons.format_strikethrough),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: IconButton(
                        splashRadius: 18,
                        onPressed: () {
                          _surroundTextSelection('[Link](', ')');
                        },
                        icon: Icon(Icons.link),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: IconButton(
                        splashRadius: 18,
                        onPressed: () {
                          _surroundTextSelection("* ", "");
                        },
                        icon: Icon(Icons.format_list_bulleted),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: IconButton(
                          splashRadius: 18,
                          onPressed: () {
                            _surroundTextSelection('> ', '');
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            size: 18,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: IconButton(
                        splashRadius: 18,
                        onPressed: () {
                          _surroundTextSelection('```\n', '\n```');
                        },
                        icon: Icon(Icons.code),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: IconButton(
                        splashRadius: 18,
                        onPressed: () {
                          _surroundTextSelection('![img](', ')');
                        },
                        icon: Icon(Icons.image),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _titleController.text != null ? _titleController.text : "",
                style: AppStyle.subHeadingStye,
              ),
              Expanded(
                child: Markdown(
                    data: _mainText,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                        blockquote: TextStyle(color: Colors.black),
                        blockquoteDecoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            border: Border(
                                left: BorderSide(
                                    color: Colors.white.withOpacity(0.5),
                                    width: 5))))),
              ),
            ],
          ),
        ]),
      ),
      bottomNavigationBar: SlideTransition(
        position: _animation,
        child: BottomAppBar(
          color: AppStyle.cacheBackgroundColor,
          child: Container(
            height: 77,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 152,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(
                            AppStyle.buttonBackgroundColor),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                        backgroundColor: MaterialStateProperty.all(
                            AppStyle.cacheBackgroundColor),
                        foregroundColor:
                            MaterialStateProperty.all(AppStyle.primaryColor),
                        side: MaterialStateProperty.all(BorderSide(
                            color: AppStyle.backgroundColor, width: 2)),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.only(top: 12, bottom: 12)),
                      ),
                      child: Text(
                        "Discard",
                        style: TextStyle(
                            color: AppStyle.backgroundColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 152,
                    child: TextButton(
                      onPressed: () async {
                        bool _res = await _clipStore.updateCache(
                            _mainText, _titleController.text, widget.index);
                        if (_res) {
                          setState(() {});
                          Navigator.of(context).pop();
                        }
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                        overlayColor: MaterialStateProperty.all(
                            AppStyle.buttonBackgroundColor),
                        backgroundColor:
                            MaterialStateProperty.all(AppStyle.backgroundColor),
                        side: MaterialStateProperty.all(BorderSide(
                            color: AppStyle.backgroundColor, width: 2)),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.only(top: 12, bottom: 12)),
                      ),
                      child: Text(
                        "Save Changes",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
