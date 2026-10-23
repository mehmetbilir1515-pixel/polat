# CLAUDE.md

Bu dosya, bu depoda çalışan yapay zekâ asistanı için kuralları içerir.

## Onay politikası

- `git commit`, `git push`, dal birleştirme veya Pull Request açma işlemlerinden ÖNCE değişiklikleri kullanıcıya göster ve açık onay al.
- Onay olmadan GitHub'a hiçbir şey gönderme.
- Dosya silme veya geçmişi yeniden yazma (force push, reset --hard) işlemlerini önce sor.

## Proje

- Dil: Python
- Kaynak kod: `src/`
- Testler: `tests/` (pytest)
- Kullanıcı Windows 11 kullanıyor; yol ve komut örneklerinde PowerShell uyumluluğunu gözet.

## Çalışma biçimi

- Küçük, anlaşılır adımlarla ilerle; büyük değişikliklerden önce kısa bir plan sun.
- Yeni davranış eklerken ilgili testi de yaz.
- Yanıtlar ve açıklamalar Türkçe olsun; kod ve değişken adları İngilizce kalsın.
- Gizli bilgileri (API anahtarı, parola) asla koda veya commit'e koyma; `.env` kullan ve `.gitignore`'da tut.

## Komutlar

```bash
python -m pytest        # testleri çalıştır
```
