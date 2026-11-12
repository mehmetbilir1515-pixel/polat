# POLAT R&D

Android ve iOS için mobil hesaplama araçları uygulaması (Flutter).

## Ana ekran sırası

1. Dekantör Model Değerleri
2. Diferansiyel Hız Hesaplayıcı
3. Dekantör Şanzıman Motor Bilgisi
4. Şanzıman Tork ve Yağlama Bilgisi
5. G-Force (RCF) Hesaplayıcı
6. Dekantör Motor Dönüş Yönü
7. Kayış Uzunluğu Hesaplayıcı
8. Kasnak Hesaplayıcı (kasnak boyutu + kasnak hızı)
9. Dekantör 3000G Verileri
10. Dekantör Yağlama Bilgisi
11. Dekantör Kütle Denkliği
12. Kuru Katı Madde Hesaplayıcı
13. Debi Dönüştürücü

## Hesaplama araçları (ilk sürüm)

**Dekantör 3000G Verileri**: dekantör modelini (S200 … SX920) seçince, 3000G için gereken devre göre arka rulman, şanzıman limitleri ve tambur dayanımı (Sb/Sf) kontrol edilir; her kart geçti/kaldı olarak gösterilir. S200, S300 ve S350 zaten 3000G'yi sağlar.

**Dekantör Yağlama Bilgisi**: önce **Main Bearing** veya **Helezon Rulmanı** seçilir. Helezon Rulmanı'nda **Endüstriyel** ya da **Zeytinyağı** dekantörü, ardından model seçilir; yağ miktarı (g), basım sayısı, rulman tipi/kodu ve ölçüleri gösterilir, "SKF'te Ara" düğmesi SKF sitesinde rulman tipini arar. Main Bearing verisi henüz eklenmedi.

**Dekantör Motor Dönüş Yönü**: model, şanzıman tipi ve motor tipi (ana / helezon) süzgeçleriyle dönüş yönü talimatını (AG-TL-09 Rev.04) gösterir; "SAAT YÖNÜ" yeşil, "SAAT YÖNÜ TERSİ" kırmızı rozetle belirtilir. Süzgeçler "Tümü" olabilir, "Filtreleri Temizle" düğmesi hepsini sıfırlar.

**Dekantör Şanzıman Motor Bilgisi**: Excel'deki "Konfigürasyon" sayfasından; **seri kodu ve tambur çapı** seçilince tambur/helezon motor gücü ve devri, şanzıman tipi ve torku, tambur konik açısı, kasnak ölçüleri ve 50 Hz devirleri gösterilir. Bir seçim için birden çok yapılandırma varsa (ör. S470: 13) hepsi ayrı kart olarak listelenir.

**Şanzıman Tork ve Yağlama Bilgisi**: şanzıman tipini (ZS612/87 … DESCH ZG50) seçince maksimum tork dayanımı (Nm), yağ bilgisi (Gres / Sıvı), yağ miktarı (gres için kg, sıvı için L) ve gres ile sıvı yağ kodları görünür; 28 şanzıman. Ekranın altında kullanıcının "Teknik Kılavuz ve Yağlayıcılar" HTML'inden alınan kılavuz bulunur: yağ banyosu ile yağlama (Şekil 2), gres yağlama (Şek. 6), önerilen yağlayıcılar (sıcaklık tablosu, mineral/sentetik yağ ve gres tipleri).

**Dekantör Model Değerleri**: modeli seçince maksimum çalışma devri, maksimum gövde devri, hidrolik kapasite (m³/h), katı çıkış çapı ve helezon boru çapı (mm) görünür. S470, S530, S570 ve SX650'de 10° ve 15° yapıların çapları aynı model girişinde birlikte gösterilir (S670'te yalnızca 10°). Modeller: S200, S300, S350, S430, S470, S530, S570, SX650, S670.

**Dekantör Kütle Denkliği**: ürün debisi (m³/h), yoğunluk (kg/m³) ve besleme/kek/sentrat kuru katı oranlarından kek ve sentrat kütle akışlarını, polimer tüketimini (kg/tDS), yakalama verimini, günlük değerleri ve % → AKM (mg/L) dönüşümünü hesaplar. Değerler yazıldıkça sonuçlar anında güncellenir.

- **G-Force (RCF)**: iki modlu. "Santrifüj kuvvetini hesapla": tambur iç çapı ve devirden santrifüj kuvveti. "Devri hesapla": tambur iç çapı ve hedef santrifüj kuvvetinden (g) gereken devir
- **Diferansiyel hız**: iki modlu. "Diferansiyel hızı hesapla": tambur devri, helezon devri, dişli kutusu oranı ve şanzıman tipine (İleri (ZS) / Geri (ZSPN)) göre hız farkı. "Helezon devrini hesapla": tambur devri, hedef diferansiyel hız, oran ve şanzıman tipinden gereken helezon devri (İleri (ZS): tambur − fark·oran; Geri (ZSPN): fark·oran − tambur; sonuç negatifse hata verir)
- **Debi dönüştürücü**: m³/h (varsayılan), m³/dk, m³/s, m³/gün, L/dk, L/s, L/h, GPM, GPH, GPD, BPD, CFM ve ft³/h arasında çeviri
- **Kasnak hesaplayıcı**: iki modlu. "Kasnak boyutunu hesapla": hedef devir için gereken kasnak çapı. "Kasnak hızını hesapla": motor devri ve kasnak çaplarından çıkış mili devri
- **Kayış uzunluğu**: kasnak çapları ve eksen mesafesinden tahmini kayış boyu
- **Kuru Katı Madde Hesaplayıcı** (eski adı Santrifüj Throughput): debi (m³/h), yoğunluk (kg/m³), katı oranı ve çalışma saatinden kuru katı (ton/gün)

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
