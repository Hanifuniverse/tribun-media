import 'dart:convert';

NewsResponse newsResponseFromJson(String str) => NewsResponse.fromJson(json.decode(str));
String newsResponseToJson(NewsResponse data) => json.encode(data.toJson());

class NewsResponse {
  final bool success;
  final String message;
  final Data data;

  NewsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) => NewsResponse(
    success: json["success"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  final List<Article> articles;
  final Pagination pagination;

  Data({
    required this.articles,
    required this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    articles: List<Article>.from(json["articles"].map((x) => Article.fromJson(x))),
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
    "pagination": pagination.toJson(),
  };
}

class Article {
  final String id;
  final String title;
  final String category;
  final String publishedAt;
  final String readTime;
  final String imageUrl;
  final bool isTrending;
  final List<String> tags;
  final String content;
  final Author author;
  final DateTime createdAt;
  final DateTime updatedAt;

  Article({
    required this.id,
    required this.title,
    required this.category,
    required this.publishedAt,
    required this.readTime,
    required this.imageUrl,
    required this.isTrending,
    required this.tags,
    required this.content,
    required this.author,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
    id: json["id"],
    title: json["title"],
    category: json["category"],
    publishedAt: json["publishedAt"],
    readTime: json["readTime"],
    imageUrl: json["imageUrl"],
    isTrending: json["isTrending"],
    tags: List<String>.from(json["tags"].map((x) => x)),
    content: json["content"],
    author: Author.fromJson(json["author"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "category": category,
    "publishedAt": publishedAt,
    "readTime": readTime,
    "imageUrl": imageUrl,
    "isTrending": isTrending,
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "content": content,
    "author": author.toJson(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class Author {
  final String name;
  final String title;
  final String avatar;

  Author({
    required this.name,
    required this.title,
    required this.avatar,
  });

  factory Author.fromJson(Map<String, dynamic> json) => Author(
    name: json["name"],
    title: json["title"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "title": title,
    "avatar": avatar,
  };
}

class Pagination {
  final int page;
  final int limit;
  final int total;
  final bool hasMore;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.hasMore,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    page: json["page"],
    limit: json["limit"],
    total: json["total"],
    hasMore: json["hasMore"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "total": total,
    "hasMore": hasMore,
  };
}