--==========================================
-- FILE: setup_database.sql (FINAL VERSION)
-- Dijalankan sebagai user: postgres
--==========================================

-- 1. CLEANUP (Disarankan: untuk memastikan bersih saat pengujian ulang)
DROP SCHEMA IF EXISTS SALAM CASCADE;
DROP USER IF EXISTS backend_dev;
DROP USER IF EXISTS bi_dev;
DROP USER IF EXISTS data_engineer;

--==========================================
-- SOAL 3: SKEMA DAN TABEL (Termasuk PRIMARY KEY)
--==========================================

-- 2. Buat skema SALAM
CREATE SCHEMA SALAM;

-- 3. Buat tabel mahasiswa (dengan PRIMARY KEY, UNIQUE, dan CHECK)
CREATE TABLE SALAM.mahasiswa (
    nim VARCHAR(10) PRIMARY KEY,      -- PRIMARY KEY (memenuhi semua kemungkinan interpretasi soal)
    nama VARCHAR(100),
    email VARCHAR(100),
    usia INT CHECK (usia >= 17)       -- Check Constraint
);

--==========================================
-- SOAL 4: MANAJEMEN PENGGUNA (CREATE & GRANT)
--==========================================

-- 4. Membuat users (Roles) baru
CREATE USER backend_dev WITH PASSWORD 'devpass';
CREATE USER bi_dev WITH PASSWORD 'bipass';
CREATE USER data_engineer WITH PASSWORD 'datapass';


-- 5. Memberikan Hak Akses (GRANT)

-- a. backend_dev: CRUD semua tabel
GRANT USAGE ON SCHEMA SALAM TO backend_dev;
GRANT ALL ON ALL TABLES IN SCHEMA SALAM TO backend_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT ALL ON TABLES TO backend_dev;

-- b. bi_dev: Hanya read/SELECT semua tabel/view
GRANT USAGE ON SCHEMA SALAM TO bi_dev;
GRANT SELECT ON ALL TABLES IN SCHEMA SALAM TO bi_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT SELECT ON TABLES TO bi_dev;

-- c. data_engineer: CREATE, MODIFY, DROP semua objects, CRUD semua tabel
GRANT ALL ON SCHEMA SALAM TO data_engineer;
GRANT ALL ON ALL TABLES IN SCHEMA SALAM TO data_engineer;
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT ALL ON TABLES TO data_engineer;
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT ALL ON FUNCTIONS TO data_engineer;


-- 6. PENTING: MENGUBAH OWNER (Perbaikan untuk Soal 4.d)
-- Tabel dibuat oleh 'postgres', agar 'data_engineer' bisa DROP, kepemilikan harus dialihkan.
ALTER TABLE SALAM.mahasiswa OWNER TO data_engineer;


--==========================================
-- DATA AWAL (Digunakan untuk pengujian SELECT)
--==========================================

-- Memasukkan 1 data yang valid
INSERT INTO SALAM.mahasiswa (nim, nama, usia) VALUES ('1237050076', 'Dyo Rijki', 20);