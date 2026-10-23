# POLAT R&D

Android ve iOS için mobil hesaplama araçları uygulaması (Flutter).

## Hesaplama araçları (ilk sürüm)

1. **G-Force (RCF)**: kasa çapı ve devirden santrifüj kuvveti
2. **Diferansiyel hız**: ana tahrik, arka tahrik, dişli kutusu oranı ve yöne göre hız farkı
3. **Debi dönüştürücü**: GPM, LPM, m³/saat, BPD
4. **Kasnak hızı**: motor devri ve kasnak çaplarından çıkış mili devri
5. **Kayış uzunluğu**: kasnak çapları ve eksen mesafesinden tahmini kayış boyu
6. **Throughput**: debi, yoğunluk, katı oranı ve çalışma saatinden kuru katı (ton/gün)
7. **Kasnak boyutu**: hedef devir için gereken kasnak çapı

> Sonuçlar mühendislik tahminidir. Ekipman değişikliği veya sipariş öncesinde üretici/tedarikçi bilgileriyle doğrulayın.

## Klasör yapısı

```
polat/
├── lib/
│   ├── calculators/        # Saf hesaplama fonksiyonları
│   ├── models/             # Araç tanım modelleri
│   ├── screens/            # Ana ekran ve hesaplama ekranı
│   ├── calculator_specs.dart
│   ├── format.dart
│   ├── app.dart
│   └── main.dart
├── test/                   # Birim ve widget testleri
├── .github/workflows/      # Android APK derleme (GitHub Actions)
├── pubspec.yaml
├── CLAUDE.md               # Yapay zekâ asistanı için çalışma kuralları
└── README.md
```

## Android uygulamasını indirme (terminalsiz)

1. Depoda **Actions** sekmesini aç.
2. **Android build** iş akışının son başarılı çalışmasını seç.
3. Sayfanın altındaki **Artifacts** bölümünden `polat-rd-android-apk` dosyasını indir.
4. İndirilen ZIP'in içindeki `app-release.apk` dosyasını Android telefona kopyalayıp aç (bilinmeyen kaynaklardan kuruluma izin gerekebilir).

## Geliştirme (kendi bilgisayarında)

[Flutter SDK](https://docs.flutter.dev/get-started/install/windows) kurulu olmalı.

```powershell
flutter create --platforms=android,ios --org com.polat --project-name polat_rd .   # bir kez
flutter pub get
flutter test
flutter run
```

## iOS

iOS uygulaması için derleme ve cihaza kurulum, Apple'ın ücretli geliştirici hesabını ve imzalama ayarlarını gerektirir. Bu aşama henüz kurulmadı; Android sürümü çalıştıktan sonra eklenecek.

## Katkı kuralı

Değişiklikler gönderilmeden önce sahibinin onayından geçer. Ayrıntılar için `CLAUDE.md` dosyasına bakın.
