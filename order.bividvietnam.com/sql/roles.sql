-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: localhost:3306
-- Thời gian đã tạo: Th1 27, 2024 lúc 03:08 AM
-- Phiên bản máy phục vụ: 8.0.30
-- Phiên bản PHP: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `test`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `roles`
--

CREATE TABLE `roles` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `note` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `guard_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `roles`
--

INSERT INTO `roles` (`id`, `name`, `note`, `guard_name`, `status`, `created_at`, `updated_at`) VALUES
(51, 'Quản lý kinh doanh khu vực', 'RSM', 'api', 0, '2023-10-24 02:05:04', '2024-01-11 21:01:26'),
(60, 'Quản lý  kinh doanh vùng', 'ASM', 'api', 0, '2023-10-27 02:18:59', '2024-01-11 21:02:35'),
(61, 'Nhân viên bán hàng', 'SM', 'api', 0, '2023-11-01 20:41:25', '2024-01-11 21:03:46'),
(62, 'Khách Hàng', NULL, 'api', 0, '2023-11-03 02:31:04', '2024-01-11 21:09:01'),
(63, 'Trình dược viên', NULL, 'api', 0, '2023-11-03 02:32:41', '2024-01-11 21:13:11'),
(64, 'Công tác viên', NULL, 'api', 0, '2023-11-03 02:34:52', '2024-01-11 21:14:18'),
(65, 'Admin', 'Tất cả các quyền', 'api', 0, '2023-11-03 02:39:34', '2024-01-17 19:15:37'),
(66, 'Quản lý thầu khu vực', NULL, 'api', 0, '2023-11-06 00:29:09', '2024-01-11 21:16:03'),
(67, 'Phụ trách thầu', NULL, 'api', 0, '2023-11-06 18:50:27', '2024-01-11 21:17:12'),
(68, 'Giám đốc kinh doanh', 'CEO', 'api', 0, '2023-11-07 01:53:30', '2024-01-11 21:18:35'),
(82, 'Phó giám đốc kinh doanh', NULL, 'api', 0, '2023-11-22 20:42:10', '2024-01-11 21:19:38'),
(88, 'Khách hàng trong thầu', NULL, 'api', 0, '2024-01-24 21:42:30', '2024-01-24 21:42:30'),
(89, 'Khách hàng ngoài thầu', NULL, 'api', 0, '2024-01-24 21:42:42', '2024-01-24 21:42:42'),
(90, 'Sale Admin', NULL, 'api', 0, '2024-01-26 01:01:03', '2024-01-26 01:01:03');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
