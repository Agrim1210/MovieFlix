import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart' as http;

const apiKey = 'c7a37ce9f0e2cc18f536e7a3ac6d3768';

class MovieView extends StatefulWidget {
  final String poster;
  final String title;
  final String overview;
  final double rating;
  final int id;
  final String origin;
  final String original;
  MovieView({
    @required this.poster,
    @required this.title,
    @required this.overview,
    @required this.rating,
    @required this.id,
    @required this.origin,
    @required this.original,
  });
  @override
  _MovieViewState createState() => _MovieViewState();
}

class _MovieViewState extends State<MovieView> {
  getSimilarMovies() async {
    var url =
        'https://api.themoviedb.org/3/movie/${widget.id}/similar?api_key=$apiKey&language=en-US&page=1';
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    List<SimilarMovie> genreList = List<SimilarMovie>();
    for (var cinema in result['results']) {
      SimilarMovie movies = SimilarMovie(
        poster: cinema['poster_path'],
      );

      genreList.add(movies);
    }

    return genreList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            ClipPath(
              clipper: OvalBottomBorderClipper(),
              child: Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                child: Hero(
                  tag: widget.poster,
                  child: Image(
                    image: NetworkImage(
                        'https://image.tmdb.org/t/p/w500${widget.poster}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.video_library),
                      Text(
                        widget.title,
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                      Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ],
                  ),
                SmoothStarRating(
                  isReadOnly: false,
                  size: 45,
                  color: Colors.yellow,
                  borderColor: Colors.black54,
                  onRated: (rating) {
                    setState(() {
                      print(rating);
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'OverView',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.overview,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Container(
              
              height: 200,
              child: FutureBuilder(
                future: getSimilarMovies(),
                builder: (BuildContext context, dataSnapshot) {
                  if (!dataSnapshot.hasData) {
                    return Text('Loading');
                  }
                  return ListView.builder(
                    itemCount: dataSnapshot.data.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.all(10),
                          height: 200,
                          child: Image(
                            image: NetworkImage(
                              'https://image.tmdb.org/t/p/w500${dataSnapshot.data[index].poster}',
                            ),fit: BoxFit.cover,
                          ),
                        );
                      });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// RatingBar(
//                   // allowHalfRating: true,
//                   itemCount: 5,
//                   itemSize: 45,
//                   initialRating: (widget.rating),
//                   onRatingUpdate: (rating) {
//                     print(rating);
//                   },
//                   itemBuilder: (BuildContext context, _) {
//                     return Icon(
//                       Icons.star,
//                       color: Colors.yellow,
//                     );
//                   },
//                 ),
class SimilarMovie {
  final String poster;
  SimilarMovie({this.poster});
}
