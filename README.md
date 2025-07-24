# 🎬 SinFlix - Case Study

Modern ve kullanıcı dostu bir film uygulaması. Flutter ile geliştirilmiş, Firebase entegrasyonu ile güçlendirilmiş ve clean architecture prensipleriyle tasarlanmış bir mobil uygulama.

## 📱 Uygulama Özellikleri

### 🎯 Ana Özellikler
- **Film Listesi**: Popüler filmleri görüntüleme ve arama
- **Kullanıcı Kimlik Doğrulama**: Güvenli giriş ve kayıt sistemi
- **Profil Yönetimi**: Kullanıcı profil fotoğrafı yükleme
- **Favori Filmler**: Filmleri favorilere ekleme ve yönetme
- **Çoklu Dil Desteği**: Türkçe ve İngilizce dil desteği
- **Tema Desteği**: Açık/koyu tema seçenekleri

### 🔧 Teknik Özellikler
- **Firebase Entegrasyonu**: Analytics ve Crashlytics
- **Clean Architecture**: Katmanlı mimari yapısı
- **State Management**: BLoC pattern ile durum yönetimi
- **Dependency Injection**: GetIt ile bağımlılık enjeksiyonu
- **Navigation**: GoRouter ile modern routing
- **API Integration**: RESTful API entegrasyonu
- **Local Storage**: Güvenli veri saklama

## 🛠️ Teknoloji Stack

### Frontend
- **Flutter**: 3.8.1
- **Dart**: Modern Dart syntax ve null safety

### State Management & Architecture
- **flutter_bloc**: BLoC pattern implementasyonu
- **get_it**: Dependency injection
- **injectable**: Code generation ile DI

### Navigation & Routing
- **go_router**: Modern routing çözümü

### UI & Design
- **google_fonts**: Custom font desteği
- **flutter_svg**: SVG dosya desteği
- **font_awesome_flutter**: Icon kütüphanesi
- **flutter_animate**: Animasyon desteği
- **lottie**: Lottie animasyonları

### Localization
- **easy_localization**: Çoklu dil desteği

### Storage & Security
- **shared_preferences**: Local storage
- **flutter_secure_storage**: Güvenli veri saklama

### Image & File Handling
- **image_picker**: Kamera ve galeri erişimi
- **permission_handler**: İzin yönetimi

### HTTP & API
- **dio**: HTTP client
- **retrofit**: API client generation
- **json_annotation**: JSON serialization

### Firebase Services
- **firebase_core**: Firebase temel servisleri
- **firebase_analytics**: Kullanıcı analitikleri
- **firebase_crashlytics**: Hata takibi

### Development Tools
- **logger**: Geliştirme logları
- **build_runner**: Code generation
- **flutter_lints**: Kod kalitesi

## 📁 Proje Yapısı

```
lib/
├── core/
│   ├── constants/          # Uygulama sabitleri
│   ├── di/                # Dependency injection
│   ├── routes/            # Routing konfigürasyonu
│   ├── services/          # Core servisler
│   ├── theme/             # Tema konfigürasyonu
│   └── utils/             # Yardımcı fonksiyonlar
├── features/
│   ├── auth/              # Kimlik doğrulama modülü
│   │   ├── data/          # Veri katmanı
│   │   ├── domain/        # İş mantığı katmanı
│   │   └── presentation/  # UI katmanı
│   ├── home/              # Ana sayfa modülü
│   └── profile/           # Profil modülü
├── assets/
│   ├── images/            # Görsel dosyalar
│   ├── fonts/             # Font dosyaları
│   ├── animations/        # Animasyon dosyaları
│   └── translations/      # Dil dosyaları
└── main.dart              # Uygulama giriş noktası
```

## 🚀 Kurulum

### Gereksinimler
- Flutter SDK 3.8.1+
- Dart SDK 3.8.1+
- Android Studio / VS Code
- Android SDK 23+
- iOS 12.0+ (iOS geliştirme için)
- Java 17 (Android build için)

### Adım 1: Projeyi Klonlayın
```bash
git clone <repository-url>
cd case_study
```

### Adım 2: Bağımlılıkları Yükleyin
```bash
flutter pub get
```

### Adım 3: Firebase Konfigürasyonu

#### Android
1. Firebase Console'da yeni proje oluşturun
2. Android uygulaması ekleyin (package: com.example.case_study)
3. `google-services.json` dosyasını `android/app/` klasörüne yerleştirin

#### iOS
1. Firebase Console'da iOS uygulaması ekleyin
2. `GoogleService-Info.plist` dosyasını `ios/Runner/` klasörüne yerleştirin
3. Xcode'da projeyi açın ve dosyayı "Copy Bundle Resources"a ekleyin

### Adım 4: API Konfigürasyonu
`lib/core/constants/app_constants.dart` dosyasında API URL'lerini güncelleyin:
```dart
static const String baseUrl = 'https://your-api-url.com';
```

### Adım 5: Uygulamayı Çalıştırın
```bash
flutter run
```

## 🔧 Geliştirme

### Code Generation
```bash
# Dependency injection için
flutter packages pub run build_runner build

# API client generation için
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Firebase Test
Uygulama içinde Firebase test sayfasına erişmek için:
- Home page'de sağ üstteki 🐛 ikonuna tıklayın
- Veya `/firebase-test` route'una gidin

### Linting
```bash
flutter analyze
```

## 📊 Firebase Entegrasyonu

### Analytics
- Otomatik sayfa geçiş takibi
- Custom event gönderme
- Kullanıcı davranış analizi

### Crashlytics
- Otomatik hata yakalama
- Manuel hata kaydetme
- Crash raporları

## 🌐 API Endpoints

### Authentication
- `POST /auth/login` - Kullanıcı girişi
- `POST /auth/register` - Kullanıcı kaydı
- `POST /auth/upload-photo` - Profil fotoğrafı yükleme

### Movies
- `GET /movies` - Film listesi
- `GET /movies/{id}` - Film detayı

### Profile
- `GET /profile` - Kullanıcı profili
- `PUT /profile` - Profil güncelleme

## 🎨 Tema ve Tasarım

### Renk Paleti
- **Primary**: Koyu tema odaklı
- **Secondary**: Vurgu renkleri
- **Background**: Dinamik tema desteği

### Fontlar
- **Instrument Sans**: Ana font ailesi
- **Google Fonts**: Fallback fontlar

## 📱 Platform Desteği

- ✅ Android (API 23+)
- ✅ iOS (12.0+)
- ✅ Web (Chrome, Firefox, Safari)
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🔒 Güvenlik

- JWT token tabanlı kimlik doğrulama
- Güvenli veri saklama (flutter_secure_storage)
- HTTPS API iletişimi
- Input validation ve sanitization

## 📈 Performans

- Lazy loading ile film listesi
- Image caching
- Optimized build configurations
- Memory leak prevention

## 🧪 Test

### Widget Tests
```bash
flutter test
```

### Firebase Test
- Analytics event testleri
- Crashlytics testleri
- Manual crash testleri

## 📦 Build

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Katkıda Bulunma

1. Fork yapın
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Commit yapın (`git commit -m 'Add amazing feature'`)
4. Push yapın (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## 👨‍💻 Geliştirici

**Abdulkadir** - Flutter Developer

## 📞 İletişim

- **Email**: [abdulkadircelik267@gmail.com]
- **LinkedIn**: [https://www.linkedin.com/in/abdulkadircelik1/]
- **GitHub**: [https://github.com/abdulkadircelik]

---
