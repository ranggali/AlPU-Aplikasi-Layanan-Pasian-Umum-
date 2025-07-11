-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 28, 2023 at 07:30 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `alpu`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` varchar(18) NOT NULL,
  `nama_lengkap` varchar(50) NOT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `kata_sandi` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `nomor_hp` varchar(12) DEFAULT NULL,
  `alamat` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `nama_lengkap`, `foto`, `kata_sandi`, `email`, `nomor_hp`, `alamat`) VALUES
('A001', 'Admin RS', 'admin.jpg', '4dminRS!', 'admin@gmail.com', '082171475890', 'Jalan Melati No. 123');

-- --------------------------------------------------------

--
-- Table structure for table `dokter`
--

CREATE TABLE `dokter` (
  `nip_dokter` varchar(18) NOT NULL,
  `id_admin` varchar(18) DEFAULT NULL,
  `id_poliklinik` varchar(10) NOT NULL,
  `nama_dokter` varchar(50) NOT NULL,
  `alamat` text NOT NULL,
  `noTelepon` varchar(12) NOT NULL,
  `foto` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `dokter`
--

INSERT INTO `dokter` (`nip_dokter`, `id_admin`, `id_poliklinik`, `nama_dokter`, `alamat`, `noTelepon`, `foto`) VALUES
('D001', 'A001', 'PK001', 'Dr. Jhonatan', 'Jl.Sudirman 123', '082171456789', 'Jhonathan.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `jadwal_dokter`
--

CREATE TABLE `jadwal_dokter` (
  `id` int(11) NOT NULL,
  `nip_dokter` varchar(18) NOT NULL,
  `id_poliklinik` varchar(10) NOT NULL,
  `jam_mulai` time NOT NULL,
  `jam_selesai` time NOT NULL,
  `hari` varchar(10) NOT NULL,
  `tanggal` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jadwal_dokter`
--

INSERT INTO `jadwal_dokter` (`id`, `nip_dokter`, `id_poliklinik`, `jam_mulai`, `jam_selesai`, `hari`, `tanggal`) VALUES
(1, 'D001', 'PK001', '08:00:00', '17:00:00', 'Senin', '2023-11-28');

-- --------------------------------------------------------

--
-- Table structure for table `pasien`
--

CREATE TABLE `pasien` (
  `nik` varchar(16) NOT NULL,
  `id_admin` varchar(18) DEFAULT NULL,
  `nomor_rekam_medis` varchar(20) NOT NULL,
  `nama_lengkap` varchar(50) NOT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `kata_sandi` varchar(12) NOT NULL,
  `email` varchar(50) NOT NULL,
  `nomor_hp` varchar(15) NOT NULL,
  `alamat` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pasien`
--

INSERT INTO `pasien` (`nik`, `id_admin`, `nomor_rekam_medis`, `nama_lengkap`, `foto`, `kata_sandi`, `email`, `nomor_hp`, `alamat`) VALUES
('P001', 'A001', 'RM001', 'Tamaris Roulina Silitonga', 'tamaris.jpg', 'T4m4Ris16', 'tamarissilitongae@gmail.com', '082171475991', 'Batu aji baru No. 456');

-- --------------------------------------------------------

--
-- Table structure for table `pendaftaran`
--

CREATE TABLE `pendaftaran` (
  `id_pendaftaran` int(11) NOT NULL,
  `nik_pasien` varchar(16) NOT NULL,
  `id_poliklinik` varchar(10) NOT NULL,
  `nip_dokter` varchar(18) NOT NULL,
  `tanggal_kunjungan` date NOT NULL,
  `status` enum('belum_dikonfirmasi','hadir','tidak_hadir') DEFAULT 'belum_dikonfirmasi'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pendaftaran`
--

INSERT INTO `pendaftaran` (`id_pendaftaran`, `nik_pasien`, `id_poliklinik`, `nip_dokter`, `tanggal_kunjungan`, `status`) VALUES
(1, 'P001', 'PK001', 'D001', '2023-11-28', 'belum_dikonfirmasi');

-- --------------------------------------------------------

--
-- Table structure for table `poliklinik`
--

CREATE TABLE `poliklinik` (
  `id_poliklinik` varchar(10) NOT NULL,
  `nama_poliklinik` varchar(50) NOT NULL,
  `detail` text NOT NULL,
  `foto_logo` varchar(255) DEFAULT NULL,
  `foto_rs` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `poliklinik`
--

INSERT INTO `poliklinik` (`id_poliklinik`, `nama_poliklinik`, `detail`, `foto_logo`, `foto_rs`) VALUES
('PK001', 'Poliklinik Umum', 'Poliklinik ini menyediakan..', 'logo.jpg', 'rs.jpg');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `dokter`
--
ALTER TABLE `dokter`
  ADD PRIMARY KEY (`nip_dokter`),
  ADD KEY `id_admin` (`id_admin`),
  ADD KEY `id_poliklinik` (`id_poliklinik`);

--
-- Indexes for table `jadwal_dokter`
--
ALTER TABLE `jadwal_dokter`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nip_dokter` (`nip_dokter`),
  ADD KEY `id_poliklinik` (`id_poliklinik`);

--
-- Indexes for table `pasien`
--
ALTER TABLE `pasien`
  ADD PRIMARY KEY (`nik`),
  ADD KEY `id_admin` (`id_admin`);

--
-- Indexes for table `pendaftaran`
--
ALTER TABLE `pendaftaran`
  ADD PRIMARY KEY (`id_pendaftaran`),
  ADD KEY `nik_pasien` (`nik_pasien`),
  ADD KEY `id_poliklinik` (`id_poliklinik`),
  ADD KEY `nip_dokter` (`nip_dokter`);

--
-- Indexes for table `poliklinik`
--
ALTER TABLE `poliklinik`
  ADD PRIMARY KEY (`id_poliklinik`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `jadwal_dokter`
--
ALTER TABLE `jadwal_dokter`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `pendaftaran`
--
ALTER TABLE `pendaftaran`
  MODIFY `id_pendaftaran` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `dokter`
--
ALTER TABLE `dokter`
  ADD CONSTRAINT `dokter_ibfk_1` FOREIGN KEY (`id_admin`) REFERENCES `admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `dokter_ibfk_2` FOREIGN KEY (`id_poliklinik`) REFERENCES `poliklinik` (`id_poliklinik`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `jadwal_dokter`
--
ALTER TABLE `jadwal_dokter`
  ADD CONSTRAINT `jadwal_dokter_ibfk_1` FOREIGN KEY (`nip_dokter`) REFERENCES `dokter` (`nip_dokter`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `jadwal_dokter_ibfk_2` FOREIGN KEY (`id_poliklinik`) REFERENCES `poliklinik` (`id_poliklinik`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pasien`
--
ALTER TABLE `pasien`
  ADD CONSTRAINT `pasien_ibfk_1` FOREIGN KEY (`id_admin`) REFERENCES `admin` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pendaftaran`
--
ALTER TABLE `pendaftaran`
  ADD CONSTRAINT `pendaftaran_ibfk_1` FOREIGN KEY (`nik_pasien`) REFERENCES `pasien` (`nik`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `pendaftaran_ibfk_2` FOREIGN KEY (`id_poliklinik`) REFERENCES `poliklinik` (`id_poliklinik`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `pendaftaran_ibfk_3` FOREIGN KEY (`nip_dokter`) REFERENCES `dokter` (`nip_dokter`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
