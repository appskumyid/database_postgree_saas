#!/bin/bash
# =============================================
# Simple SaaS Database Migration Script (PostgreSQL)
# =============================================

if [ -f .env ]; then
  export $(grep -v '^#' .env | xargs)
fi

DB_NAME=${DB_NAME:-saas_app}
DB_USER=${DB_USER:-postgres}
DB_PASS=${DB_PASS:-password123}
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}
MIGRATIONS_DIR="./migrations"

mkdir -p "$MIGRATIONS_DIR"

run_sql() {
  local sql="$1"
  PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -v ON_ERROR_STOP=1 -c "$sql"
}

create_schema_table() {
  run_sql "CREATE TABLE IF NOT EXISTS schema_migrations (
    id SERIAL PRIMARY KEY,
    filename VARCHAR(255) UNIQUE NOT NULL,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );"
}

create_migration() {
  echo "Masukkan nama migrasi (contoh: add_job_title_to_users):"
  read NAME
  TIMESTAMP=$(date +%Y%m%d_%H%M%S)
  FILE="$MIGRATIONS_DIR/${TIMESTAMP}_${NAME}.sql"

  cat <<EOF > $FILE
-- =====================================
-- Migration: $NAME
-- Created: $(date)
-- =====================================

BEGIN;

-- Tambahkan SQL kamu di bawah ini:
-- Contoh:
-- ALTER TABLE users ADD COLUMN job_title VARCHAR(100);

COMMIT;
EOF

  echo "✅ File migrasi dibuat: $FILE"
}

run_migrations() {
  create_schema_table

  echo "🔍 Mengecek migrasi yang belum dijalankan..."
  for FILE in $(ls $MIGRATIONS_DIR/*.sql | sort); do
    FILENAME=$(basename "$FILE")
    APPLIED=$(PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c "SELECT COUNT(*) FROM schema_migrations WHERE filename = '$FILENAME';" | xargs)
    if [ "$APPLIED" = "0" ]; then
      echo "🚀 Menjalankan migrasi: $FILENAME"
      if PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -v ON_ERROR_STOP=1 -f "$FILE"; then
        run_sql "INSERT INTO schema_migrations (filename) VALUES ('$FILENAME');"
        echo "✅ Sukses: $FILENAME"
      else
        echo "❌ Gagal menjalankan migrasi: $FILENAME"
        exit 1
      fi
    else
      echo "⏩ Sudah dijalankan: $FILENAME"
    fi
  done
  echo "🎉 Semua migrasi terbaru telah dijalankan!"
}

echo "==============================================="
echo "🧱 SaaS Database Migration Tool"
echo "==============================================="
echo "1) Buat migrasi baru"
echo "2) Jalankan semua migrasi baru"
echo "3) Keluar"
echo "==============================================="
read -p "Pilih opsi (1/2/3): " CHOICE

case $CHOICE in
  1) create_migration ;;
  2) run_migrations ;;
  3) echo "Keluar..." ; exit 0 ;;
  *) echo "Pilihan tidak dikenal." ;;
esac
