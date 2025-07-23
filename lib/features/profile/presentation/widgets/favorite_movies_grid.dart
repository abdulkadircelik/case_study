import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../home/domain/models/movie_model.dart';

class FavoriteMoviesGrid extends StatelessWidget {
  final List<MovieModel> movies;

  const FavoriteMoviesGrid({super.key, required this.movies});

  String _getPosterUrl(String originalUrl) {
    // Eğer URL boşsa veya geçersizse placeholder kullan
    if (originalUrl.isEmpty || originalUrl == 'N/A') {
      return 'https://via.placeholder.com/400x600/1f1f1f/ffffff?text=Movie';
    }

    // IMDB poster URL'lerini düzelt
    if (originalUrl.contains('ia.media-imdb.com')) {
      // IMDB URL'lerini alternatif URL'lere çevir
      String fixedUrl = originalUrl.replaceAll(
        'ia.media-imdb.com',
        'm.media-amazon.com',
      );

      // HTTP'yi HTTPS'e çevir
      if (fixedUrl.startsWith('http://')) {
        fixedUrl = fixedUrl.replaceFirst('http://', 'https://');
      }

      return fixedUrl;
    }

    // HTTP URL'leri HTTPS'e çevir
    if (originalUrl.startsWith('http://')) {
      return originalUrl.replaceFirst('http://', 'https://');
    }

    return originalUrl;
  }

  Future<String> _getBestPosterUrl(MovieModel movie) async {
    // Önce ana poster URL'ini dene
    String posterUrl = _getPosterUrl(movie.poster);

    // Eğer poster URL'i çalışmıyorsa, Images array'inden ilkini dene
    if (posterUrl.contains('placeholder') && movie.images.isNotEmpty) {
      posterUrl = _getPosterUrl(movie.images.first);
    }

    // Eğer hala çalışmıyorsa, film adına göre özel URL'ler dene
    if (posterUrl.contains('placeholder')) {
      posterUrl = _getFallbackPosterUrl(movie.title);
    }

    return posterUrl;
  }

  String _getFallbackPosterUrl(String title) {
    // Film adına göre özel poster URL'leri
    switch (title.toLowerCase()) {
      case 'avatar':
        return 'https://m.media-amazon.com/images/M/MV5BMTYwOTEwNjAzMl5BMl5BanBnXkFtZTcwODc5MTUwMw@@._V1_SX300.jpg';
      case '300':
        return 'https://m.media-amazon.com/images/M/MV5BMjAzNTkzNjcxNl5BMl5BanBnXkFtZTYwNDA4NjE3._V1_SX300.jpg';
      case 'the avengers':
        return 'https://m.media-amazon.com/images/M/MV5BNDYxNjQyMjAtNTdiOS00NGYwLWFmNTAtNThmYjU5ZGI2YTI1XkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SX300.jpg';
      case 'the wolf of wall street':
        return 'https://m.media-amazon.com/images/M/MV5BMjIxMjgxNTk0MF5BMl5BanBnXkFtZTgwNjIyOTg2MDE@._V1_SX300.jpg';
      default:
        return 'https://via.placeholder.com/400x600/1f1f1f/ffffff?text=${Uri.encodeComponent(title)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return const Center(
        child: Text(
          'Favori film bulunamadı',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _buildMovieCard(movie, index);
      },
    );
  }

  Widget _buildMovieCard(MovieModel movie, int index) {
    return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[900],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Movie Poster
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: FutureBuilder<String>(
                    future: _getBestPosterUrl(movie),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            color: Colors.grey,
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        );
                      }

                      final posterUrl = snapshot.data ?? '';

                      return ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.network(
                          posterUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          headers: const {
                            'User-Agent':
                                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                            'Accept': 'image/webp,image/apng,image/*,*/*;q=0.8',
                            'Accept-Language': 'en-US,en;q=0.9',
                            'Cache-Control': 'no-cache',
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  topRight: Radius.circular(12),
                                ),
                                color: Colors.grey,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.movie,
                                    size: 40,
                                    color: Colors.white54,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Movie Info
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.year,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: Duration(milliseconds: index * 100))
        .slideY(begin: 0.3, duration: 300.ms);
  }
}
