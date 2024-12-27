class Checklist_data_t {
  String title = "";
  String body = "";
  Checklist_data_t(this.title, this.body);

  Checklist_data_t.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        body = json['body'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'body': body,
      };
}
