
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_application/Models/CategoriesNewsModel.dart';

import 'package:news_application/Models/NewsChannelHeadlinesModel.dart';
class NewsRepository{

  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlineApi (String newsChannel) async {
    String url = 'https://newsapi.org/v2/top-headlines?sources=$newsChannel&apiKey=d46c7c38eb3848569f3905178da6e8e1';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return NewsChannelHeadlinesModel.fromJson(body);
    }
    throw Exception("error");
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi (String category) async {
    String url = 'https://newsapi.org/v2/everything?q=$category&apiKey=d46c7c38eb3848569f3905178da6e8e1';

    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception("error");
  }
}