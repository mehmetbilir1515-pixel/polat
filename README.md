# polat

Kişisel yapay zekâ destekli yazılım geliştirme projesi (Python).

## Durum

Başlangıç aşaması. Proje amacı ve kapsamı henüz tanımlanmadı.

## Klasör yapısı

```
polat/
├── src/        # Uygulama kodu
├── tests/      # Testler
├── CLAUDE.md   # Yapay zekâ asistanı için çalışma kuralları
└── README.md
```

## Kurulum

```bash
python -m venv .venv
# Windows (PowerShell):
.venv\Scripts\Activate.ps1
# Windows (cmd):
.venv\Scripts\activate.bat
pip install -e ".[dev]"
```

> Not: `pyproject.toml` henüz yok. Proje bağımlılıkları belli olunca eklenecek.

## Testleri çalıştırma

```bash
python -m pytest
```

## Katkı kuralı

Değişiklikler gönderilmeden önce sahibinin onayından geçer. Ayrıntılar için `CLAUDE.md` dosyasına bakın.
