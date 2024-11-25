class Category {
  String? id;
  String? imageUrl;
  String? title;
  String? description;

  Category({
    this.id,
    this.imageUrl,
    this.title,
    this.description,
  });

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        imageUrl = json['imageUrl'],
        title = json['title'],
        description = json['description'];

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "imageUrl": imageUrl,
      "title": title,
      "description": description,
    };
  }
}
