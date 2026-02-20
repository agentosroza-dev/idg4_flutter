import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../logics/student_logic.dart';
import '../models/student_model.dart';
import '../services/student_service.dart';
import '../utils/delete_message.dart';
import '../utils/my_message.dart';
import '../widgets/my_3line_card.dart';
import '../widgets/my_loading.dart';
import 'student_form.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final _scroller = ScrollController();
  bool _showUpIcon = false;

  @override
  void initState() {
    super.initState();
    _scroller.addListener(() {
      if (_scroller.position.pixels > 500) {
        setState(() {
          _showUpIcon = true;
        });
      } else {
        setState(() {
          _showUpIcon = false;
        });
      }

      if (_scroller.position.pixels >=
          _scroller.position.maxScrollExtent - 200) {
        context.read<StudentLogic>().readStudents(context);
      }
    });
  }

  Widget _buildFloating() {
    return FloatingActionButton(
      onPressed: () {
        _scroller.animateTo(
          0,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
      child: Icon(Icons.arrow_upward),
    );
  }

  bool _isGrid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("STUDENT"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid;
              });
            },
            icon: Icon(_isGrid ? Icons.grid_on : Icons.list),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => StudentForm()));
            },
            icon: Icon(Icons.person_add),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _showUpIcon ? _buildFloating() : null,
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<StudentLogic>().setLoading();
        await context.read<StudentLogic>().readStudents(context, refresh: true);
      },
      child: _buildGridView(),
    );
  }

  bool _deletingInProgress = false;

  Widget _buildGridView() {
    bool loading = context.watch<StudentLogic>().loading;
    List<Datum> items = context.watch<StudentLogic>().students;

    SliverGridDelegate delegate;
    Widget loadingWidget;
    if (_isGrid) {
      delegate = SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
      );
      loadingWidget = MyLoading(context);
    } else {
      delegate = SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3 / 3,
      );
      loadingWidget = MyLoading(
        context,
        crossAxisCount: 1,
        childAspectRatio: 3 / 3,
      );
    }

    if (loading) {
      return loadingWidget;
    } else {
      return GridView.builder(
        controller: _scroller,
        physics: BouncingScrollPhysics(),
        cacheExtent: 500,
        gridDelegate: delegate,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          // debugPrint("item.image: ${item.image}");
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => StudentForm(student: item),
                ),
              );
            },

            onLongPress: _deletingInProgress
                ? null
                : () async {
                    bool? deleted = await showDeleteDiaglog(context) ?? false;
                    if (deleted) {
                      setState(() {
                        _deletingInProgress = true;
                      });
                      StudentService()
                          .deleteStudents(context, item.id)
                          .then((value) {
                            MyMessage(context, "Deleted Student is $value");
                            context.read<StudentLogic>().readStudents(context);
                          })
                          .onError((e, s) {
                            MyMessage(context, e.toString());
                          })
                          .whenComplete(() {
                            setState(() {
                              _deletingInProgress = false;
                            });
                          });
                    }
                  },
            child: My3LineCard(
              context,
              item.image,
              item.name,
              item.major.title,
              item.major.id,
            ),
          );
        },
      );
    }
  }
}
