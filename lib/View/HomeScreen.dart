
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_application/Models/CategoriesNewsModel.dart';
import 'package:news_application/Models/NewsChannelHeadlinesModel.dart';
import 'package:news_application/View/NewsDetailsScreen.dart';
import 'package:news_application/View/NoInternetScreen.dart';
import 'package:news_application/View_Model/NewsViewModel.dart';
import 'package:news_application/View/CategoryScreen.dart';

import '../Utils/network_utils.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList { bbcNews, india, timesOfIndia, reuters, cnn, theHindu }

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');
  FilterList? selectMenu;
  String name = 'the-times-of-india';

List<ConnectivityResult> connectionStatus = [];
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
    NetworkUtils.checkInternetConnectivity().then((result) {
      setState(() {
        connectionStatus = result;
      });
    });
    _connectivity.onConnectivityChanged.listen((result) {
      setState(() {
        connectionStatus = result;
      });
    });
  }


  
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
 if (connectionStatus.isNotEmpty && connectionStatus[0] == ConnectivityResult.none) {
      return NoInternetScreen();
    } else {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoryScreen(),
                  ));
            },
            icon: Image.asset(
              "images/category_icon.png",
              width: 25,
              height: 25,
            )),
        title: Text(
          "News",
          style: GoogleFonts.poppins(
              fontSize: 24, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            initialValue: selectMenu,
            onSelected: (FilterList item) {
              if (FilterList.timesOfIndia.name == item.name) {
                name = 'the-times-of-india';
              }
              if (FilterList.theHindu.name == item.name) {
                name = 'the-hindu';
              }
              if (FilterList.india.name == item.name) {
                name = 'google-news-in';
              }
              if (FilterList.bbcNews.name == item.name) {
                name = 'bbc-news';
              }
              if (FilterList.cnn.name == item.name) {
                name = 'cnn';
              }

              setState(() {
                selectMenu = item;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
              const PopupMenuItem<FilterList>(
                value: FilterList.timesOfIndia,
                child: Text('Times Of India '),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.theHindu,
                child: Text('The Hindu'),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.india,
                child: Text('Google India News'),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.bbcNews,
                child: Text('BBC News'),
              ),
              const PopupMenuItem<FilterList>(
                value: FilterList.cnn,
                child: Text('CNN News'),
              ),
            ],
          )
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * .55,
              width: width,
              child: FutureBuilder<NewsChannelHeadlinesModel>(
                  future: newsViewModel.fetchNewsChannelHeadlineApi(name),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SpinKitCircle(
                          size: 40,
                          color: Colors.orange,
                        ),
                      );
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          DateTime dateTime = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewsDetailsScreen(
                                          newsImage: snapshot
                                              .data!.articles![index].urlToImage
                                              .toString(),
                                          newsTitle: snapshot.data!.articles![index].title
                                              .toString(),
                                          newsDate: format.format(dateTime),
                                          newsAuthor: snapshot.data!.articles![index].author
                                              .toString(),
                                          newsDesc: snapshot.data!
                                              .articles![index].description
                                              .toString(),
                                          newsContent: snapshot
                                              .data!.articles![index].content
                                              .toString(),
                                          newsSource: snapshot.data!
                                              .articles![index].source!.name
                                              .toString())));
                            },
                            child: SizedBox(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: height * 0.6,
                                    width: width * .9,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width * .02,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          child: spinKit2,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                              height: height * 0.6,
                                              width: width * .9,
                                              color: Colors.grey.shade200,
                                              child: Icon(
                                                Icons.error_outline,
                                                color: Colors.red,
                                              ),
                                            ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    child: Card(
                                      elevation: 5,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(15),
                                        alignment: Alignment.bottomCenter,
                                        height: height * .22,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: width * 0.7,
                                              child: Text(
                                                snapshot.data!.articles![index]
                                                    .title
                                                    .toString(),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                            const Spacer(),
                                            SizedBox(
                                              width: width * 0.7,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot
                                                        .data!
                                                        .articles![index]
                                                        .source!
                                                        .name
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  Text(
                                                    format.format(dateTime),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              child: FutureBuilder<CategoriesNewsModel>(
                  future: newsViewModel.fetchCategoriesNewsApi('General'),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SpinKitCircle(
                          size: 40,
                          color: Colors.orange,
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          DateTime dateTime = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NewsDetailsScreen(
                                          newsImage: snapshot
                                              .data!.articles![index].urlToImage
                                              .toString(),
                                          newsTitle: snapshot.data!.articles![index].title
                                              .toString(),
                                          newsDate: format.format(dateTime),
                                          newsAuthor: snapshot.data!.articles![index].author
                                              .toString(),
                                          newsDesc: snapshot.data!
                                              .articles![index].description
                                              .toString(),
                                          newsContent: snapshot
                                              .data!.articles![index].content
                                              .toString(),
                                          newsSource: snapshot.data!
                                              .articles![index].source!.name
                                              .toString())));
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot
                                              .data!.articles![index].urlToImage
                                              .toString() ??
                                          '',
                                      fit: BoxFit.cover,
                                      height: height * .18,
                                      width: width * .3,
                                      placeholder: (context, url) => Container(
                                        child: spinKit2,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        height: height * .18,
                                        width: width * .3,
                                        color: Colors.grey.shade200,
                                        child: Icon(
                                          Icons.error_outline,
                                          color: Colors.red,
                                        ),
                                      ),
                                      fadeInDuration:
                                          const Duration(milliseconds: 500),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    height: height * .15,
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Column(
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                          maxLines: 3,
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                snapshot.data!.articles![index]
                                                    .source!.name
                                                    .toString(),
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Text(
                                              format.format(dateTime),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
    }
  }
}

const spinKit2 = SpinKitFadingCircle(
  color: Colors.amber,
  size: 50,
);
