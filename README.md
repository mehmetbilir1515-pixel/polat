# POLAT R&D

Android ve iOS için mobil hesaplama araçları uygulaması (Flutter).

## Hesaplama araçları (ilk sürüm)

**POLAT DECANTER 3000G** (ana ekranda ikinci sırada): dekantör modelini (S200 … SX920) seçince, 3000G için gereken devre göre arka rulman, şanzıman limitleri ve tambur dayanımı (Sb/Sf) kontrol edilir; her kart geçti/kaldı olarak gösterilir. S200, S300 ve S350 zaten 3000G'yi sağlar.

**Dekantör Kütle Denkliği** (ana ekranda ilk sırada): ürün debisi (m³/h), yoğunluk (kg/m³) ve besleme/kek/sentrat kuru katı oranlarından kek ve sentrat kütle akışlarını, polimer tüketimini (kg/tDS), yakalama verimini, günlük değerleri ve % → AKM (mg/L) dönüşümünü hesaplar. Değerler yazıldıkça sonuçlar anında güncellenir.

1. **G-Force (RCF)**: tambur iç çapı ve devirden santrifüj kuvveti
2. **Diferansiyel hız**: ana tahrik, arka tahrik, dişli kutusu oranı ve yöne göre hız farkı
3. **Debi dönüştürücü**: GPM, LPM, m³/saat, BPD
4. **Kasnak hızı**: motor devri ve kasnak çaplarından çıkış mili devri
5. **Kayış uzunluğu**: kasnak çapları ve eksen mesafesinden tahmini kayış boyu
6. **Throughput**: debi (m³/h), yoğunluk (kg/m³), katı oranı ve çalışma saatinden kuru katı (ton/gün)
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

## Paylaşım linki (Android APK + iPhone web uygulaması)

Her güncellemede **Web (GitHub Pages)** iş akışı siteyi yeniden yayınlar:

**https://mehmetbilir1515-pixel.github.io/polat/**

Tek link, telefona göre davranır:
- **Android:** sayfadaki **APK'yı indir** düğmesi `polat-rd.apk` dosyasını indirir.
- **iPhone (Safari):** **Uygulamayı aç** web uygulamasını (`/app/`) açar; Paylaş → **Ana Ekrana Ekle**.
- Bilgisayarda ikisi de görünür.

Site yapısı: `site/index.html` (paylaşım sayfası), `/app/` (Flutter web), `/polat-rd.apk`.

Bir kerelik ayar: depoda **Settings → Pages → Source** bölümü **GitHub Actions** olmalı (yapıldı).

### Şirket alan adına taşıma (ileride)

`rd.polatas.com.tr` gibi bir adres için alan adının DNS panelinde bir `CNAME` kaydı (`rd` → `mehmetbilir1515-pixel.github.io`) eklenmeli; ardından GitHub **Settings → Pages → Custom domain** alanına adres yazılır ve `pages.yml` içindeki `BASE_HREF` değeri `/app/` yapılır. Kayıt eklenmeden adres çalışmaz.

> Android APK'sı her derlemede yeni bir test anahtarıyla imzalanır. Telefonda eski sürüm varsa, yeni APK'yı kurmadan önce eskisini silmek gerekebilir. Kalıcı imza anahtarı eklenince bu sorun kalkar.

## Geliştirme (kendi bilgisayarında)

[Flutter SDK](https://docs.flutter.dev/get-started/install/windows) kurulu olmalı.

```powershell
flutter create --platforms=android,ios --org com.polat --project-name polat_rd .   # bir kez
flutter pub get
flutter test
flutter run
```

## iOS

**iOS build** iş akışı (GitHub Actions, macOS) testleri çalıştırır ve imzasız bir `.ipa` üretir. Dosya, Actions sayfasında **Artifacts** bölümündeki `polat-rd-ios-unsigned-ipa` adıyla iner.

İmzasız `.ipa` iPhone'a doğrudan kurulamaz; Apple imzası gerekir. İki yol var:
- **Ücretsiz Apple Kimliği ile (deneme):** Windows için Sideloadly gibi bir araç `.ipa` dosyasını kendi Apple Kimliğinle imzalayıp telefona kurar. Uygulama 7 gün sonra süresi dolar ve yeniden kurulması gerekir.
- **Apple Developer Program (yıllık ücretli):** TestFlight üzerinden kalıcı kurulum ve App Store yayını için gerekir.

## Katkı kuralı

Değişiklikler gönderilmeden önce sahibinin onayından geçer. Ayrıntılar için `CLAUDE.md` dosyasına bakın.
