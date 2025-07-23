import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/models/movie_model.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;
  final VoidCallback onFavoriteToggle;
  final VoidCallback? onMoreDetails;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onFavoriteToggle,
    this.onMoreDetails,
  });

  String _getPosterUrl(String originalUrl) {
    // Eğer URL boşsa veya geçersizse placeholder kullan
    if (originalUrl.isEmpty || originalUrl == 'N/A') {
      return 'https://via.placeholder.com/400x600/1f1f1f/ffffff?text=${Uri.encodeComponent(movie.title)}';
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
    return Container(
      height: MediaQuery.of(context).size.height, // Tam ekran yükseklik
      decoration: const BoxDecoration(color: Colors.black),
      child: Stack(
        children: [
          // Movie Image - Tam ekran
          FutureBuilder<String>(
            future: _getBestPosterUrl(movie),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  color: Colors.grey[800],
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }

              final posterUrl = snapshot.data ?? '';

              return Image.network(
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
                    color: Colors.grey[800],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.movie,
                          size: 80,
                          color: Colors.white54,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          movie.title,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          // Gradient Overlay - Daha yumuşak
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.9),
                ],
                stops: const [0.0, 0.4, 0.7, 0.85, 1.0],
              ),
            ),
          ),

          // Favorite Button - Sağda, ortanın biraz aşağısında
          Positioned(
            bottom:
                MediaQuery.of(context).size.height *
                0.35, // Ekranın %35'i yukarıda
            right: 20,
            child:
                GestureDetector(
                      onTap: onFavoriteToggle,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          movie.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: movie.isFavorite ? Colors.red : Colors.white,
                          size: 24,
                        ),
                      ),
                    )
                    .animate(target: movie.isFavorite ? 1 : 0)
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1.0, 1.0),
                    )
                    .then()
                    .shake(duration: 200.ms),
          ),

          // Movie Info - Alt kısım
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(0.95),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo and Title Row
                  Row(
                    children: [
                      // Logo - Daha büyük
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'N',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Title - Daha büyük
                      Expanded(
                        child: Text(
                          movie.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                offset: Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Description with "Daha Fazlası" button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          movie.plot,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            height: 1.5,
                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // "Daha Fazlası" button
                      GestureDetector(
                        onTap: onMoreDetails,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Daha Fazlası',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
