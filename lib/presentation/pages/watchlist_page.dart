import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WatchlistPage extends StatelessWidget {
  static const ROUTE_NAME = '/watchlist';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Watchlist'),
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pushReplacementNamed(
            context,
            HomeMoviePage.ROUTE_NAME,
          ),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                WatchlistMoviesPage.ROUTE_NAME,
              ),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: kDavysGrey, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Movies',
                    style: GoogleFonts.poppins(fontSize: 25),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => Navigator.pushNamed(
                context,
                WatchlistTvSeriesPage.ROUTE_NAME,
              ),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: kDavysGrey, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Tv Series',
                    style: GoogleFonts.poppins(fontSize: 25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
