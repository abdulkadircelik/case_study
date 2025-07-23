import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../../../../core/di/injection.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/favorite_movies_grid.dart';
import '../widgets/limited_offer_button.dart';
import '../../../home/presentation/widgets/bottom_navigation_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileBloc _profileBloc;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _profileBloc = getIt<ProfileBloc>();
    _profileBloc.add(const LoadUserProfile());
  }

  @override
  void dispose() {
    _profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _profileBloc,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileLoaded && state.favoriteMovies == null) {
                // User profile loaded but favorite movies not loaded yet
                _profileBloc.add(const LoadFavoriteMovies());
              }
            },
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (state is ProfileError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${'profile.error_occurred'.tr()}: ${state.message}',
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            _profileBloc.add(const LoadUserProfile());
                          },
                          child: Text('profile.retry'.tr()),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ProfileLoaded) {
                  return Column(
                    children: [
                      // Top Navigation Bar
                      _buildTopNavigationBar(),

                      // Profile Header
                      ProfileHeader(
                        userName: state.userProfile.name,
                        userId: state.userProfile.userId,
                        profileImage: state.userProfile.profileImage,
                        userEmail: state.userProfile.email,
                        onAddPhoto: _onAddPhoto,
                      ),

                      const SizedBox(height: 24),

                      // Favorite Movies Section
                      Expanded(child: _buildFavoriteMoviesSection(state)),
                    ],
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
      ),
    );
  }

  Widget _buildTopNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Title
          Expanded(
            child: Text(
              'profile.profile_detail'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Limited Offer Button
          const LimitedOfferButton(),
        ],
      ),
    );
  }

  Widget _buildFavoriteMoviesSection(ProfileLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'profile.favorite_movies'.tr(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // Movies Grid
          Expanded(
            child: state.favoriteMovies != null
                ? FavoriteMoviesGrid(movies: state.favoriteMovies!.data.movies)
                : Center(
                    child: Text(
                      'profile.no_favorite_movies'.tr(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _onAddPhoto() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'profile.select_photo'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPhotoOption(
                  icon: Icons.camera_alt,
                  label: 'profile.camera'.tr(),
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                _buildPhotoOption(
                  icon: Icons.photo_library,
                  label: 'profile.gallery'.tr(),
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'profile.cancel'.tr(),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (image != null) {
        await _uploadImage(image);
      }
    } catch (e) {
      _showErrorSnackBar('profile.photo_upload_error'.tr());
    }
  }

  Future<void> _uploadImage(XFile image) async {
    try {
      // Show loading
      _showLoadingSnackBar('Fotoğraf yükleniyor...');

      // Create FormData
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          image.path,
          filename: 'profile_photo.jpg',
        ),
      });

      // Upload photo
      _profileBloc.add(UploadProfilePhoto(formData));
    } catch (e) {
      _showErrorSnackBar('profile.photo_upload_error'.tr());
    }
  }

  void _showLoadingSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Text(message),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
