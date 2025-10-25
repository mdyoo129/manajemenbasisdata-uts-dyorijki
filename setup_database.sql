--==========================================
-- SETUP DATABASE: setup_database.sql
-- Dijalankan sebagai user: postgres
--==========================================

-- 1. CLEANUP (Optional: Hapus skema lama dan users jika ada)
DROP SCHEMA IF EXISTS SALAM CASCADE;

-- Hapus users jika ada (Hanya bisa dihapus jika tidak ada objek yang dipegang)
DROP USER IF EXISTS backend_dev;
DROP USER IF EXISTS bi_dev;
DROP USER IF EXISTS data_engineer;


--==========================================
-- SOAL 3: SKEMA DAN TABEL
--==========================================

-- 2. Buat skema SALAM
CREATE SCHEMA SALAM;

-- 3. Buat tabel mahasiswa (tanpa PK, dengan UNIQUE dan CHECK)
CREATE TABLE SALAM.mahasiswa (
    nim VARCHAR(10) NOT NULL UNIQUE,          -- UNIQUE Constraint
    nama VARCHAR(100),
    email VARCHAR(100),
    usia INT CHECK (usia >= 17)               -- CHECK Constraint: Usia minimal 17 tahun
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
-- Default Privileges: agar berlaku untuk tabel yang dibuat di masa depan
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT ALL ON TABLES TO backend_dev;

-- b. bi_dev: Hanya read/SELECT semua tabel/view
GRANT USAGE ON SCHEMA SALAM TO bi_dev;
GRANT SELECT ON ALL TABLES IN SCHEMA SALAM TO bi_dev;
-- Default Privileges
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT SELECT ON TABLES TO bi_dev;

-- c. data_engineer: CREATE, MODIFY, DROP semua objects, CRUD semua tabel
GRANT ALL ON SCHEMA SALAM TO data_engineer;
GRANT ALL ON ALL TABLES IN SCHEMA SALAM TO data_engineer;
-- Default Privileges
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT ALL ON TABLES TO data_engineer;
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM GRANT ALL ON FUNCTIONS TO data_engineer;


-- 6. PENTING: MENGUBAH OWNER UNTUK HAK DROP (Perbaikan untuk Soal 4.d)
-- Tabel dibuat oleh 'postgres', agar 'data_engineer' bisa DROP,
-- kepemilikan tabel harus dialihkan.

ALTER TABLE SALAM.mahasiswa OWNER TO data_engineer;


--==========================================
-- DATA AWAL (Optional: untuk menguji SELECT user bi_dev)
--==========================================

-- Memasukkan 1 data yang valid
INSERT INTO SALAM.mahasiswa (nim, nama, usia) VALUES ('1237050076', 'Dyo Rijki', 20);