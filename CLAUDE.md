# CLAUDE.md

Bu dosya, bu depoda çalışan yapay zekâ asistanı için kuralları içerir.

## Onay politikası

- `git commit`, `git push`, dal birleştirme veya Pull Request açma işlemlerinden ÖNCE değişiklikleri kullanıcıya göster ve açık onay al.
- Onay olmadan GitHub'a hiçbir şey gönderme.
- Dosya silme veya geçmişi yeniden yazma (force push, reset --hard) işlemlerini önce sor.

## Proje

- Uygulama adı: **POLAT R&D** — Android ve iOS için mobil hesaplama araçları uygulaması.
- Teknoloji: Flutter (Dart). Paket adı: `polat_rd`.
- İlk araç seti, santrifüj ve mekanik hesaplayıcılardır: G-Force (RCF), diferansiyel hız, debi dönüştürücü, kasnak hızı, kayış uzunluğu, throughput, kasnak boyutu.
- Kullanıcı Windows 11 kullanıyor; komut örneklerinde PowerShell uyumluluğunu gözet. Kullanıcı mümkün olduğunca fareyle ilerlemeyi tercih ediyor; terminal gerektiren adımları en aza indir.

## Yapı

- `lib/calculators/`: saf hesaplama fonksiyonları (arayüzden bağımsız, test edilebilir). Geçersiz girdide `CalculationException` fırlatır.
- `lib/models/calculator_spec.dart`: araç tanımı modelleri (girdi alanları, birimler, sonuçlar).
- `lib/calculator_specs.dart`: 7 aracın arayüz tanımları. Yeni araç = yeni hesap fonksiyonu + yeni `CalculatorSpec` + test.
- `lib/screens/`: ana ekran ve tanımdan otomatik üretilen hesaplama ekranı.
- `lib/theme.dart`: renk teması. Ana renk RAL 5004 (siyah mavi), vurgu rengi RAL 1003 (sinyal sarısı).
- `assets/icon/`: P harfi logosu (uygulama simgesi). CI, `flutter_launcher_icons` ile Android/iOS simgelerini üretir.
- Terminoloji: arayüzde "kasa" yerine **"tambur"** yazılır (G-Force aracında "Tambur iç çapı").
- `test/`: birim ve widget testleri.
- `.github/workflows/android.yml`: testleri çalıştırır ve Android APK'yı bulutta derler.
- `.github/workflows/ios.yml`: iOS sürümünü macOS'ta derler (imzasız .ipa).
- `.github/workflows/pages.yml`: GitHub Pages'e yayınlar. Kök sayfa `site/index.html` (telefona göre yönlendiren paylaşım sayfası), `/app/` Flutter web (iPhone için PWA), `/polat-rd.apk` Android APK. Adres `https://mehmetbilir1515-pixel.github.io/polat/`.
- `site/index.html`: paylaşım sayfası. Alan adı ayarı kullanıcı tarafından yapılmadıkça şirket alan adına (polatas.com.tr) dokunma; hedef adres `rd.polatas.com.tr`, DNS kaydı BT tarafından eklenecek.

## Çalışma biçimi

- Küçük, anlaşılır adımlarla ilerle; büyük değişikliklerden önce kısa bir plan sun.
- Yeni davranış eklerken ilgili testi de yaz. Test beklentilerini koddan değil, bağımsız bir hesaptan (ör. ayrı bir referans betik) türet.
- Yanıtlar ve açıklamalar Türkçe olsun; kod ve değişken adları İngilizce kalsın. Arayüz metinleri Türkçe.
- Gizli bilgileri (API anahtarı, parola, imzalama anahtarı) asla koda veya commit'e koyma.
- centrifugeco.com sitesinden yalnızca hangi araçların var olduğu ve genel girdi/çıktı mantığı referans alınır; sitenin metinleri, tasarımı veya görselleri kopyalanmaz.
- Bulut çalışma alanında Flutter SDK indirilemiyor; Dart kodu orada çalıştırılamaz. Doğrulama GitHub Actions üzerinde yapılır; Actions sonucunu kontrol etmeden "çalışıyor" deme.

## Komutlar

```powershell
flutter create --platforms=android,ios --org com.polat --project-name polat_rd .   # android/ ve ios/ klasörlerini üretir (bir kez)
flutter pub get
flutter test                  # testleri çalıştır
flutter run                   # bağlı cihaz veya emülatörde çalıştır
flutter build apk --release   # Android APK
```
