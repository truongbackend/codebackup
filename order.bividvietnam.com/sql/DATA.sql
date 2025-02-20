/* Setting data order */
/* Crete table company*/
CREATE TABLE `cms_company` (
  `id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` tinyint NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
ALTER TABLE `cms_company`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `cms_company`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
COMMIT;
/* insert data*/
INSERT INTO `cms_company` (`id`, `name`, `status`) VALUES
(1, 'Công ty TNHH BILEJE', 0),
(2, 'Công ty TNHH Bình Việt Đức', 0),
(7, 'Công ty TNHH Đông Nam Dược Bảo Long', 0);
-------------------------------------------------------------------------
/*  cms_customers table */
ALTER TABLE cms_customers ADD COLUMN user_assigned varchar(255) NULL;
ALTER TABLE cms_customers ADD COLUMN company_id varchar(255) NULL;
/*  UPDATE cms_customers company_id data cu */
UPDATE cms_customers SET company_id = 2;

-------------------------------------------------------------------------
/* Crete table cms_customers_bids_products*/
ALTER TABLE cms_customers_bids_products ADD COLUMN customer_code varchar(255) NULL;
-------------------------------------------------------------------------
/* Crete table cms_debts*/
ALTER TABLE cms_debts ADD COLUMN company_id INT NULL;
ALTER TABLE cms_debts ADD COLUMN ten_kh varchar(255) NULL;

/*  UPDATE cms_customers company_id data cu */
UPDATE cms_debts SET company_id = 2;

-------------------------------------------------------------------------
/* Crete table company*/
CREATE TABLE `cms_debts_detail` (
  `ID` int NOT NULL,
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL,
  `price` int NOT NULL,
  `bid_id` int NOT NULL,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `product_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `cms_debts_detail`
  ADD PRIMARY KEY (`ID`);

ALTER TABLE `cms_debts_detail`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;


-------------------------------------------------------------------------
/* Crete table order*/
ALTER TABLE cms_customers ADD COLUMN company_id varchar(255) NULL;
/*  UPDATE cms_customers company_id data cu */
UPDATE cms_debts SET company_id = 2;


-------------------------------------------------------------------------
/* Crete table order*/
ALTER TABLE cms_orders ADD COLUMN company_id varchar(255) NULL;
/*  UPDATE cms_customers company_id data cu */
UPDATE cms_orders SET company_id = 2;


-------------------------------------------------------------------------
/* Crete table cms_order_px_detail*/
--
-- Cấu trúc bảng cho bảng `cms_order_px_detail`
--

CREATE TABLE `cms_order_px_detail` (
  `ID` int NOT NULL,
  `quantity` int DEFAULT NULL,
  `price` int DEFAULT NULL,
  `bid_id` int DEFAULT NULL,
  `order_px_id` int NOT NULL,
  `id_product` int NOT NULL,
  `product_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


ALTER TABLE `cms_order_px_detail`
  ADD PRIMARY KEY (`ID`);
 
ALTER TABLE `cms_order_px_detail`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

-------------------------------------------------------------------------
/* Crete table cms_products*/
ALTER TABLE cms_products ADD COLUMN company_id varchar(255) NULL;
UPDATE cms_products SET company_id = 2;


-------------------------------------------------------------------------
/* Crete table cms_products_group*/
ALTER TABLE cms_products_group ADD COLUMN company_id INT NULL;
UPDATE cms_products_group SET company_id = 2;


-------------------------------------------------------------------------
/* Crete table cms_products_manufacture*/
ALTER TABLE cms_products_manufacture ADD COLUMN company_id INT NULL;
UPDATE cms_products_manufacture SET company_id = 2;


-- Cấu trúc bảng cho bảng `cms_status`
--
-------------------------------------------------------------------------
CREATE TABLE `cms_status` (
  `id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `cms_status`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `cms_status`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
COMMIT;
-- Insert bảng cho bảng `cms_status`
INSERT INTO `cms_status` (`id`, `name`) VALUES
(5, 'Khởi tạo'),
(6, 'đã xóa'),
(7, 'đã ngừng kinh doanh'),
(8, 'đang kinh doanh'),
(9, 'Đang giao'),
(10, 'Đã giao'),
(11, 'Thành công'),
(12, 'Hủy');

-- Cấu trúc bảng cho bảng `cms_stores`
--
-------------------------------------------------------------------------

ALTER TABLE cms_stores ADD COLUMN status tinyint(1) NULL DEFAULT '1';
ALTER TABLE cms_stores ADD COLUMN company_id INT NULL;
/*  UPDATE cms_stores company_id data cu */
UPDATE cms_stores SET company_id = 2;


-------------------------------------------------------------------------
--
-- Cấu trúc bảng cho bảng `cms_store_manager`
--

CREATE TABLE `cms_store_manager` (
  `id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `cms_store_manager`
--

INSERT INTO `cms_store_manager` (`id`, `name`, `status`) VALUES
(1, 'Miền Bắc', 0),
(2, 'Miền Nam', 0),
(3, 'Miền Trung', 0);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `cms_store_manager`
--
ALTER TABLE `cms_store_manager`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `cms_store_manager`
--
ALTER TABLE `cms_store_manager`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

-------------------------------------------------------------------------
--
-- Cấu trúc bảng cho bảng `cms_users`
ALTER TABLE cms_users ADD COLUMN roles_id INT NULL;
ALTER TABLE cms_users ADD COLUMN user_assigned varchar(255) NULL;
ALTER TABLE cms_users ADD COLUMN company_id varchar(255) NULL;
ALTER TABLE cms_users ADD COLUMN company_select INT NULL;
--Update bangr cu`
UPDATE cms_users SET company_id = "[2]";



UPDATE cms_users SET company_select = 2;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `grouppermissionsbydata`
--

CREATE TABLE `grouppermissionsbydata` (
  `role_id` int NOT NULL,
  `id` int NOT NULL,
  `store_id` int NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `Upcreated` datetime DEFAULT NULL,
  `Updatedate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- Chỉ mục cho bảng `grouppermissionsbydata`
--
ALTER TABLE `grouppermissionsbydata`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `grouppermissionsbydata`
--
ALTER TABLE `grouppermissionsbydata`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;



-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `import_customer`
--

CREATE TABLE `import_customer` (
  `id` int NOT NULL,
  `customer_code` varchar(255) NOT NULL,
  `customer_name` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `customer_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `customer_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `customer_addr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `customer_ship_addr` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `company_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `user_init` int NOT NULL,
  `store_id` varchar(13) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_db` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Chỉ mục cho bảng `import_customer`
--
ALTER TABLE `import_customer`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `import_customer`
--
ALTER TABLE `import_customer`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25000;
COMMIT;


-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `import_debts_customer`
--

CREATE TABLE `import_debts_customer` (
  `id` int NOT NULL,
  `output_code` varchar(255) NOT NULL,
  `company_id` varchar(255) NOT NULL,
  `user_init` int NOT NULL,
  `created` datetime DEFAULT CURRENT_TIMESTAMP,
  `ten_kh` varchar(255) DEFAULT NULL,
  `customer_id` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Chỉ mục cho bảng `import_debts_customer`
--
ALTER TABLE `import_debts_customer`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `import_debts_customer`
--
ALTER TABLE `import_debts_customer`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2338;
COMMIT;


-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `import_product`
--

CREATE TABLE `import_product` (
  `id` int NOT NULL,
  `prd_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `prd_name` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `prd_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `prd_sell_price` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `prd_image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `prd_descriptions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `prd_manufacture_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `prd_unit_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `user_id` varchar(255) NOT NULL,
  `company_id` varchar(255) NOT NULL,
  `prd_active` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
-- Chỉ mục cho bảng `import_product`
--
ALTER TABLE `import_product`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `import_product`
--
ALTER TABLE `import_product`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1721;
COMMIT;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `import_product_customer`
--

CREATE TABLE `import_product_customer` (
  `id` int NOT NULL,
  `customer_id` varchar(255) NOT NULL,
  `product_id` varchar(256) NOT NULL,
  `prd_code` varchar(255) NOT NULL,
  `prd_sell_price` int NOT NULL,
  `quantity` int NOT NULL,
  `expiration_date` date NOT NULL,
  `ten_kh` varchar(255) NOT NULL,
  `company_id` int NOT NULL,
  `user_init` int NOT NULL,
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Chỉ mục cho bảng `import_product_customer`
--
ALTER TABLE `import_product_customer`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `import_product_customer`
--
ALTER TABLE `import_product_customer`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=394;
COMMIT;


-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(65, '2023_09_13_090400_create_permissions_table', 1),
(66, '2023_09_13_090411_create_roles_table', 1),
(549, '2016_06_01_000001_create_oauth_auth_codes_table', 2),
(550, '2016_06_01_000002_create_oauth_access_tokens_table', 2),
(551, '2016_06_01_000003_create_oauth_refresh_tokens_table', 2),
(552, '2016_06_01_000004_create_oauth_clients_table', 2),
(553, '2016_06_01_000005_create_oauth_personal_access_clients_table', 2),
(554, '2019_12_14_000001_create_personal_access_tokens_table', 2),
(555, '2023_10_16_030308_create_roles_table', 3),
(556, '2023_10_16_044331_create_permissions_table', 4),
(558, '2023_10_17_073253_create_permission_table', 5),
(559, '2023_10_19_045610_create_permission_tables', 6),
(560, '2023_10_19_071155_create_permission_tables', 7);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=561;
COMMIT;


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
  `company_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

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
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=114;
COMMIT;

-- Đang đổ dữ liệu cho bảng `roles`
--

INSERT INTO `roles` (`id`, `name`, `note`, `guard_name`, `status`, `company_id`, `created_at`, `updated_at`) VALUES
(51, 'Quản lý kinh doanh khu vực', 'RSM', 'api', 0, '[]', '2023-10-24 02:05:04', '2024-03-13 20:01:10'),
(60, 'Quản lý  kinh doanh vùng', 'ASM', 'api', 0, '[2]', '2023-10-27 02:18:59', '2024-03-13 19:52:44'),
(61, 'Nhân viên bán hàng', 'SM', 'api', 0, '[2,3,1]', '2023-11-01 20:41:25', '2024-01-11 21:03:46'),
(62, 'Khách Hàng', NULL, 'api', 0, '[2,1,3]', '2023-11-03 02:31:04', '2024-03-12 20:38:18'),
(63, 'Trình dược viên', NULL, 'api', 0, '[2,3,1]', '2023-11-03 02:32:41', '2024-03-11 19:55:49'),
(64, 'Công tác viên', NULL, 'api', 0, '[2,3,1]', '2023-11-03 02:34:52', '2024-01-11 21:14:18'),
(65, 'Admin', 'Tất cả các quyền', 'api', 0, '[2,3,1]', '2023-11-03 02:39:34', '2024-03-11 20:55:07'),
(66, 'Quản lý thầu khu vực', NULL, 'api', 0, '[2,3,1]', '2023-11-06 00:29:09', '2024-01-11 21:16:03'),
(67, 'Phụ trách thầu', NULL, 'api', 0, '[2,3,1]', '2023-11-06 18:50:27', '2024-01-11 21:17:12'),
(68, 'Giám đốc kinh doanh', 'CEO', 'api', 0, '[2,3,1]', '2023-11-07 01:53:30', '2024-01-11 21:18:35'),
(82, 'Phó giám đốc kinh doanh', NULL, 'api', 0, '[2,3,1]', '2023-11-22 20:42:10', '2024-03-08 20:58:29'),
(88, 'Khách hàng trong thầu', NULL, 'api', 0, '[1,2,3]', '2024-01-24 21:42:30', '2024-03-15 20:44:52'),
(89, 'Khách hàng ngoài thầu', NULL, 'api', 0, '[3]', '2024-01-24 21:42:42', '2024-03-18 23:11:48'),
(90, 'Sale Admin', NULL, 'api', 0, '[1,2]', '2024-01-26 01:01:03', '2024-03-12 19:42:55'),
(102, 'Quản lý chất lượng', NULL, 'api', 1, '[]', '2024-03-12 21:32:46', '2024-03-13 20:07:04')

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
(1, 'App\\Models\\User', 61, 0),
(1, 'App\\Models\\User', 79, 0),
(1, 'App\\Models\\User', 114, 0),
(1, 'App\\Models\\User', 802, 0),
(1, 'App\\Models\\User', 806, 0),
(1, 'App\\Models\\User', 813, 0),
(2, 'App\\Models\\User', 61, 0),
(2, 'App\\Models\\User', 802, 0),
(2, 'App\\Models\\User', 806, 0),
(2, 'App\\Models\\User', 813, 0),
(3, 'App\\Models\\User', 61, 0),
(3, 'App\\Models\\User', 806, 0),
(3, 'App\\Models\\User', 813, 0),
(4, 'App\\Models\\User', 806, 0),
(4, 'App\\Models\\User', 813, 0),
(5, 'App\\Models\\User', 61, 0),
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
(35, 'App\\Models\\User', 61, 0),
(35, 'App\\Models\\User', 806, 0),
(35, 'App\\Models\\User', 813, 0),
(36, 'App\\Models\\User', 61, 0),
(36, 'App\\Models\\User', 806, 0),
(36, 'App\\Models\\User', 813, 0),
(37, 'App\\Models\\User', 61, 0),
(37, 'App\\Models\\User', 806, 0),
(37, 'App\\Models\\User', 813, 0),
(39, 'App\\Models\\User', 61, 0),
(39, 'App\\Models\\User', 806, 0),
(39, 'App\\Models\\User', 813, 0),
(40, 'App\\Models\\User', 813, 0),
(42, 'App\\Models\\User', 813, 0),
(44, 'App\\Models\\User', 98, 0),
(44, 'App\\Models\\User', 806, 0),
(44, 'App\\Models\\User', 813, 0),
(46, 'App\\Models\\User', 61, 0),
(46, 'App\\Models\\User', 806, 0),
(46, 'App\\Models\\User', 813, 0),
(47, 'App\\Models\\User', 806, 0),
(47, 'App\\Models\\User', 813, 0),
(49, 'App\\Models\\User', 61, 0),
(49, 'App\\Models\\User', 79, 0),
(49, 'App\\Models\\User', 114, 0),
(49, 'App\\Models\\User', 802, 0),
(49, 'App\\Models\\User', 806, 0),
(49, 'App\\Models\\User', 813, 0),
(50, 'App\\Models\\User', 61, 0),
(50, 'App\\Models\\User', 79, 0),
(50, 'App\\Models\\User', 114, 0),
(50, 'App\\Models\\User', 802, 0),
(50, 'App\\Models\\User', 806, 0),
(50, 'App\\Models\\User', 813, 0),
(52, 'App\\Models\\User', 61, 0),
(52, 'App\\Models\\User', 79, 0),
(52, 'App\\Models\\User', 114, 0),
(52, 'App\\Models\\User', 802, 0),
(52, 'App\\Models\\User', 806, 0),
(52, 'App\\Models\\User', 813, 0),
(53, 'App\\Models\\User', 61, 0),
(53, 'App\\Models\\User', 79, 0),
(53, 'App\\Models\\User', 114, 0),
(53, 'App\\Models\\User', 802, 0),
(53, 'App\\Models\\User', 806, 0),
(53, 'App\\Models\\User', 813, 0),
(54, 'App\\Models\\User', 61, 0),
(54, 'App\\Models\\User', 114, 0),
(54, 'App\\Models\\User', 806, 0),
(54, 'App\\Models\\User', 813, 0),
(55, 'App\\Models\\User', 61, 0),
(55, 'App\\Models\\User', 114, 0),
(55, 'App\\Models\\User', 806, 0),
(55, 'App\\Models\\User', 813, 0),
(57, 'App\\Models\\User', 61, 0),
(57, 'App\\Models\\User', 114, 0),
(57, 'App\\Models\\User', 806, 0),
(57, 'App\\Models\\User', 813, 0),
(58, 'App\\Models\\User', 61, 0),
(58, 'App\\Models\\User', 114, 0),
(58, 'App\\Models\\User', 806, 0),
(58, 'App\\Models\\User', 813, 0),
(59, 'App\\Models\\User', 61, 0),
(59, 'App\\Models\\User', 802, 0),
(59, 'App\\Models\\User', 806, 0),
(59, 'App\\Models\\User', 813, 0),
(60, 'App\\Models\\User', 61, 0),
(60, 'App\\Models\\User', 802, 0),
(60, 'App\\Models\\User', 806, 0),
(60, 'App\\Models\\User', 813, 0),
(61, 'App\\Models\\User', 61, 0),
(61, 'App\\Models\\User', 802, 0),
(61, 'App\\Models\\User', 806, 0),
(61, 'App\\Models\\User', 813, 0),
(62, 'App\\Models\\User', 61, 0),
(62, 'App\\Models\\User', 802, 0),
(62, 'App\\Models\\User', 806, 0),
(62, 'App\\Models\\User', 813, 0),
(63, 'App\\Models\\User', 61, 0),
(63, 'App\\Models\\User', 806, 0),
(63, 'App\\Models\\User', 813, 0),
(64, 'App\\Models\\User', 61, 0),
(64, 'App\\Models\\User', 806, 0),
(64, 'App\\Models\\User', 813, 0),
(65, 'App\\Models\\User', 61, 0),
(65, 'App\\Models\\User', 806, 0),
(65, 'App\\Models\\User', 813, 0),
(66, 'App\\Models\\User', 61, 0),
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


CREATE TABLE `model_has_roles` (
  `role_id` bigint UNSIGNED NOT NULL,
  `model_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `model_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `model_has_roles`
--

INSERT INTO `model_has_roles` (`role_id`, `model_type`, `model_id`) VALUES
(65, 'App\\Models\\User', 1),
(62, 'App\\Models\\User', 53),
(60, 'App\\Models\\User', 54),
(65, 'App\\Models\\User', 55),
(60, 'App\\Models\\User', 57),
(63, 'App\\Models\\User', 58),
(88, 'App\\Models\\User', 59),
(60, 'App\\Models\\User', 60),
(51, 'App\\Models\\User', 61),
(88, 'App\\Models\\User', 62),
(60, 'App\\Models\\User', 63),
(104, 'App\\Models\\User', 64),
(108, 'App\\Models\\User', 65),
(63, 'App\\Models\\User', 66),
(107, 'App\\Models\\User', 68),
(88, 'App\\Models\\User', 69),
(88, 'App\\Models\\User', 71),
(109, 'App\\Models\\User', 72),
(113, 'App\\Models\\User', 73),
(107, 'App\\Models\\User', 74),
(108, 'App\\Models\\User', 75),
(62, 'App\\Models\\User', 76),
(88, 'App\\Models\\User', 77),
(63, 'App\\Models\\User', 78),
(60, 'App\\Models\\User', 79),
(60, 'App\\Models\\User', 80),
(88, 'App\\Models\\User', 81),
(60, 'App\\Models\\User', 82),
(88, 'App\\Models\\User', 83),
(88, 'App\\Models\\User', 85),
(88, 'App\\Models\\User', 86),
(88, 'App\\Models\\User', 87),
(88, 'App\\Models\\User', 88),
(88, 'App\\Models\\User', 90),
(88, 'App\\Models\\User', 91),
(88, 'App\\Models\\User', 92),
(88, 'App\\Models\\User', 93),
(63, 'App\\Models\\User', 94),
(88, 'App\\Models\\User', 95),
(88, 'App\\Models\\User', 96),
(88, 'App\\Models\\User', 98),
(88, 'App\\Models\\User', 99),
(63, 'App\\Models\\User', 100),
(88, 'App\\Models\\User', 101),
(88, 'App\\Models\\User', 102),
(88, 'App\\Models\\User', 103),
(88, 'App\\Models\\User', 104),
(88, 'App\\Models\\User', 105),
(88, 'App\\Models\\User', 108),
(63, 'App\\Models\\User', 111),
(88, 'App\\Models\\User', 114),
(88, 'App\\Models\\User', 115),
(88, 'App\\Models\\User', 116),
(88, 'App\\Models\\User', 119),
(88, 'App\\Models\\User', 120),
(88, 'App\\Models\\User', 121),
(88, 'App\\Models\\User', 122),
(88, 'App\\Models\\User', 123),
(88, 'App\\Models\\User', 124),
(88, 'App\\Models\\User', 125),
(88, 'App\\Models\\User', 126),
(63, 'App\\Models\\User', 127),
(88, 'App\\Models\\User', 128),
(88, 'App\\Models\\User', 130),
(88, 'App\\Models\\User', 131),
(88, 'App\\Models\\User', 133),
(88, 'App\\Models\\User', 134),
(88, 'App\\Models\\User', 135),
(88, 'App\\Models\\User', 136),
(88, 'App\\Models\\User', 137),
(60, 'App\\Models\\User', 138),
(88, 'App\\Models\\User', 139),
(88, 'App\\Models\\User', 140),
(88, 'App\\Models\\User', 141),
(88, 'App\\Models\\User', 142),
(88, 'App\\Models\\User', 144),
(88, 'App\\Models\\User', 145),
(88, 'App\\Models\\User', 148),
(63, 'App\\Models\\User', 150),
(88, 'App\\Models\\User', 151),
(60, 'App\\Models\\User', 152),
(88, 'App\\Models\\User', 153),
(88, 'App\\Models\\User', 154),
(60, 'App\\Models\\User', 156),
(88, 'App\\Models\\User', 161),
(88, 'App\\Models\\User', 162),
(88, 'App\\Models\\User', 163),
(88, 'App\\Models\\User', 164),
(60, 'App\\Models\\User', 166),
(63, 'App\\Models\\User', 168),
(88, 'App\\Models\\User', 169),
(60, 'App\\Models\\User', 170),
(88, 'App\\Models\\User', 171),
(88, 'App\\Models\\User', 172),
(88, 'App\\Models\\User', 173),
(88, 'App\\Models\\User', 174),
(60, 'App\\Models\\User', 175),
(63, 'App\\Models\\User', 176),
(88, 'App\\Models\\User', 177),
(63, 'App\\Models\\User', 178),
(63, 'App\\Models\\User', 179),
(88, 'App\\Models\\User', 180),
(60, 'App\\Models\\User', 182),
(88, 'App\\Models\\User', 183),
(60, 'App\\Models\\User', 184),
(88, 'App\\Models\\User', 186),
(88, 'App\\Models\\User', 187),
(88, 'App\\Models\\User', 188),
(60, 'App\\Models\\User', 189),
(88, 'App\\Models\\User', 192),
(60, 'App\\Models\\User', 194),
(88, 'App\\Models\\User', 195),
(88, 'App\\Models\\User', 196),
(88, 'App\\Models\\User', 197),
(88, 'App\\Models\\User', 198),
(60, 'App\\Models\\User', 199),
(88, 'App\\Models\\User', 200),
(60, 'App\\Models\\User', 201),
(88, 'App\\Models\\User', 202),
(88, 'App\\Models\\User', 203),
(88, 'App\\Models\\User', 204),
(88, 'App\\Models\\User', 205),
(88, 'App\\Models\\User', 206),
(88, 'App\\Models\\User', 207),
(88, 'App\\Models\\User', 208),
(88, 'App\\Models\\User', 209),
(88, 'App\\Models\\User', 210),
(88, 'App\\Models\\User', 211),
(88, 'App\\Models\\User', 214),
(88, 'App\\Models\\User', 215),
(88, 'App\\Models\\User', 216),
(88, 'App\\Models\\User', 217),
(88, 'App\\Models\\User', 218),
(88, 'App\\Models\\User', 219),
(88, 'App\\Models\\User', 222),
(88, 'App\\Models\\User', 223),
(88, 'App\\Models\\User', 224),
(88, 'App\\Models\\User', 225),
(63, 'App\\Models\\User', 226),
(88, 'App\\Models\\User', 228),
(88, 'App\\Models\\User', 229),
(88, 'App\\Models\\User', 230),
(60, 'App\\Models\\User', 231),
(88, 'App\\Models\\User', 233),
(60, 'App\\Models\\User', 234),
(88, 'App\\Models\\User', 235),
(88, 'App\\Models\\User', 236),
(88, 'App\\Models\\User', 237),
(88, 'App\\Models\\User', 238),
(60, 'App\\Models\\User', 239),
(88, 'App\\Models\\User', 240),
(88, 'App\\Models\\User', 241),
(88, 'App\\Models\\User', 242),
(88, 'App\\Models\\User', 243),
(88, 'App\\Models\\User', 244),
(88, 'App\\Models\\User', 245),
(88, 'App\\Models\\User', 246),
(88, 'App\\Models\\User', 247),
(88, 'App\\Models\\User', 248),
(88, 'App\\Models\\User', 249),
(60, 'App\\Models\\User', 250),
(88, 'App\\Models\\User', 251),
(60, 'App\\Models\\User', 252),
(88, 'App\\Models\\User', 256),
(88, 'App\\Models\\User', 257),
(88, 'App\\Models\\User', 258),
(88, 'App\\Models\\User', 259),
(88, 'App\\Models\\User', 260),
(60, 'App\\Models\\User', 261),
(63, 'App\\Models\\User', 262),
(88, 'App\\Models\\User', 263),
(88, 'App\\Models\\User', 264),
(88, 'App\\Models\\User', 265),
(88, 'App\\Models\\User', 266),
(88, 'App\\Models\\User', 267),
(88, 'App\\Models\\User', 268),
(60, 'App\\Models\\User', 269),
(88, 'App\\Models\\User', 270),
(88, 'App\\Models\\User', 271),
(88, 'App\\Models\\User', 273),
(60, 'App\\Models\\User', 274),
(88, 'App\\Models\\User', 275),
(88, 'App\\Models\\User', 276),
(88, 'App\\Models\\User', 277),
(88, 'App\\Models\\User', 278),
(88, 'App\\Models\\User', 279),
(88, 'App\\Models\\User', 280),
(88, 'App\\Models\\User', 283),
(88, 'App\\Models\\User', 284),
(88, 'App\\Models\\User', 285),
(88, 'App\\Models\\User', 286),
(88, 'App\\Models\\User', 287),
(88, 'App\\Models\\User', 291),
(88, 'App\\Models\\User', 292),
(60, 'App\\Models\\User', 293),
(88, 'App\\Models\\User', 294),
(88, 'App\\Models\\User', 296),
(88, 'App\\Models\\User', 297),
(60, 'App\\Models\\User', 298),
(88, 'App\\Models\\User', 299),
(88, 'App\\Models\\User', 300),
(88, 'App\\Models\\User', 301),
(88, 'App\\Models\\User', 302),
(88, 'App\\Models\\User', 305),
(88, 'App\\Models\\User', 306),
(88, 'App\\Models\\User', 307),
(88, 'App\\Models\\User', 308),
(88, 'App\\Models\\User', 309),
(88, 'App\\Models\\User', 310),
(88, 'App\\Models\\User', 311),
(88, 'App\\Models\\User', 312),
(88, 'App\\Models\\User', 313),
(88, 'App\\Models\\User', 314),
(88, 'App\\Models\\User', 315),
(88, 'App\\Models\\User', 316),
(88, 'App\\Models\\User', 320),
(88, 'App\\Models\\User', 324),
(88, 'App\\Models\\User', 327),
(88, 'App\\Models\\User', 328),
(60, 'App\\Models\\User', 331),
(88, 'App\\Models\\User', 332),
(88, 'App\\Models\\User', 333),
(88, 'App\\Models\\User', 334),
(88, 'App\\Models\\User', 335),
(63, 'App\\Models\\User', 336),
(88, 'App\\Models\\User', 337),
(88, 'App\\Models\\User', 338),
(88, 'App\\Models\\User', 339),
(88, 'App\\Models\\User', 341),
(88, 'App\\Models\\User', 342),
(88, 'App\\Models\\User', 343),
(88, 'App\\Models\\User', 344),
(88, 'App\\Models\\User', 345),
(88, 'App\\Models\\User', 346),
(88, 'App\\Models\\User', 347),
(88, 'App\\Models\\User', 349),
(60, 'App\\Models\\User', 351),
(88, 'App\\Models\\User', 354),
(88, 'App\\Models\\User', 357),
(88, 'App\\Models\\User', 362),
(88, 'App\\Models\\User', 366),
(63, 'App\\Models\\User', 367),
(88, 'App\\Models\\User', 371),
(88, 'App\\Models\\User', 372),
(88, 'App\\Models\\User', 373),
(88, 'App\\Models\\User', 375),
(88, 'App\\Models\\User', 376),
(88, 'App\\Models\\User', 377),
(60, 'App\\Models\\User', 380),
(88, 'App\\Models\\User', 383),
(88, 'App\\Models\\User', 384),
(60, 'App\\Models\\User', 385),
(88, 'App\\Models\\User', 387),
(88, 'App\\Models\\User', 388),
(88, 'App\\Models\\User', 389),
(88, 'App\\Models\\User', 390),
(88, 'App\\Models\\User', 391),
(88, 'App\\Models\\User', 392),
(88, 'App\\Models\\User', 393),
(88, 'App\\Models\\User', 395),
(88, 'App\\Models\\User', 396),
(88, 'App\\Models\\User', 399),
(88, 'App\\Models\\User', 400),
(88, 'App\\Models\\User', 401),
(88, 'App\\Models\\User', 404),
(88, 'App\\Models\\User', 405),
(88, 'App\\Models\\User', 407),
(88, 'App\\Models\\User', 408),
(60, 'App\\Models\\User', 409),
(88, 'App\\Models\\User', 410),
(60, 'App\\Models\\User', 414),
(88, 'App\\Models\\User', 415),
(88, 'App\\Models\\User', 416),
(88, 'App\\Models\\User', 417),
(88, 'App\\Models\\User', 419),
(88, 'App\\Models\\User', 420),
(88, 'App\\Models\\User', 421),
(88, 'App\\Models\\User', 422),
(88, 'App\\Models\\User', 423),
(88, 'App\\Models\\User', 424),
(88, 'App\\Models\\User', 425),
(88, 'App\\Models\\User', 426),
(88, 'App\\Models\\User', 427),
(88, 'App\\Models\\User', 428),
(88, 'App\\Models\\User', 429),
(88, 'App\\Models\\User', 430),
(88, 'App\\Models\\User', 431),
(88, 'App\\Models\\User', 433),
(88, 'App\\Models\\User', 434),
(88, 'App\\Models\\User', 435),
(88, 'App\\Models\\User', 436),
(88, 'App\\Models\\User', 437),
(88, 'App\\Models\\User', 438),
(88, 'App\\Models\\User', 441),
(88, 'App\\Models\\User', 442),
(88, 'App\\Models\\User', 443),
(88, 'App\\Models\\User', 445),
(88, 'App\\Models\\User', 446),
(88, 'App\\Models\\User', 447),
(88, 'App\\Models\\User', 448),
(88, 'App\\Models\\User', 449),
(88, 'App\\Models\\User', 450),
(88, 'App\\Models\\User', 451),
(60, 'App\\Models\\User', 452),
(88, 'App\\Models\\User', 453),
(88, 'App\\Models\\User', 454),
(88, 'App\\Models\\User', 456),
(60, 'App\\Models\\User', 457),
(88, 'App\\Models\\User', 458),
(88, 'App\\Models\\User', 459),
(88, 'App\\Models\\User', 460),
(88, 'App\\Models\\User', 461),
(60, 'App\\Models\\User', 462),
(88, 'App\\Models\\User', 464),
(88, 'App\\Models\\User', 465),
(88, 'App\\Models\\User', 467),
(88, 'App\\Models\\User', 468),
(88, 'App\\Models\\User', 469),
(60, 'App\\Models\\User', 471),
(88, 'App\\Models\\User', 472),
(88, 'App\\Models\\User', 473),
(88, 'App\\Models\\User', 474),
(88, 'App\\Models\\User', 475),
(88, 'App\\Models\\User', 477),
(88, 'App\\Models\\User', 478),
(88, 'App\\Models\\User', 479),
(88, 'App\\Models\\User', 480),
(88, 'App\\Models\\User', 481),
(88, 'App\\Models\\User', 482),
(88, 'App\\Models\\User', 484),
(88, 'App\\Models\\User', 485),
(88, 'App\\Models\\User', 486),
(88, 'App\\Models\\User', 487),
(88, 'App\\Models\\User', 488),
(88, 'App\\Models\\User', 489),
(88, 'App\\Models\\User', 490),
(88, 'App\\Models\\User', 491),
(88, 'App\\Models\\User', 493),
(60, 'App\\Models\\User', 496),
(88, 'App\\Models\\User', 497),
(88, 'App\\Models\\User', 498),
(88, 'App\\Models\\User', 500),
(88, 'App\\Models\\User', 502),
(88, 'App\\Models\\User', 503),
(88, 'App\\Models\\User', 504),
(60, 'App\\Models\\User', 505),
(88, 'App\\Models\\User', 507),
(88, 'App\\Models\\User', 508),
(88, 'App\\Models\\User', 510),
(88, 'App\\Models\\User', 512),
(88, 'App\\Models\\User', 513),
(88, 'App\\Models\\User', 514),
(88, 'App\\Models\\User', 515),
(88, 'App\\Models\\User', 516),
(88, 'App\\Models\\User', 517),
(88, 'App\\Models\\User', 518),
(88, 'App\\Models\\User', 519),
(88, 'App\\Models\\User', 521),
(88, 'App\\Models\\User', 522),
(88, 'App\\Models\\User', 523),
(88, 'App\\Models\\User', 524),
(88, 'App\\Models\\User', 525),
(88, 'App\\Models\\User', 527),
(88, 'App\\Models\\User', 532),
(88, 'App\\Models\\User', 534),
(88, 'App\\Models\\User', 535),
(88, 'App\\Models\\User', 540),
(88, 'App\\Models\\User', 541),
(88, 'App\\Models\\User', 545),
(88, 'App\\Models\\User', 546),
(88, 'App\\Models\\User', 547),
(88, 'App\\Models\\User', 550),
(88, 'App\\Models\\User', 551),
(88, 'App\\Models\\User', 553),
(88, 'App\\Models\\User', 556),
(88, 'App\\Models\\User', 557),
(88, 'App\\Models\\User', 560),
(88, 'App\\Models\\User', 562),
(88, 'App\\Models\\User', 563),
(88, 'App\\Models\\User', 564),
(88, 'App\\Models\\User', 565),
(88, 'App\\Models\\User', 566),
(60, 'App\\Models\\User', 572),
(88, 'App\\Models\\User', 575),
(88, 'App\\Models\\User', 578),
(88, 'App\\Models\\User', 580),
(88, 'App\\Models\\User', 581),
(88, 'App\\Models\\User', 582),
(88, 'App\\Models\\User', 583),
(88, 'App\\Models\\User', 584),
(88, 'App\\Models\\User', 587),
(88, 'App\\Models\\User', 597),
(88, 'App\\Models\\User', 599),
(88, 'App\\Models\\User', 601),
(88, 'App\\Models\\User', 602),
(63, 'App\\Models\\User', 604),
(88, 'App\\Models\\User', 606),
(88, 'App\\Models\\User', 610),
(88, 'App\\Models\\User', 613),
(88, 'App\\Models\\User', 616),
(88, 'App\\Models\\User', 617),
(60, 'App\\Models\\User', 619),
(63, 'App\\Models\\User', 620),
(60, 'App\\Models\\User', 621),
(60, 'App\\Models\\User', 623),
(60, 'App\\Models\\User', 624),
(60, 'App\\Models\\User', 625),
(60, 'App\\Models\\User', 626),
(88, 'App\\Models\\User', 627),
(60, 'App\\Models\\User', 629),
(88, 'App\\Models\\User', 631),
(60, 'App\\Models\\User', 632),
(60, 'App\\Models\\User', 633),
(88, 'App\\Models\\User', 634),
(88, 'App\\Models\\User', 638),
(88, 'App\\Models\\User', 648),
(63, 'App\\Models\\User', 651),
(60, 'App\\Models\\User', 652),
(60, 'App\\Models\\User', 653),
(60, 'App\\Models\\User', 654),
(60, 'App\\Models\\User', 655),
(60, 'App\\Models\\User', 656),
(60, 'App\\Models\\User', 657),
(60, 'App\\Models\\User', 658),
(88, 'App\\Models\\User', 659),
(60, 'App\\Models\\User', 660),
(88, 'App\\Models\\User', 662),
(88, 'App\\Models\\User', 663),
(88, 'App\\Models\\User', 668),
(88, 'App\\Models\\User', 670),
(60, 'App\\Models\\User', 684),
(88, 'App\\Models\\User', 685),
(60, 'App\\Models\\User', 691),
(60, 'App\\Models\\User', 692),
(60, 'App\\Models\\User', 693),
(60, 'App\\Models\\User', 694),
(60, 'App\\Models\\User', 696),
(88, 'App\\Models\\User', 700),
(88, 'App\\Models\\User', 703),
(88, 'App\\Models\\User', 705),
(88, 'App\\Models\\User', 706),
(88, 'App\\Models\\User', 707),
(88, 'App\\Models\\User', 708),
(88, 'App\\Models\\User', 711),
(60, 'App\\Models\\User', 712),
(113, 'App\\Models\\User', 713),
(113, 'App\\Models\\User', 715),
(113, 'App\\Models\\User', 717),
(60, 'App\\Models\\User', 718),
(60, 'App\\Models\\User', 728),
(60, 'App\\Models\\User', 729),
(60, 'App\\Models\\User', 730),
(51, 'App\\Models\\User', 731),
(60, 'App\\Models\\User', 732),
(60, 'App\\Models\\User', 733),
(60, 'App\\Models\\User', 734),
(61, 'App\\Models\\User', 735),
(89, 'App\\Models\\User', 736),
(61, 'App\\Models\\User', 737),
(102, 'App\\Models\\User', 740),
(61, 'App\\Models\\User', 741),
(65, 'App\\Models\\User', 742),
(89, 'App\\Models\\User', 745);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  ADD KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`);

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `model_has_roles`
--
ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;
COMMIT;



-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `role_has_permissions`
--

CREATE TABLE `role_has_permissions` (
  `permission_id` bigint UNSIGNED NOT NULL,
  `role_id` bigint UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `role_has_permissions`
--

INSERT INTO `role_has_permissions` (`permission_id`, `role_id`) VALUES
(1, 51),
(2, 51),
(3, 51),
(5, 51),
(35, 51),
(36, 51),
(37, 51),
(39, 51),
(46, 51),
(49, 51),
(50, 51),
(52, 51),
(53, 51),
(54, 51),
(55, 51),
(57, 51),
(58, 51),
(59, 51),
(60, 51),
(61, 51),
(62, 51),
(63, 51),
(64, 51),
(103, 51),
(106, 51),
(107, 51),
(108, 51),
(110, 51),
(112, 51),
(122, 51),
(123, 51),
(124, 51),
(125, 51),
(130, 51),
(131, 51),
(132, 51),
(133, 51),
(134, 51),
(135, 51),
(136, 51),
(137, 51),
(138, 51),
(139, 51),
(140, 51),
(141, 51),
(146, 51),
(147, 51),
(148, 51),
(149, 51),
(154, 51),
(155, 51),
(156, 51),
(157, 51),
(1, 60),
(2, 60),
(3, 60),
(5, 60),
(35, 60),
(36, 60),
(37, 60),
(39, 60),
(46, 60),
(49, 60),
(50, 60),
(52, 60),
(53, 60),
(54, 60),
(55, 60),
(57, 60),
(58, 60),
(59, 60),
(60, 60),
(61, 60),
(62, 60),
(63, 60),
(64, 60),
(65, 60),
(66, 60),
(103, 60),
(108, 60),
(109, 60),
(110, 60),
(112, 60),
(122, 60),
(123, 60),
(124, 60),
(125, 60),
(138, 60),
(139, 60),
(140, 60),
(141, 60),
(142, 60),
(143, 60),
(144, 60),
(145, 60),
(146, 60),
(147, 60),
(148, 60),
(149, 60),
(154, 60),
(155, 60),
(156, 60),
(157, 60),
(1, 61),
(2, 61),
(3, 61),
(5, 61),
(35, 61),
(36, 61),
(37, 61),
(39, 61),
(46, 61),
(49, 61),
(50, 61),
(52, 61),
(53, 61),
(54, 61),
(55, 61),
(57, 61),
(58, 61),
(59, 61),
(60, 61),
(61, 61),
(62, 61),
(63, 61),
(64, 61),
(65, 61),
(66, 61),
(103, 61),
(106, 61),
(109, 61),
(110, 61),
(122, 61),
(123, 61),
(124, 61),
(125, 61),
(130, 61),
(131, 61),
(132, 61),
(133, 61),
(142, 61),
(143, 61),
(144, 61),
(145, 61),
(146, 61),
(147, 61),
(148, 61),
(149, 61),
(1, 62),
(5, 62),
(49, 62),
(50, 62),
(52, 62),
(53, 62),
(54, 62),
(55, 62),
(57, 62),
(58, 62),
(1, 63),
(3, 63),
(35, 63),
(36, 63),
(37, 63),
(39, 63),
(46, 63),
(49, 63),
(50, 63),
(52, 63),
(53, 63),
(63, 63),
(64, 63),
(65, 63),
(66, 63),
(103, 63),
(109, 63),
(110, 63),
(111, 63),
(122, 63),
(123, 63),
(124, 63),
(125, 63),
(142, 63),
(143, 63),
(144, 63),
(145, 63),
(146, 63),
(147, 63),
(148, 63),
(149, 63),
(150, 63),
(151, 63),
(152, 63),
(153, 63),
(1, 64),
(3, 64),
(35, 64),
(36, 64),
(37, 64),
(39, 64),
(49, 64),
(50, 64),
(52, 64),
(53, 64),
(103, 64),
(109, 64),
(110, 64),
(111, 64),
(122, 64),
(123, 64),
(124, 64),
(125, 64),
(142, 64),
(143, 64),
(144, 64),
(145, 64),
(146, 64),
(147, 64),
(148, 64),
(149, 64),
(150, 64),
(151, 64),
(152, 64),
(153, 64),
(1, 65),
(2, 65),
(3, 65),
(4, 65),
(5, 65),
(29, 65),
(30, 65),
(33, 65),
(34, 65),
(35, 65),
(36, 65),
(37, 65),
(39, 65),
(40, 65),
(42, 65),
(44, 65),
(46, 65),
(47, 65),
(49, 65),
(50, 65),
(52, 65),
(53, 65),
(54, 65),
(55, 65),
(57, 65),
(58, 65),
(59, 65),
(60, 65),
(61, 65),
(62, 65),
(63, 65),
(64, 65),
(65, 65),
(66, 65),
(67, 65),
(68, 65),
(69, 65),
(70, 65),
(82, 65),
(83, 65),
(84, 65),
(85, 65),
(93, 65),
(94, 65),
(95, 65),
(96, 65),
(97, 65),
(98, 65),
(99, 65),
(100, 65),
(101, 65),
(102, 65),
(103, 65),
(104, 65),
(106, 65),
(107, 65),
(108, 65),
(109, 65),
(110, 65),
(111, 65),
(112, 65),
(113, 65),
(114, 65),
(116, 65),
(117, 65),
(118, 65),
(119, 65),
(120, 65),
(121, 65),
(122, 65),
(123, 65),
(124, 65),
(125, 65),
(126, 65),
(127, 65),
(128, 65),
(129, 65),
(130, 65),
(131, 65),
(132, 65),
(133, 65),
(134, 65),
(135, 65),
(136, 65),
(137, 65),
(138, 65),
(139, 65),
(140, 65),
(141, 65),
(142, 65),
(143, 65),
(144, 65),
(145, 65),
(146, 65),
(147, 65),
(148, 65),
(149, 65),
(150, 65),
(151, 65),
(152, 65),
(153, 65),
(154, 65),
(155, 65),
(156, 65),
(157, 65),
(1, 66),
(2, 66),
(3, 66),
(5, 66),
(35, 66),
(36, 66),
(37, 66),
(39, 66),
(46, 66),
(49, 66),
(50, 66),
(52, 66),
(53, 66),
(54, 66),
(55, 66),
(57, 66),
(58, 66),
(59, 66),
(60, 66),
(61, 66),
(62, 66),
(63, 66),
(64, 66),
(65, 66),
(66, 66),
(101, 66),
(103, 66),
(106, 66),
(108, 66),
(109, 66),
(110, 66),
(111, 66),
(112, 66),
(118, 66),
(119, 66),
(120, 66),
(121, 66),
(122, 66),
(123, 66),
(124, 66),
(125, 66),
(130, 66),
(131, 66),
(132, 66),
(133, 66),
(138, 66),
(139, 66),
(140, 66),
(141, 66),
(142, 66),
(143, 66),
(144, 66),
(145, 66),
(146, 66),
(147, 66),
(148, 66),
(149, 66),
(150, 66),
(151, 66),
(152, 66),
(153, 66),
(154, 66),
(155, 66),
(156, 66),
(157, 66),
(1, 67),
(2, 67),
(3, 67),
(5, 67),
(35, 67),
(36, 67),
(37, 67),
(39, 67),
(46, 67),
(49, 67),
(50, 67),
(52, 67),
(53, 67),
(54, 67),
(55, 67),
(57, 67),
(58, 67),
(59, 67),
(60, 67),
(61, 67),
(62, 67),
(63, 67),
(64, 67),
(65, 67),
(66, 67),
(101, 67),
(106, 67),
(109, 67),
(110, 67),
(111, 67),
(118, 67),
(119, 67),
(120, 67),
(121, 67),
(130, 67),
(131, 67),
(132, 67),
(133, 67),
(142, 67),
(143, 67),
(144, 67),
(145, 67),
(146, 67),
(147, 67),
(148, 67),
(149, 67),
(150, 67),
(151, 67),
(152, 67),
(153, 67),
(1, 68),
(2, 68),
(3, 68),
(5, 68),
(35, 68),
(36, 68),
(37, 68),
(39, 68),
(46, 68),
(49, 68),
(50, 68),
(52, 68),
(53, 68),
(54, 68),
(55, 68),
(57, 68),
(58, 68),
(59, 68),
(60, 68),
(61, 68),
(62, 68),
(63, 68),
(64, 68),
(65, 68),
(66, 68),
(101, 68),
(103, 68),
(106, 68),
(107, 68),
(108, 68),
(109, 68),
(110, 68),
(111, 68),
(112, 68),
(118, 68),
(119, 68),
(120, 68),
(121, 68),
(122, 68),
(123, 68),
(124, 68),
(125, 68),
(130, 68),
(131, 68),
(132, 68),
(133, 68),
(134, 68),
(135, 68),
(136, 68),
(137, 68),
(138, 68),
(139, 68),
(140, 68),
(141, 68),
(142, 68),
(143, 68),
(144, 68),
(145, 68),
(146, 68),
(147, 68),
(148, 68),
(149, 68),
(150, 68),
(151, 68),
(152, 68),
(153, 68),
(154, 68),
(155, 68),
(156, 68),
(157, 68),
(1, 82),
(2, 82),
(3, 82),
(5, 82),
(35, 82),
(36, 82),
(37, 82),
(39, 82),
(46, 82),
(49, 82),
(50, 82),
(52, 82),
(53, 82),
(55, 82),
(57, 82),
(58, 82),
(59, 82),
(60, 82),
(61, 82),
(62, 82),
(63, 82),
(64, 82),
(65, 82),
(66, 82),
(101, 82),
(103, 82),
(106, 82),
(107, 82),
(109, 82),
(110, 82),
(111, 82),
(112, 82),
(118, 82),
(119, 82),
(120, 82),
(121, 82),
(122, 82),
(123, 82),
(124, 82),
(125, 82),
(130, 82),
(131, 82),
(132, 82),
(133, 82),
(134, 82),
(135, 82),
(136, 82),
(137, 82),
(142, 82),
(143, 82),
(144, 82),
(145, 82),
(146, 82),
(147, 82),
(148, 82),
(149, 82),
(150, 82),
(151, 82),
(152, 82),
(153, 82),
(154, 82),
(155, 82),
(156, 82),
(157, 82),
(1, 88),
(5, 88),
(49, 88),
(50, 88),
(52, 88),
(53, 88),
(54, 88),
(55, 88),
(57, 88),
(58, 88),
(1, 89),
(5, 89),
(49, 89),
(50, 89),
(52, 89),
(53, 89),
(54, 89),
(55, 89),
(57, 89),
(58, 89),
(1, 90),
(2, 90),
(3, 90),
(5, 90),
(35, 90),
(36, 90),
(37, 90),
(39, 90),
(46, 90),
(49, 90),
(50, 90),
(52, 90),
(53, 90),
(54, 90),
(55, 90),
(57, 90),
(58, 90),
(59, 90),
(60, 90),
(61, 90),
(62, 90),
(63, 90),
(64, 90),
(65, 90),
(66, 90),
(108, 90),
(109, 90),
(138, 90),
(139, 90),
(140, 90),
(141, 90),
(142, 90),
(143, 90),
(144, 90),
(145, 90),
(1, 102),
(3, 102),
(5, 102),
(35, 102),
(36, 102),
(37, 102),
(39, 102),
(49, 102),
(50, 102),
(52, 102),
(53, 102),
(54, 102),
(55, 102),
(57, 102),
(58, 102),
(1, 103),
(2, 103),
(3, 103),
(4, 103),
(5, 103),
(29, 103),
(30, 103),
(33, 103),
(34, 103),
(35, 103),
(36, 103),
(37, 103),
(39, 103),
(40, 103),
(42, 103),
(44, 103),
(46, 103),
(47, 103),
(49, 103),
(50, 103),
(52, 103),
(53, 103),
(54, 103),
(55, 103),
(57, 103),
(58, 103),
(59, 103),
(60, 103),
(61, 103),
(62, 103),
(63, 103),
(64, 103),
(65, 103),
(66, 103),
(67, 103),
(68, 103),
(69, 103),
(70, 103),
(82, 103),
(83, 103),
(84, 103),
(85, 103),
(93, 103),
(94, 103),
(95, 103),
(96, 103),
(97, 103),
(98, 103),
(99, 103),
(100, 103),
(101, 103),
(102, 103),
(103, 103),
(104, 103),
(106, 103),
(107, 103),
(108, 103),
(109, 103),
(110, 103),
(111, 103),
(112, 103),
(113, 103),
(114, 103),
(116, 103),
(117, 103),
(118, 103),
(119, 103),
(120, 103),
(121, 103),
(122, 103),
(123, 103),
(124, 103),
(125, 103),
(126, 103),
(127, 103),
(128, 103),
(129, 103),
(130, 103),
(131, 103),
(132, 103),
(133, 103),
(134, 103),
(135, 103),
(136, 103),
(137, 103),
(138, 103),
(139, 103),
(140, 103),
(141, 103),
(142, 103),
(143, 103),
(144, 103),
(145, 103),
(146, 103),
(147, 103),
(148, 103),
(149, 103),
(150, 103),
(151, 103),
(152, 103),
(153, 103),
(154, 103),
(155, 103),
(156, 103),
(157, 103),
(1, 104),
(2, 104),
(3, 104),
(4, 104),
(5, 104),
(44, 104),
(46, 104),
(47, 104),
(101, 104),
(102, 104),
(103, 104),
(104, 104),
(106, 104),
(107, 104),
(108, 104),
(109, 104),
(110, 104),
(111, 104),
(112, 104),
(1, 105),
(2, 105),
(3, 105),
(4, 105),
(5, 105),
(44, 105),
(46, 105),
(47, 105),
(101, 105),
(102, 105),
(103, 105),
(104, 105),
(106, 105),
(107, 105),
(108, 105),
(109, 105),
(110, 105),
(111, 105),
(112, 105),
(1, 106),
(2, 106),
(3, 106),
(4, 106),
(5, 106),
(44, 106),
(46, 106),
(47, 106),
(101, 106),
(102, 106),
(103, 106),
(104, 106),
(106, 106),
(107, 106),
(108, 106),
(109, 106),
(110, 106),
(111, 106),
(112, 106),
(1, 107),
(2, 107),
(3, 107),
(4, 107),
(5, 107),
(44, 107),
(46, 107),
(47, 107),
(101, 107),
(102, 107),
(103, 107),
(104, 107),
(106, 107),
(107, 107),
(108, 107),
(109, 107),
(110, 107),
(111, 107),
(112, 107),
(1, 108),
(2, 108),
(3, 108),
(4, 108),
(5, 108),
(29, 108),
(30, 108),
(33, 108),
(34, 108),
(35, 108),
(36, 108),
(37, 108),
(39, 108),
(44, 108),
(46, 108),
(47, 108),
(49, 108),
(50, 108),
(52, 108),
(53, 108),
(54, 108),
(55, 108),
(57, 108),
(58, 108),
(59, 108),
(60, 108),
(61, 108),
(62, 108),
(63, 108),
(64, 108),
(65, 108),
(66, 108),
(67, 108),
(68, 108),
(69, 108),
(70, 108),
(82, 108),
(83, 108),
(84, 108),
(85, 108),
(101, 108),
(102, 108),
(103, 108),
(104, 108),
(106, 108),
(107, 108),
(108, 108),
(109, 108),
(110, 108),
(111, 108),
(112, 108),
(113, 108),
(114, 108),
(116, 108),
(117, 108),
(118, 108),
(119, 108),
(120, 108),
(121, 108),
(122, 108),
(123, 108),
(124, 108),
(125, 108),
(126, 108),
(127, 108),
(128, 108),
(129, 108),
(130, 108),
(131, 108),
(132, 108),
(133, 108),
(134, 108),
(135, 108),
(136, 108),
(137, 108),
(138, 108),
(139, 108),
(140, 108),
(141, 108),
(142, 108),
(143, 108),
(144, 108),
(145, 108),
(146, 108),
(147, 108),
(148, 108),
(149, 108),
(150, 108),
(151, 108),
(152, 108),
(153, 108),
(154, 108),
(155, 108),
(156, 108),
(157, 108),
(1, 109),
(2, 109),
(3, 109),
(4, 109),
(5, 109),
(44, 109),
(46, 109),
(47, 109),
(101, 109),
(102, 109),
(103, 109),
(104, 109),
(106, 109),
(107, 109),
(108, 109),
(109, 109),
(110, 109),
(111, 109),
(112, 109),
(2, 110),
(1, 112),
(2, 112),
(3, 112),
(4, 112),
(5, 112),
(29, 112),
(33, 112),
(34, 112),
(35, 112),
(36, 112),
(37, 112),
(39, 112),
(40, 112),
(42, 112),
(44, 112),
(46, 112),
(47, 112),
(49, 112),
(50, 112),
(52, 112),
(53, 112),
(54, 112),
(55, 112),
(57, 112),
(58, 112),
(59, 112),
(60, 112),
(61, 112),
(62, 112),
(63, 112),
(64, 112),
(65, 112),
(66, 112),
(67, 112),
(68, 112),
(69, 112),
(70, 112),
(82, 112),
(83, 112),
(84, 112),
(85, 112),
(93, 112),
(94, 112),
(95, 112),
(96, 112),
(97, 112),
(98, 112),
(99, 112),
(100, 112),
(101, 112),
(102, 112),
(103, 112),
(104, 112),
(106, 112),
(107, 112),
(108, 112),
(109, 112),
(110, 112),
(111, 112),
(112, 112),
(113, 112),
(114, 112),
(116, 112),
(117, 112),
(118, 112),
(119, 112),
(120, 112),
(121, 112),
(122, 112),
(123, 112),
(124, 112),
(125, 112),
(126, 112),
(127, 112),
(128, 112),
(129, 112),
(130, 112),
(131, 112),
(132, 112),
(133, 112),
(134, 112),
(135, 112),
(136, 112),
(137, 112),
(138, 112),
(139, 112),
(140, 112),
(141, 112),
(142, 112),
(143, 112),
(144, 112),
(145, 112),
(146, 112),
(147, 112),
(148, 112),
(149, 112),
(150, 112),
(151, 112),
(152, 112),
(153, 112),
(154, 112),
(155, 112),
(156, 112),
(157, 112),
(1, 113),
(5, 113),
(49, 113),
(50, 113),
(52, 113),
(53, 113),
(54, 113),
(55, 113),
(57, 113),
(58, 113);

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `role_has_permissions_role_id_foreign` (`role_id`);

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `role_has_permissions`
--
ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;
COMMIT;


-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `cms_order_detail`
--

CREATE TABLE `cms_order_detail` (
  `ID` int NOT NULL,
  `product_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `price` int DEFAULT NULL,
  `bid_id` int DEFAULT NULL,
  `order_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `product_code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_bids` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `cms_order_detail`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `cms_order_detail`
--
ALTER TABLE `cms_order_detail`
  MODIFY `ID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=620;
COMMIT;




-- chuyen data bang order sang order-detail
public function get(){
        $orders = Order::all();
        foreach($orders as $order){
            $orderID = $order->ID;
            $detailOrders = json_decode($order->detail_order, true);
            if($detailOrders){
                foreach ($detailOrders as $detailOrder) {
                    if(isset($detailOrder['quantity']) && is_numeric($detailOrder['quantity']) && isset($detailOrder['bid_id'])) {
                        $orderDetail = new OrderDetail();
                        $product = Product::find($detailOrder['id']);
                        if($product){
                            $orderDetail->product_name = $product->prd_name;
                            $orderDetail->product_code = $product->prd_code;
                            $orderDetail->quantity = $detailOrder['quantity'];
                            $orderDetail->product_id = $detailOrder['id']; 
                            $orderDetail->bid_id = $detailOrder['bid_id'];
                            $orderDetail->price = $detailOrder['price'];
                            $orderDetail->order_id = $orderID; 
                            $orderDetail->save();
                        } else {

                        }
                    }
                }
            }
        }
        return response()->json(['message' => 'Order details saved successfully']);
    }


--------coong no chi tiet
public function get(){
        $orders = OrderPx::all();
        foreach($orders->chunk(10000) as $chunk){
            foreach($chunk as $order){
                $orderID = $order->ID;
                $detailOrders = json_decode($order->detail_order, true);
                if($detailOrders){
                    foreach ($detailOrders as $detailOrder) {
                        if(isset($detailOrder['quantity']) && is_numeric($detailOrder['quantity']) && isset($detailOrder['bid_id'])) {
                            $orderDetail = new DebtsDetail();
                                $product = Product::find($detailOrder['id']);
                                $orderDetail->product_name = $product->prd_name;
                                $orderDetail->product_code = $product->prd_code;
                                $orderDetail->quantity = $detailOrder['quantity'];
                                $orderDetail->product_id = $detailOrder['id']; 
                                $orderDetail->bid_id = $detailOrder['bid_id'];
                                $orderDetail->price = $detailOrder['price'];
                                $orderDetail->order_id = $orderID;     
                                $orderDetail->save();
                        }
                    }
                }
            }
        }
        return response()->json(['message' => 'Order details saved successfully']);
    } 