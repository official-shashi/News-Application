
import 'package:news_application/Models/CategoriesNewsModel.dart';
import 'package:news_application/Models/NewsChannelHeadlinesModel.dart';
import 'package:news_application/Repository/NewsRepository.dart';

class NewsViewModel{
  final repo = NewsRepository();

  Future<NewsChannelHeadlinesModel> fetchNewsChannelHeadlineApi (String newsChannel) async{
    final response = await repo.fetchNewsChannelHeadlineApi(newsChannel);
    return response;
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi (String category) async{
    final response = await repo.fetchCategoriesNewsApi(category);
    return response;
  }

}