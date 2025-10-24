# 🧱 SaaS Database Migration (Bash + PostgreSQL)

Proyek ini adalah sistem migrasi database sederhana untuk aplikasi SaaS yang mendukung multi-tenant dan role-based access control (RBAC).

## 🚀 Fitur Utama
- Membuat file migrasi baru otomatis
- Menjalankan migrasi SQL yang belum dijalankan
- Menyimpan riwayat migrasi di tabel schema_migrations
- Struktur database mendukung multi-tenant & role base user

## 🗂️ Struktur Folder
```
saas-database/
├── migrate.sh
├── .env
├── migrations/
├── seeds/
├── backups/
├── scripts/
├── logs/
├── README.md
└── .gitignore
```

## ⚙️ Setup
1. Pastikan PostgreSQL dan psql sudah terpasang.
2. Isi konfigurasi `.env`:
```
DB_NAME=saas_app
DB_USER=postgres
DB_PASS=password123
DB_HOST=localhost
DB_PORT=5432
```
3. Jalankan script:
```
chmod +x migrate.sh
./migrate.sh
```

## 💾 Tips
- Setiap perubahan struktur database → buat file migrasi baru.
- Jangan ubah migrasi lama.
- Semua migrasi tercatat otomatis di `schema_migrations`.
