import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'common.dart';
import 'CheckListRun.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CheckList',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'CheckList'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class CheckListEdit extends StatelessWidget {
  CheckListEdit(this.data, this.save_func);
  Checklist_data_t data;
  Function(Checklist_data_t) save_func;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit'),
        ),
        body: Column(children: [
          const SizedBox(height: 10),
          TextField(
            controller: TextEditingController(text: data.title),
            onChanged: (text) {
              data.title = text;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            initialValue: data.body,
            onChanged: (text) {
              this.data.body = text;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.deepPurple,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  this.save_func(this.data);
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.save),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurple[50],
                ),
              ))
        ]));
  }
}

class CheckListPreview extends StatelessWidget {
  final Checklist_data_t data;
  final VoidCallback? delete_func;
  final Function(Checklist_data_t) edit_save_func;
  const CheckListPreview(
      {Key? key,
      required this.data,
      required this.delete_func,
      required this.edit_save_func})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckListRun(data: data),
              fullscreenDialog: true,
            ),
          );
        },
        child: Card(
            child: Center(
                child: Column(children: [
          Text(
            this.data.title,
            style: TextStyle(fontSize: 30),
          ),
          const SizedBox(height: 60),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            TextButton(
              onPressed: delete_func,
              child: const Icon(Icons.delete),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CheckListEdit(this.data, this.edit_save_func),
                    fullscreenDialog: true,
                  ),
                );
              },
              child: const Icon(Icons.edit),
            ),
            /*
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckListRun(data: data),
                    fullscreenDialog: true,
                  ),
                );
              },
              child: const Icon(Icons.check_box),
            )
            */
          ]),
        ]))));
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<Checklist_data_t> CheckList = [];
  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), CheckList_save);
  }

  void CheckList_save(Timer timer) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        "checklist", jsonEncode(CheckList.map((e) => e.toJson()).toList()));
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String json_str = prefs.getString("checklist") ?? "[]";
    List<dynamic> temp = jsonDecode(json_str);
    setState(() {
      CheckList = temp.map((e) => Checklist_data_t.fromJson(e)).toList();
    });
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      CheckList.add(Checklist_data_t("New CheckList", "Task1\nTask2"));
    });
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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView.builder(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          itemCount: CheckList.length,
          itemBuilder: (context, i) {
            return CheckListPreview(
              data: CheckList[i],
              delete_func: () {
                // Remove the item from the data source.
                setState(() {
                  CheckList.removeAt(i);
                });
              },
              edit_save_func: (data) {
                setState(() {
                  CheckList[i] = Checklist_data_t(data.title, data.body);
                });
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
