import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_application/View/HomeScreen.dart';

class NewsDetailsScreen extends StatefulWidget {
  final String newsImage,
      newsTitle,
      newsDate,
      newsAuthor,
      newsDesc,
      newsContent,
      newsSource;

  const NewsDetailsScreen({
    Key? key,
    required this.newsImage,
    required this.newsTitle,
    required this.newsDate,
    required this.newsAuthor,
    required this.newsDesc,
    required this.newsContent,
    required this.newsSource,
  }) : super(key: key);

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
         foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Stack(
          children: [
            SizedBox(
              height: height * .45,
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  child: CachedNetworkImage(
                      imageUrl: widget.newsImage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                            child: spinKit2,
                          ),
                      errorWidget: (context, url, error) => const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                          ))),
            ),
            Container(
              height: height * .6,
              margin: EdgeInsets.only(top: height * .42),
              padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: ListView(
                children: [
                  Text(
                    widget.newsTitle,
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: Colors.black87,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.newsSource,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        widget.newsDate,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * .03,
                  ),
                  Text(
                    widget.newsDesc,
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
