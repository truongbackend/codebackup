-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: localhost:3306
-- Thời gian đã tạo: Th1 27, 2024 lúc 03:09 AM
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
-- Cơ sở dữ liệu: `order`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `model_has_permissions`
--

CREATE TABLE `model_has_permissions` (
  `permission_id` bigint UNSIGNED NOT NULL,
  `model_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint UNSIGNED NOT NULL,
  `block` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `model_has_permissions`
--

INSERT INTO `model_has_permissions` (`permission_id`, `model_type`, `model_id`, `block`) VALUES
(1, 'App\\Models\\User', 79, 0),
(1, 'App\\Models\\User', 114, 0),
(1, 'App\\Models\\User', 802, 0),
(1, 'App\\Models\\User', 806, 0),
(1, 'App\\Models\\User', 813, 0),
(2, 'App\\Models\\User', 802, 0),
(2, 'App\\Models\\User', 806, 0),
(2, 'App\\Models\\User', 813, 0),
(3, 'App\\Models\\User', 806, 0),
(3, 'App\\Models\\User', 813, 0),
(4, 'App\\Models\\User', 806, 0),
(4, 'App\\Models\\User', 813, 0),
(5, 'App\\Models\\User', 114, 0),
(5, 'App\\Models\\User', 806, 0),
(5, 'App\\Models\\User', 813, 0),
(29, 'App\\Models\\User', 806, 0),
(29, 'App\\Models\\User', 813, 0),
(30, 'App\\Models\\User', 806, 0),
(30, 'App\\Models\\User', 813, 0),
(33, 'App\\Models\\User', 806, 0),
(33, 'App\\Models\\User', 813, 0),
(34, 'App\\Models\\User', 806, 0),
(34, 'App\\Models\\User', 813, 0),
(35, 'App\\Models\\User', 806, 0),
(35, 'App\\Models\\User', 813, 0),
(36, 'App\\Models\\User', 806, 0),
(36, 'App\\Models\\User', 813, 0),
(37, 'App\\Models\\User', 806, 0),
(37, 'App\\Models\\User', 813, 0),
(39, 'App\\Models\\User', 806, 0),
(39, 'App\\Models\\User', 813, 0),
(40, 'App\\Models\\User', 813, 0),
(42, 'App\\Models\\User', 813, 0),
(44, 'App\\Models\\User', 98, 0),
(44, 'App\\Models\\User', 806, 0),
(44, 'App\\Models\\User', 813, 0),
(46, 'App\\Models\\User', 806, 0),
(46, 'App\\Models\\User', 813, 0),
(47, 'App\\Models\\User', 806, 0),
(47, 'App\\Models\\User', 813, 0),
(49, 'App\\Models\\User', 79, 0),
(49, 'App\\Models\\User', 114, 0),
(49, 'App\\Models\\User', 802, 0),
(49, 'App\\Models\\User', 806, 0),
(49, 'App\\Models\\User', 813, 0),
(50, 'App\\Models\\User', 79, 0),
(50, 'App\\Models\\User', 114, 0),
(50, 'App\\Models\\User', 802, 0),
(50, 'App\\Models\\User', 806, 0),
(50, 'App\\Models\\User', 813, 0),
(52, 'App\\Models\\User', 79, 0),
(52, 'App\\Models\\User', 114, 0),
(52, 'App\\Models\\User', 802, 0),
(52, 'App\\Models\\User', 806, 0),
(52, 'App\\Models\\User', 813, 0),
(53, 'App\\Models\\User', 79, 0),
(53, 'App\\Models\\User', 114, 0),
(53, 'App\\Models\\User', 802, 0),
(53, 'App\\Models\\User', 806, 0),
(53, 'App\\Models\\User', 813, 0),
(54, 'App\\Models\\User', 114, 0),
(54, 'App\\Models\\User', 806, 0),
(54, 'App\\Models\\User', 813, 0),
(55, 'App\\Models\\User', 114, 0),
(55, 'App\\Models\\User', 806, 0),
(55, 'App\\Models\\User', 813, 0),
(57, 'App\\Models\\User', 114, 0),
(57, 'App\\Models\\User', 806, 0),
(57, 'App\\Models\\User', 813, 0),
(58, 'App\\Models\\User', 114, 0),
(58, 'App\\Models\\User', 806, 0),
(58, 'App\\Models\\User', 813, 0),
(59, 'App\\Models\\User', 802, 0),
(59, 'App\\Models\\User', 806, 0),
(59, 'App\\Models\\User', 813, 0),
(60, 'App\\Models\\User', 802, 0),
(60, 'App\\Models\\User', 806, 0),
(60, 'App\\Models\\User', 813, 0),
(61, 'App\\Models\\User', 802, 0),
(61, 'App\\Models\\User', 806, 0),
(61, 'App\\Models\\User', 813, 0),
(62, 'App\\Models\\User', 802, 0),
(62, 'App\\Models\\User', 806, 0),
(62, 'App\\Models\\User', 813, 0),
(63, 'App\\Models\\User', 806, 0),
(63, 'App\\Models\\User', 813, 0),
(64, 'App\\Models\\User', 806, 0),
(64, 'App\\Models\\User', 813, 0),
(65, 'App\\Models\\User', 806, 0),
(65, 'App\\Models\\User', 813, 0),
(66, 'App\\Models\\User', 806, 0),
(66, 'App\\Models\\User', 813, 0),
(67, 'App\\Models\\User', 806, 0),
(67, 'App\\Models\\User', 813, 0),
(68, 'App\\Models\\User', 806, 0),
(68, 'App\\Models\\User', 813, 0),
(69, 'App\\Models\\User', 806, 0),
(69, 'App\\Models\\User', 813, 0),
(70, 'App\\Models\\User', 806, 0),
(70, 'App\\Models\\User', 813, 0),
(71, 'App\\Models\\User', 806, 0),
(71, 'App\\Models\\User', 813, 0),
(73, 'App\\Models\\User', 806, 0),
(73, 'App\\Models\\User', 813, 0),
(74, 'App\\Models\\User', 806, 0),
(74, 'App\\Models\\User', 813, 0),
(75, 'App\\Models\\User', 806, 0),
(75, 'App\\Models\\User', 813, 0),
(76, 'App\\Models\\User', 806, 0),
(76, 'App\\Models\\User', 813, 0),
(82, 'App\\Models\\User', 98, 0),
(82, 'App\\Models\\User', 806, 0),
(82, 'App\\Models\\User', 813, 0),
(83, 'App\\Models\\User', 98, 0),
(83, 'App\\Models\\User', 806, 0),
(83, 'App\\Models\\User', 813, 0),
(84, 'App\\Models\\User', 98, 0),
(84, 'App\\Models\\User', 806, 0),
(84, 'App\\Models\\User', 813, 0),
(85, 'App\\Models\\User', 98, 0),
(85, 'App\\Models\\User', 806, 0),
(85, 'App\\Models\\User', 813, 0),
(93, 'App\\Models\\User', 813, 0),
(94, 'App\\Models\\User', 813, 0),
(95, 'App\\Models\\User', 813, 0),
(96, 'App\\Models\\User', 813, 0),
(97, 'App\\Models\\User', 813, 0),
(98, 'App\\Models\\User', 813, 0),
(99, 'App\\Models\\User', 813, 0),
(100, 'App\\Models\\User', 813, 0),
(101, 'App\\Models\\User', 813, 0),
(102, 'App\\Models\\User', 813, 0),
(103, 'App\\Models\\User', 813, 0),
(104, 'App\\Models\\User', 813, 0),
(106, 'App\\Models\\User', 813, 0),
(107, 'App\\Models\\User', 813, 0),
(108, 'App\\Models\\User', 813, 0),
(109, 'App\\Models\\User', 813, 0),
(110, 'App\\Models\\User', 813, 0),
(111, 'App\\Models\\User', 813, 0),
(112, 'App\\Models\\User', 813, 0),
(113, 'App\\Models\\User', 813, 0),
(114, 'App\\Models\\User', 813, 0),
(116, 'App\\Models\\User', 813, 0),
(117, 'App\\Models\\User', 813, 0),
(118, 'App\\Models\\User', 813, 0),
(119, 'App\\Models\\User', 813, 0),
(120, 'App\\Models\\User', 813, 0),
(121, 'App\\Models\\User', 813, 0),
(122, 'App\\Models\\User', 813, 0),
(123, 'App\\Models\\User', 813, 0),
(124, 'App\\Models\\User', 813, 0),
(125, 'App\\Models\\User', 813, 0),
(126, 'App\\Models\\User', 813, 0),
(127, 'App\\Models\\User', 813, 0),
(128, 'App\\Models\\User', 813, 0),
(129, 'App\\Models\\User', 813, 0),
(130, 'App\\Models\\User', 813, 0),
(131, 'App\\Models\\User', 813, 0),
(132, 'App\\Models\\User', 813, 0),
(133, 'App\\Models\\User', 813, 0),
(134, 'App\\Models\\User', 813, 0),
(135, 'App\\Models\\User', 813, 0),
(136, 'App\\Models\\User', 813, 0),
(137, 'App\\Models\\User', 813, 0),
(138, 'App\\Models\\User', 813, 0),
(139, 'App\\Models\\User', 813, 0),
(140, 'App\\Models\\User', 813, 0),
(141, 'App\\Models\\User', 813, 0),
(142, 'App\\Models\\User', 813, 0),
(143, 'App\\Models\\User', 813, 0),
(144, 'App\\Models\\User', 813, 0),
(145, 'App\\Models\\User', 813, 0),
(146, 'App\\Models\\User', 813, 0),
(147, 'App\\Models\\User', 813, 0),
(148, 'App\\Models\\User', 813, 0),
(149, 'App\\Models\\User', 813, 0),
(150, 'App\\Models\\User', 813, 0),
(151, 'App\\Models\\User', 813, 0),
(152, 'App\\Models\\User', 813, 0),
(153, 'App\\Models\\User', 813, 0),
(154, 'App\\Models\\User', 813, 0),
(155, 'App\\Models\\User', 813, 0),
(156, 'App\\Models\\User', 813, 0),
(157, 'App\\Models\\User', 813, 0);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  ADD KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `model_has_permissions`
--
ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
