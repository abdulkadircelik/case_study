import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:go_router/go_router.dart';

class FirebaseTestPage extends StatelessWidget {
  const FirebaseTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Test'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          onPressed: () {
            context.go('/');
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Firebase Entegrasyon Test Sayfası',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Analytics Test Butonları
            const Text(
              'Analytics Test',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                FirebaseAnalytics.instance.logEvent(
                  name: 'test_button_clicked',
                  parameters: {
                    'button_name': 'custom_event',
                    'timestamp': DateTime.now().toIso8601String(),
                  },
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Custom event gönderildi!')),
                );
              },
              child: const Text('Custom Event Gönder'),
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () {
                FirebaseAnalytics.instance.logEvent(
                  name: 'user_action',
                  parameters: {
                    'action_type': 'test_action',
                    'user_id': 'test_user_123',
                  },
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('User action event gönderildi!'),
                  ),
                );
              },
              child: const Text('User Action Event Gönder'),
            ),

            const SizedBox(height: 24),

            // Crashlytics Test Butonları
            const Text(
              'Crashlytics Test',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                FirebaseCrashlytics.instance.log('Test log mesajı');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Test log mesajı gönderildi!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Test Log Mesajı Gönder'),
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () {
                FirebaseCrashlytics.instance.recordError(
                  'Test error mesajı',
                  StackTrace.current,
                  reason: 'Test amaçlı hata',
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Test error kaydedildi!')),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Test Error Kaydet'),
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: () {
                FirebaseCrashlytics.instance.crash();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Uygulamayı Çökert (Test)'),
            ),

            const SizedBox(height: 24),

            // Bilgi Kartı
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Test Sonuçları:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('• Analytics eventleri Firebase Console\'da görünecek'),
                  Text(
                    '• Crashlytics logları ve hatalar Crashlytics panelinde görünecek',
                  ),
                  Text(
                    '• Uygulama çökerse Crashlytics\'te crash raporu oluşacak',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
