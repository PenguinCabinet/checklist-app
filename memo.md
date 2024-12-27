
  /*
  void CheckList_save(Timer timer) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
        "checklist", jsonEncode(CheckList.map((e) => e.toJson()).toList()));
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String json_str = prefs.getString('checklist') ?? "[]";
    List<Map<String, dynamic>> temp = jsonDecode(json_str);
    CheckList = temp.map((e) => Checklist_data_t.fromJson(e)).toList();
  }
  */