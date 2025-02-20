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
-- Cơ sở dữ liệu: `order`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `permissions`
--

CREATE TABLE `permissions` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `module` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `guard_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `permissions`
--

INSERT INTO `permissions` (`id`, `name`, `module`, `guard_name`, `created_at`, `updated_at`) VALUES
(1, 'order', NULL, 'api', '2023-10-19 01:02:34', '2023-10-19 01:02:34'),
(2, 'debts', NULL, 'api', '2023-10-19 01:02:34', '2023-10-19 01:02:34'),
(3, 'product', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(4, 'setting', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(5, 'customer', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(29, 'setting.show', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(30, 'setting.create', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(33, 'setting.edit', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(34, 'setting.delete', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(35, 'product.show', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(36, 'product.create', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(37, 'product.edit', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(39, 'product.delete', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(40, 'chart', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(41, 'compare', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(42, 'analytic', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(43, 'summary', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(44, 'stores', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(45, 'status', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(46, 'category', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(47, 'users', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(49, 'order.show', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(50, 'order.create', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(52, 'order.edit', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(53, 'order.delete', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(54, 'customer.delete', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(55, 'customer.edit', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(57, 'customer.create', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(58, 'customer.show', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(59, 'debts.show', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(60, 'debts.create', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(61, 'debts.edit', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(62, 'debts.delete', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(63, 'category.show', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(64, 'category.create', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(65, 'category.edit', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(66, 'category.delete', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(67, 'users.show', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(68, 'users.create', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(69, 'users.edit', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(70, 'users.delete', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(71, 'productsUnit', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(73, 'productsUnit.show', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(74, 'productsUnit.create', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(75, 'productsUnit.edit', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(76, 'productsUnit.delete', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(82, 'stores.show', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(83, 'stores.create', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(84, 'stores.edit', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(85, 'stores.delete', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(86, 'report', NULL, 'api', '2023-10-19 01:02:34', '2023-10-19 01:02:34'),
(87, 'report.create', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(88, 'report.edit', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(89, 'report.show', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(90, 'report.delete', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(93, 'chart.create', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(94, 'chart.edit', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(95, 'chart.delete', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(96, 'chart.show', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(97, 'analytic.create', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(98, 'analytic.edit', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(99, 'analytic.show', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(100, 'analytic.delete', NULL, 'api', '2023-10-20 19:03:14', '2023-10-20 19:03:14'),
(101, 'contractor', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(102, 'biddingParticipate', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(103, 'biddingContractorOrder', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(104, 'marketing', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(106, 'orderCustomer', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(107, 'biddingOrder', NULL, 'api', '2023-10-19 01:02:34', '2023-10-19 01:02:34'),
(108, 'biddingDebts', NULL, 'api', '2023-10-19 01:02:34', '2023-10-19 01:02:34'),
(109, 'biddingInventory', NULL, 'api', '2023-10-19 01:02:34', '2023-10-19 01:02:34'),
(110, 'biddingInventoryDate', NULL, 'api', '2023-10-19 01:02:34', '2023-10-19 01:02:34'),
(111, 'inventoryDateDelete', NULL, 'api', '2023-10-19 01:02:34', '2023-10-19 01:02:34'),
(112, 'salessummary', NULL, 'api', '2023-10-19 01:02:34', '2023-10-19 01:02:34'),
(113, 'biddingParticipate.create', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(114, 'biddingParticipate.show', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(116, 'biddingParticipate.edit', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(117, 'biddingParticipate.delete', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(118, 'contractor.show', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(119, 'contractor.create', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(120, 'contractor.edit', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(121, 'contractor.delete', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(122, 'biddingContractorOrder.show', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(123, 'biddingContractorOrder.create', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(124, 'biddingContractorOrder.edit', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(125, 'biddingContractorOrder.delete', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(126, 'marketing.show', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(127, 'marketing.create', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(128, 'marketing.edit', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(129, 'marketing.delete', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(130, 'orderCustomer.show', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(131, 'orderCustomer.create', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(132, 'orderCustomer.edit', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(133, 'orderCustomer.delete', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(134, 'biddingOrder.show', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(135, 'biddingOrder.create', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(136, 'biddingOrder.edit', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(137, 'biddingOrder.delete', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(138, 'biddingDebts.show', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(139, 'biddingDebts.create', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(140, 'biddingDebts.edit', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(141, 'biddingDebts.delete', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(142, 'biddingInventory.show', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(143, 'biddingInventory.create', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(144, 'biddingInventory.edit', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(145, 'biddingInventory.delete', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(146, 'biddingInventoryDate.show', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(147, 'biddingInventoryDate.create', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(148, 'biddingInventoryDate.edit', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(149, 'biddingInventoryDate.delete', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(150, 'inventoryDateDelete.show', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(151, 'inventoryDateDelete.create', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(152, 'inventoryDateDelete.edit', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(153, 'inventoryDateDelete.delete', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(154, 'salessummary.show', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(155, 'salessummary.create', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(156, 'salessummary.edit', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59'),
(157, 'salessummary.delete', NULL, 'api', '2023-10-20 19:02:59', '2023-10-20 19:02:59');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=158;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
