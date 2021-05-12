import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/api/firebase_api.dart';
import 'package:todo_app/provider/user.dart';
import 'package:todo_app/screens/taskpage.dart';
import 'package:todo_app/widgets/task_card.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    final MyUser user = Provider.of<MyUser>(context);
    final FirebaseApi _firebaseApi = FirebaseApi(user.email);
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          color: Color(0xFFF6F6F6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                          top: 32.0,
                          bottom: 32.0,
                        ),
                        child: Image(
                          image: AssetImage('assets/images/logo.png'),
                        ),
                      ),
                      SizedBox(width: 20),
                      Text(
                        'Hi, ${user.name}',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Spacer(),
                      TextButton(
                        child: Text('Logout'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Expanded(
                    child: StreamBuilder(
                      stream: _firebaseApi.readTodos(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        return ScrollConfiguration(
                          behavior: NoGlowBehaviour(),
                          child: snapshot.data.length == 0
                              ? Container(
                                  child: Center(
                                    child: Text(
                                      'Your To-Do List is Empty\n Click below to add',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TodoPage(
                                              todo: snapshot.data[index],
                                              firebaseApi: _firebaseApi,
                                            ),
                                          ),
                                        );
                                      },
                                      child: TaskCardWidget(
                                        todo: snapshot.data[index],
                                        title: snapshot.data[index].title,
                                        desc: snapshot.data[index].description,
                                        onCheckBoxTapped:
                                            _firebaseApi.toggleTodo,
                                      ),
                                    );
                                  },
                                ),
                        );
                      },
                    ),
                  )
                ],
              ),
              Positioned(
                bottom: 24.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TodoPage(
                                todo: null,
                                firebaseApi: _firebaseApi,
                              )),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFF7349FE), Color(0xFF643FDB)],
                          begin: Alignment(0.0, -1.0),
                          end: Alignment(0.0, 1.0)),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Image(
                      image: AssetImage(
                        "assets/images/add_icon.png",
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
