class PhotoModel{

  late String title, url;
  late int id;

  PhotoModel({
    required this.title,required this.url,required this.id
  });
}

class ServerModel {
  ServerModel({
      this.userId, 
      this.id, 
      this.title, 
      this.body,});

  ServerModel.fromJson(dynamic json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }
  int? userId;
  int? id;
  String? title;
  String? body;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userId'] = userId;
    map['id'] = id;
    map['title'] = title;
    map['body'] = body;
    return map;
   }

}