class Marketing {
  String? id;
  String? title;

  Marketing({
    this.id,
    this.title,
  });

  Marketing.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
    };
  }
}
