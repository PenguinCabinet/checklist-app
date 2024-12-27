import 'package:flutter/material.dart';
import 'common.dart';

class CheckListRun extends StatefulWidget {
  final Checklist_data_t data;
  CheckListRun({super.key, required this.data});

  @override
  _CheckListRun createState() => _CheckListRun();
}

class _CheckListRun extends State<CheckListRun> {
  _CheckListRun();
  List<String> checklist_data = [];
  List<bool> checklist_flag = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checklist_data = widget.data.body.split("\n");
    checklist_flag = checklist_data.map((e) => false).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(checklist_flag.every((e) => e)
              ? "✅ " + widget.data.title
              : widget.data.title),
        ),
        body: ListView.builder(
            itemCount: checklist_data.length,
            itemBuilder: (context, i) {
              return Card(
                child: CheckboxListTile(
                  activeColor: Colors.blue,
                  title: Text(checklist_data[i]),
                  //subtitle: Text(widget.data.body),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: checklist_flag[i],
                  onChanged: (value) {
                    setState(() {
                      checklist_flag[i] = value!;
                    });
                  },
                ),
              );
            }));
  }
}
