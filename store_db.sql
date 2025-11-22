-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3307
-- Tiempo de generación: 21-11-2025 a las 23:14:13
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `store_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cotizacions`
--

CREATE TABLE `cotizacions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sucursal_id` bigint(20) UNSIGNED DEFAULT NULL,
  `cliente_email` varchar(255) DEFAULT NULL,
  `productos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`productos`)),
  `total` decimal(12,2) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `cotizacions`
--

INSERT INTO `cotizacions` (`id`, `sucursal_id`, `cliente_email`, `productos`, `total`, `user_id`, `creado_en`, `created_at`, `updated_at`) VALUES
(1, 1, NULL, '\"[{\\\"producto_id\\\":1,\\\"cantidad\\\":1}]\"', 45.50, NULL, '2025-11-10 04:00:01', '2025-11-10 10:00:01', '2025-11-10 10:00:01'),
(2, 1, NULL, '\"[{\\\"producto_id\\\":1,\\\"cantidad\\\":1},{\\\"producto_id\\\":3,\\\"cantidad\\\":1}]\"', 70.50, NULL, '2025-11-10 04:04:49', '2025-11-10 10:04:49', '2025-11-10 10:04:49'),
(3, 1, NULL, '\"[{\\\"producto_id\\\":1,\\\"cantidad\\\":1},{\\\"producto_id\\\":2,\\\"cantidad\\\":1}]\"', 48.70, NULL, '2025-11-10 04:23:04', '2025-11-10 10:23:04', '2025-11-10 10:23:04'),
(4, 1, NULL, '\"[{\\\"producto_id\\\":1,\\\"cantidad\\\":1},{\\\"producto_id\\\":2,\\\"cantidad\\\":1},{\\\"producto_id\\\":3,\\\"cantidad\\\":1}]\"', 205.00, NULL, '2025-11-10 15:38:30', '2025-11-10 21:38:30', '2025-11-10 21:38:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventarios`
--

CREATE TABLE `inventarios` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `producto_id` bigint(20) UNSIGNED NOT NULL,
  `sucursal_id` bigint(20) UNSIGNED NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `inventarios`
--

INSERT INTO `inventarios` (`id`, `producto_id`, `sucursal_id`, `cantidad`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 64, '2025-11-08 10:54:13', '2025-11-10 21:39:59'),
(2, 2, 1, 6, '2025-11-08 10:54:13', '2025-11-10 21:39:59'),
(3, 3, 1, 20, '2025-11-08 10:54:13', '2025-11-10 21:39:59'),
(4, 4, 1, 44, '2025-11-08 10:54:13', '2025-11-10 07:07:34'),
(5, 5, 1, 27, '2025-11-08 10:54:13', '2025-11-08 10:54:13'),
(6, 1, 2, 13, '2025-11-08 10:54:13', '2025-11-08 10:54:13'),
(7, 2, 2, 10, '2025-11-08 10:54:13', '2025-11-10 14:32:26'),
(8, 3, 2, 30, '2025-11-08 10:54:13', '2025-11-10 11:27:25'),
(9, 4, 2, 17, '2025-11-08 10:54:13', '2025-11-08 10:54:13'),
(10, 5, 2, 49, '2025-11-08 10:54:13', '2025-11-08 10:54:13'),
(11, 1, 3, 40, '2025-11-08 10:54:13', '2025-11-08 10:54:13'),
(12, 2, 3, 39, '2025-11-08 10:54:13', '2025-11-08 10:54:13'),
(13, 3, 3, 19, '2025-11-08 10:54:13', '2025-11-08 10:54:13'),
(14, 4, 3, 49, '2025-11-08 10:54:13', '2025-11-08 10:54:13'),
(15, 5, 3, 38, '2025-11-08 10:54:13', '2025-11-08 10:54:13');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `logs`
--

CREATE TABLE `logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `accion` varchar(255) NOT NULL,
  `detalles` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `logs`
--

INSERT INTO `logs` (`id`, `user_id`, `accion`, `detalles`, `created_at`, `updated_at`) VALUES
(1, 4, 'ajustar_stock', 'sucursal:1 producto:1 qty:100', '2025-11-09 06:57:27', '2025-11-09 06:57:27'),
(2, 4, 'ajustar_stock', 'sucursal:1 producto:1 qty:100', '2025-11-09 07:08:12', '2025-11-09 07:08:12'),
(3, 4, 'venta_creada', 'venta:1', '2025-11-10 06:25:25', '2025-11-10 06:25:25'),
(4, 4, 'venta_creada', 'venta:2', '2025-11-10 06:27:36', '2025-11-10 06:27:36'),
(5, 4, 'venta_creada', 'venta:4', '2025-11-10 06:28:02', '2025-11-10 06:28:02'),
(6, 4, 'venta_creada', 'venta:5', '2025-11-10 06:28:08', '2025-11-10 06:28:08'),
(7, 4, 'venta_creada', 'venta:6', '2025-11-10 06:28:17', '2025-11-10 06:28:17'),
(8, 4, 'venta_creada', 'venta:8', '2025-11-10 06:54:33', '2025-11-10 06:54:33'),
(9, 4, 'venta_creada', 'venta:9', '2025-11-10 06:55:00', '2025-11-10 06:55:00'),
(10, 4, 'venta_creada', 'venta:10', '2025-11-10 07:04:31', '2025-11-10 07:04:31'),
(11, 6, 'venta_creada', 'venta:11', '2025-11-10 07:07:34', '2025-11-10 07:07:34'),
(12, NULL, 'cotizacion_creada', 'id:1', '2025-11-10 10:00:01', '2025-11-10 10:00:01'),
(13, NULL, 'cotizacion_creada', 'id:2', '2025-11-10 10:04:49', '2025-11-10 10:04:49'),
(14, NULL, 'cotizacion_creada', 'id:3', '2025-11-10 10:23:04', '2025-11-10 10:23:04'),
(15, 4, 'ajustar_stock', 'sucursal:2 producto:1 qty:13', '2025-11-10 10:56:28', '2025-11-10 10:56:28'),
(16, 4, 'ajustar_stock', 'sucursal:2 producto:3 qty:30', '2025-11-10 11:27:25', '2025-11-10 11:27:25'),
(17, 4, 'ajustar_stock', 'sucursal:1 producto:2 qty:10', '2025-11-10 11:28:52', '2025-11-10 11:28:52'),
(18, 4, 'producto_actualizado', 'id:1', '2025-11-10 11:40:03', '2025-11-10 11:40:03'),
(19, 4, 'producto_actualizado', 'id:2', '2025-11-10 11:41:30', '2025-11-10 11:41:30'),
(20, 4, 'producto_actualizado', 'id:3', '2025-11-10 11:42:19', '2025-11-10 11:42:19'),
(21, 4, 'producto_actualizado', 'id:4', '2025-11-10 11:42:59', '2025-11-10 11:42:59'),
(22, 4, 'producto_actualizado', 'id:5', '2025-11-10 11:43:56', '2025-11-10 11:43:56'),
(23, 4, 'traslado_creado', 'id:1', '2025-11-10 11:49:22', '2025-11-10 11:49:22'),
(24, 4, 'traslado_creado', 'id:2', '2025-11-10 11:51:40', '2025-11-10 11:51:40'),
(25, 4, 'traslado_creado', 'id:3', '2025-11-10 11:52:40', '2025-11-10 11:52:40'),
(26, 4, 'traslado_creado', 'id:4', '2025-11-10 11:54:31', '2025-11-10 11:54:31'),
(27, 4, 'traslado_creado', 'id:5', '2025-11-10 11:55:00', '2025-11-10 11:55:00'),
(28, 4, 'traslado_completado', 'id:5', '2025-11-10 12:16:57', '2025-11-10 12:16:57'),
(29, 4, 'producto_actualizado', 'id:1', '2025-11-10 14:16:25', '2025-11-10 14:16:25'),
(30, 4, 'producto_actualizado', 'id:2', '2025-11-10 14:19:16', '2025-11-10 14:19:16'),
(31, 4, 'ajustar_stock', 'sucursal:1 producto:2 qty:15', '2025-11-10 14:22:06', '2025-11-10 14:22:06'),
(32, 7, 'producto_actualizado', 'id:3', '2025-11-10 14:32:08', '2025-11-10 14:32:08'),
(33, 7, 'traslado_completado', 'id:2', '2025-11-10 14:32:26', '2025-11-10 14:32:26'),
(34, 7, 'ajustar_stock', 'sucursal:1 producto:2 qty:15', '2025-11-10 14:32:38', '2025-11-10 14:32:38'),
(35, 7, 'ajustar_stock', 'sucursal:1 producto:2 qty:7', '2025-11-10 15:24:10', '2025-11-10 15:24:10'),
(36, 4, 'producto_actualizado', 'id:6', '2025-11-10 21:36:22', '2025-11-10 21:36:22'),
(37, 4, 'producto_actualizado', 'id:7', '2025-11-10 21:37:13', '2025-11-10 21:37:13'),
(38, NULL, 'cotizacion_creada', 'id:4', '2025-11-10 21:38:30', '2025-11-10 21:38:30'),
(39, 4, 'venta_creada', 'venta:12', '2025-11-10 21:39:59', '2025-11-10 21:39:59'),
(40, 4, 'producto_actualizado', 'id:8', '2025-11-10 22:13:57', '2025-11-10 22:13:57');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_10_31_223505_create_personal_access_tokens_table', 1),
(5, '2025_10_31_223639_create_productos_table', 1),
(6, '2025_10_31_223640_create_sucursales_table', 2),
(7, '2025_10_31_223640_create_inventarios_table', 3),
(8, '2025_10_31_223641_create_ventas_table', 4),
(9, '2025_10_31_223642_create_traslados_table', 4),
(10, '2025_10_31_223642_create_venta_items_table', 4),
(11, '2025_10_31_223643_create_cotizacions_table', 4),
(12, '2025_10_31_223643_create_logs_table', 4),
(13, '2025_11_09_003042_add_role_to_users_table', 5),
(14, '2025_11_10_155919_add_user_id_to_traslados_table', 6);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 4, 'api-token', '09d65534e7a73624b396bb749f2137d92d1538a7f35dab8a63fff4488ddc054f', '[\"*\"]', NULL, NULL, '2025-11-09 04:38:04', '2025-11-09 04:38:04'),
(2, 'App\\Models\\User', 4, 'api-token', 'b6596b1bd67ca5e8435d83ed570872f2f6a26684218c84a271305241173fd371', '[\"*\"]', NULL, NULL, '2025-11-09 05:17:45', '2025-11-09 05:17:45'),
(3, 'App\\Models\\User', 4, 'api-token', '481260a0bf728527621e36e4c00c5d1742f6de7caca2a5c273c8e74781197d60', '[\"*\"]', '2025-11-10 06:30:20', NULL, '2025-11-09 05:35:53', '2025-11-10 06:30:20'),
(34, 'App\\Models\\User', 7, 'api-token', 'a768de158caa2efcf8f3c007afdb68a7aee3b1a7a5f0ed17f8833412aa143691', '[\"*\"]', NULL, NULL, '2025-11-10 13:18:54', '2025-11-10 13:18:54'),
(49, 'App\\Models\\User', 7, 'api-token', 'fe4d1c58f32e2c460988c7510d5a939e063f898e7dd8239c721772167b979b63', '[\"*\"]', '2025-11-10 22:16:25', NULL, '2025-11-10 22:14:26', '2025-11-10 22:16:25'),
(53, 'App\\Models\\User', 4, 'api-token', 'cbb1c6d0df41448b108d59e4fba4a954777b766933da3530b7391e4753c58333', '[\"*\"]', NULL, NULL, '2025-11-10 22:48:13', '2025-11-10 22:48:13');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `sku` varchar(255) DEFAULT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL DEFAULT 0.00,
  `imagen` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id`, `sku`, `nombre`, `descripcion`, `precio`, `imagen`, `created_at`, `updated_at`) VALUES
(1, 'P1001', 'Cafetera Expres', 'Cafetera pequeña 1.5L', 120.00, 'productos/OfWzGTZIyAXliFZb90EGYdMw7JzbVIvmO1Tb32CK.jpg', '2025-11-08 10:54:13', '2025-11-10 14:16:25'),
(2, 'P1002', 'Taza Cerámica', 'Taza 300ml', 20.00, 'productos/XPvqyHxy9e9iwSrXV4I9wmyE1TTxg3N90pG0QylX.webp', '2025-11-08 10:54:13', '2025-11-10 14:19:16'),
(3, 'P1003', 'Bolso Deportivo', 'Bolso para gimnasio', 65.00, 'productos/oyVQ72FiO6LmVOjTeq47UBxoGpBaamvC4zH3OlGa.jpg', '2025-11-08 10:54:13', '2025-11-10 14:32:08'),
(4, 'P1004', 'Auriculares', 'Inalámbricos bluetooth', 55.99, 'productos/pfvoJLy4a8vGPxqlfpn4y3JRL72iZX0oxDAoJMB5.jpg', '2025-11-08 10:54:13', '2025-11-10 11:42:59'),
(5, 'P1005', 'Linterna LED', 'Compacta, 200 lm', 8.75, 'productos/sIXDDlvVpcJpl7u5nFSP26dF9SX4F67lzabk4l9l.png', '2025-11-08 10:54:13', '2025-11-10 11:43:56'),
(6, 'P1006', 'Tarjeta Gráfica Modelo 1006', 'Tarjeta Gráfica de alta calidad modelo 1006', 1195.29, 'productos/um7i2LQpNllwowrHNl5fUGxl3aCnabQzReweSQlv.png', '2025-11-10 08:40:31', '2025-11-10 21:36:22'),
(7, 'P1007', 'Desktop Modelo 1007', 'Desktop de alta calidad modelo 1007', 1475.15, 'productos/jS9DAxkOmFxqLDQjb9HrqXrBllXPC8TLT5JkBrjn.webp', '2025-11-10 08:40:31', '2025-11-10 21:37:12'),
(8, 'P1008', 'Trípode Modelo 1008', 'Trípode de alta calidad modelo 1008', 649.72, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(9, 'P1009', 'Tarjeta SD Modelo 1009', 'Tarjeta SD de alta calidad modelo 1009', 614.32, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(10, 'P1010', 'Laptop Modelo 1010', 'Laptop de alta calidad modelo 1010', 766.87, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(11, 'P1011', 'Cámara Action Modelo 1011', 'Cámara Action de alta calidad modelo 1011', 486.32, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(12, 'P1012', 'UPS Modelo 1012', 'UPS de alta calidad modelo 1012', 1537.96, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(13, 'P1013', 'Monitor Modelo 1013', 'Monitor de alta calidad modelo 1013', 289.09, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(14, 'P1014', 'Memoria RAM Modelo 1014', 'Memoria RAM de alta calidad modelo 1014', 155.45, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(15, 'P1015', 'Cargador Modelo 1015', 'Cargador de alta calidad modelo 1015', 25.03, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(16, 'P1016', 'Lente 50mm Modelo 1016', 'Lente 50mm de alta calidad modelo 1016', 189.12, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(17, 'P1017', 'Gabinete Modelo 1017', 'Gabinete de alta calidad modelo 1017', 72.34, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(18, 'P1018', 'Smartwatch Modelo 1018', 'Smartwatch de alta calidad modelo 1018', 199.49, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(19, 'P1019', 'Router Modelo 1019', 'Router de alta calidad modelo 1019', 48.60, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(20, 'P1020', 'Teclado Mecánico Modelo 1020', 'Teclado Mecánico de alta calidad modelo 1020', 89.90, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(21, 'P1021', 'Mouse Modelo 1021', 'Mouse de alta calidad modelo 1021', 29.70, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(22, 'P1022', 'Celular Modelo 1022', 'Celular de alta calidad modelo 1022', 599.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(23, 'P1023', 'Tablet Modelo 1023', 'Tablet de alta calidad modelo 1023', 329.50, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(24, 'P1024', 'Disco SSD Modelo 1024', 'Disco SSD de alta calidad modelo 1024', 124.88, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(25, 'P1025', 'Impresora Modelo 1025', 'Impresora de alta calidad modelo 1025', 199.00, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(26, 'P1026', 'Micrófono Modelo 1026', 'Micrófono de alta calidad modelo 1026', 69.55, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(27, 'P1027', 'Soporte Modelo 1027', 'Soporte de alta calidad modelo 1027', 12.45, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(28, 'P1028', 'Bolso Laptop Modelo 1028', 'Bolso Laptop de alta calidad modelo 1028', 39.20, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(29, 'P1029', 'Cámara Fotográfica Modelo 1029', 'Cámara Fotográfica de alta calidad modelo 1029', 845.10, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(30, 'P1030', 'Lente 35mm Modelo 1030', 'Lente 35mm de alta calidad modelo 1030', 210.00, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(31, 'P1031', 'Base Enfriamiento Modelo 1031', 'Base Enfriamiento de alta calidad modelo 1031', 34.60, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(32, 'P1032', 'Adaptador Modelo 1032', 'Adaptador de alta calidad modelo 1032', 9.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(33, 'P1033', 'Hub USB Modelo 1033', 'Hub USB de alta calidad modelo 1033', 18.75, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(34, 'P1034', 'Cable HDMI Modelo 1034', 'Cable HDMI de alta calidad modelo 1034', 7.90, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(35, 'P1035', 'Bolso Deportivo Modelo 1035', 'Bolso Deportivo de alta calidad modelo 1035', 25.00, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(36, 'P1036', 'Micrófono Lavalier Modelo 1036', 'Micrófono Lavalier de alta calidad modelo 1036', 27.50, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(37, 'P1037', 'Cámara Vigilancia Modelo 1037', 'Cámara Vigilancia de alta calidad modelo 1037', 129.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(38, 'P1038', 'Proyector Modelo 1038', 'Proyector de alta calidad modelo 1038', 420.00, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(39, 'P1039', 'Smart TV Modelo 1039', 'Smart TV de alta calidad modelo 1039', 699.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(40, 'P1040', 'Tarjeta Gráfica Modelo 1040', 'Tarjeta Gráfica de alta calidad modelo 1040', 399.50, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(41, 'P1041', 'Memoria RAM Modelo 1041', 'Memoria RAM de alta calidad modelo 1041', 79.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(42, 'P1042', 'Mouse Gamer Modelo 1042', 'Mouse Gamer de alta calidad modelo 1042', 49.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(43, 'P1043', 'Auriculares Modelo 1043', 'Auriculares de alta calidad modelo 1043', 59.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(44, 'P1044', 'Batería Externa Modelo 1044', 'Batería Externa de alta calidad modelo 1044', 22.00, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(45, 'P1045', 'Cargador Rápido Modelo 1045', 'Cargador Rápido de alta calidad modelo 1045', 18.30, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(46, 'P1046', 'Gabinete Gaming Modelo 1046', 'Gabinete Gaming de alta calidad modelo 1046', 129.95, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(47, 'P1047', 'Fuente PC Modelo 1047', 'Fuente PC de alta calidad modelo 1047', 89.90, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(48, 'P1048', 'Adaptador USB-C Modelo 1048', 'Adaptador USB-C de alta calidad modelo 1048', 14.50, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(49, 'P1049', 'Soporte Monitor Modelo 1049', 'Soporte Monitor de alta calidad modelo 1049', 26.40, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(50, 'P1050', 'Maletín Modelo 1050', 'Maletín de alta calidad modelo 1050', 45.00, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(51, 'P1051', 'Cable de Audio Modelo 1051', 'Cable de Audio de alta calidad modelo 1051', 6.75, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(52, 'P1052', 'Lente Macro Modelo 1052', 'Lente Macro de alta calidad modelo 1052', 132.00, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(53, 'P1053', 'Trípode Profesional Modelo 1053', 'Trípode Profesional de alta calidad modelo 1053', 139.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(54, 'P1054', 'Estabilizador Gimbal Modelo 1054', 'Estabilizador Gimbal de alta calidad modelo 1054', 249.00, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(55, 'P1055', 'Cámara Web Modelo 1055', 'Cámara Web de alta calidad modelo 1055', 49.00, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(56, 'P1056', 'MicroSD 128GB Modelo 1056', 'MicroSD 128GB de alta calidad modelo 1056', 19.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(57, 'P1057', 'Router Mesh Modelo 1057', 'Router Mesh de alta calidad modelo 1057', 159.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(58, 'P1058', 'SSD NVMe Modelo 1058', 'SSD NVMe de alta calidad modelo 1058', 159.50, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(59, 'P1059', 'Tablet Pro Modelo 1059', 'Tablet Pro de alta calidad modelo 1059', 429.00, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(60, 'P1060', 'Auriculares Inalámbricos Modelo 1060', 'Auriculares Inalámbricos de alta calidad modelo 1060', 79.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(61, 'P1061', 'Micrófono Condensador Modelo 1061', 'Micrófono Condensador de alta calidad modelo 1061', 129.00, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(62, 'P1062', 'Base Carga Inalámbrica Modelo 1062', 'Base Carga Inalámbrica de alta calidad modelo 1062', 39.90, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(63, 'P1063', 'Monopod Modelo 1063', 'Monopod de alta calidad modelo 1063', 22.00, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(64, 'P1064', 'Kit Limpieza Cámara Modelo 1064', 'Kit Limpieza Cámara de alta calidad modelo 1064', 12.40, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(65, 'P1065', 'Soporte Tablet Modelo 1065', 'Soporte Tablet de alta calidad modelo 1065', 15.80, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(66, 'P1066', 'Hub Thunderbolt Modelo 1066', 'Hub Thunderbolt de alta calidad modelo 1066', 129.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(67, 'P1067', 'Auricular Gaming Modelo 1067', 'Auricular Gaming de alta calidad modelo 1067', 89.00, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(68, 'P1068', 'Mouse Inalámbrico Modelo 1068', 'Mouse Inalámbrico de alta calidad modelo 1068', 24.90, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(69, 'P1069', 'Cargador Portátil Modelo 1069', 'Cargador Portátil de alta calidad modelo 1069', 34.50, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(70, 'P1070', 'Pantalla HDR Modelo 1070', 'Pantalla HDR de alta calidad modelo 1070', 549.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(71, 'P1071', 'Soporte Laptop Modelo 1071', 'Soporte Laptop de alta calidad modelo 1071', 29.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(72, 'P1072', 'Tarjeta SD 64GB Modelo 1072', 'Tarjeta SD 64GB de alta calidad modelo 1072', 12.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(73, 'P1073', 'Lente Tele Modelo 1073', 'Lente Tele de alta calidad modelo 1073', 389.50, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(74, 'P1074', 'Cámara Mirrorless Modelo 1074', 'Cámara Mirrorless de alta calidad modelo 1074', 999.00, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(75, 'P1075', 'Placa Madre Modelo 1075', 'Placa Madre de alta calidad modelo 1075', 159.90, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(76, 'P1076', 'Refrigeración Líquida Modelo 1076', 'Refrigeración Líquida de alta calidad modelo 1076', 129.50, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(77, 'P1077', 'Fuente Modular Modelo 1077', 'Fuente Modular de alta calidad modelo 1077', 139.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(78, 'P1078', 'Silla Gamer Modelo 1078', 'Silla Gamer de alta calidad modelo 1078', 219.00, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(79, 'P1079', 'Tarjeta Sonido Modelo 1079', 'Tarjeta Sonido de alta calidad modelo 1079', 89.50, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(80, 'P1080', 'Control Remoto TV Modelo 1080', 'Control Remoto TV de alta calidad modelo 1080', 14.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(81, 'P1081', 'Antena WiFi Modelo 1081', 'Antena WiFi de alta calidad modelo 1081', 24.95, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(82, 'P1082', 'Adaptador VGA a HDMI Modelo 1082', 'Adaptador VGA a HDMI de alta calidad modelo 1082', 11.50, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(83, 'P1083', 'Cámara 360 Modelo 1083', 'Cámara 360 de alta calidad modelo 1083', 329.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(84, 'P1084', 'Caja SSD 2.5 Modelo 1084', 'Caja SSD 2.5 de alta calidad modelo 1084', 17.20, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(85, 'P1085', 'Tarjeta Captura Modelo 1085', 'Tarjeta Captura de alta calidad modelo 1085', 139.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(86, 'P1086', 'Soporte Telefono Modelo 1086', 'Soporte Telefono de alta calidad modelo 1086', 6.89, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(87, 'P1087', 'Micrófono USB Modelo 1087', 'Micrófono USB de alta calidad modelo 1087', 59.00, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(88, 'P1088', 'Cargador Auto USB Modelo 1088', 'Cargador Auto USB de alta calidad modelo 1088', 12.49, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(89, 'P1089', 'Cable Lightning Modelo 1089', 'Cable Lightning de alta calidad modelo 1089', 9.90, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(90, 'P1090', 'Soporte Pared TV Modelo 1090', 'Soporte Pared TV de alta calidad modelo 1090', 49.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(91, 'P1091', 'Adaptador Ethernet Modelo 1091', 'Adaptador Ethernet de alta calidad modelo 1091', 8.50, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(92, 'P1092', 'Receptor Bluetooth Modelo 1092', 'Receptor Bluetooth de alta calidad modelo 1092', 19.90, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(93, 'P1093', 'Base Docking Modelo 1093', 'Base Docking de alta calidad modelo 1093', 79.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(94, 'P1094', 'Cable USB-C Modelo 1094', 'Cable USB-C de alta calidad modelo 1094', 6.50, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(95, 'P1095', 'Batería Laptop Modelo 1095', 'Batería Laptop de alta calidad modelo 1095', 89.00, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(96, 'P1096', 'Lente Ojo Pez Modelo 1096', 'Lente Ojo Pez de alta calidad modelo 1096', 119.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(97, 'P1097', 'Flash Cámara Modelo 1097', 'Flash Cámara de alta calidad modelo 1097', 69.90, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(98, 'P1098', 'Micrófono Boom Modelo 1098', 'Micrófono Boom de alta calidad modelo 1098', 149.00, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(99, 'P1099', 'Control Consola Modelo 1099', 'Control Consola de alta calidad modelo 1099', 59.99, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(100, 'P1100', 'Soporte Microfono Modelo 1100', 'Soporte Microfono de alta calidad modelo 1100', 19.90, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31'),
(101, 'P1101', 'Lente Gran Angular Modelo 1101', 'Lente Gran Angular de alta calidad modelo 1101', 259.00, NULL, '2025-11-10 08:40:31', '2025-11-10 08:40:31');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sucursales`
--

CREATE TABLE `sucursales` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  `ciudad` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `sucursales`
--

INSERT INTO `sucursales` (`id`, `nombre`, `direccion`, `ciudad`, `created_at`, `updated_at`) VALUES
(1, 'Pradera Chimaltenango', 'Centro Comercial', 'Chimaltenango', '2025-11-08 10:54:13', '2025-11-08 10:54:13'),
(2, 'Pradera Escuintla', 'Centro', 'Escuintla', '2025-11-08 10:54:13', '2025-11-08 10:54:13'),
(3, 'Sucursal Central', 'Av. Principal 123', 'Guatemala', '2025-11-08 10:54:13', '2025-11-08 10:54:13');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `traslados`
--

CREATE TABLE `traslados` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `producto_id` bigint(20) UNSIGNED NOT NULL,
  `origen_id` bigint(20) UNSIGNED NOT NULL,
  `destino_id` bigint(20) UNSIGNED NOT NULL,
  `cantidad` int(11) NOT NULL,
  `estado` enum('pendiente','completado') NOT NULL DEFAULT 'pendiente',
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `traslados`
--

INSERT INTO `traslados` (`id`, `producto_id`, `origen_id`, `destino_id`, `cantidad`, `estado`, `user_id`, `fecha`, `created_at`, `updated_at`) VALUES
(1, 3, 1, 3, 3, 'pendiente', NULL, '2025-11-10 05:49:22', '2025-11-10 11:49:22', '2025-11-10 11:49:22'),
(2, 2, 1, 2, 2, 'completado', NULL, '2025-11-10 05:51:40', '2025-11-10 11:51:40', '2025-11-10 14:32:26'),
(3, 2, 1, 2, 2, 'pendiente', NULL, '2025-11-10 05:52:40', '2025-11-10 11:52:40', '2025-11-10 11:52:40'),
(4, 2, 1, 2, 2, 'pendiente', NULL, '2025-11-10 05:54:31', '2025-11-10 11:54:31', '2025-11-10 11:54:31'),
(5, 2, 1, 2, 2, 'completado', NULL, '2025-11-10 05:55:00', '2025-11-10 11:55:00', '2025-11-10 12:16:57');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `role` varchar(255) NOT NULL DEFAULT 'cliente',
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `role`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Test2', 't2@test.com', 'cliente', NULL, '$2y$12$VZDm8Xk1PBigvrGhW41tm.mP8vjrw5YsYCtjWQhncvXIBK8W10ItO', NULL, '2025-11-08 11:01:18', '2025-11-08 11:01:18'),
(2, 'Test3', 't3@test.com', 'cliente', NULL, '$2y$12$qYDIJHvPCJu092yrpOVJMugfpPlDQJtR1MHsDAy6daCoJygQz3sC2', NULL, '2025-11-08 11:03:25', '2025-11-08 11:03:25'),
(3, 'Nath', 'nath@gmail.com', 'cliente', NULL, '$2y$12$fEmxZHKofcp6AUOiy2aLAOLqNlqSbmb0.JuWfzoVCSCXKCUY6pJMq', NULL, '2025-11-08 11:05:11', '2025-11-08 11:05:11'),
(4, 'Nathaly', 'nathaly@gmail.com', 'admin', NULL, '$2y$12$gdvy2R.DhAiM4oTSHMRPden8sjxRcLlf4OkqNw4ZUo5Xdw2WW.VwW', NULL, '2025-11-09 04:38:04', '2025-11-09 06:44:30'),
(5, 'prueba', 'prueba@gmail.com', 'cliente', NULL, '$2y$12$/.JvPtPCqC8i2zLwrcq98ujY96q4txt3PKJII37BUvw561MMhP.IW', NULL, '2025-11-09 09:50:59', '2025-11-09 09:50:59'),
(6, 'hola', 'hola@gmail.com', 'cliente', NULL, '$2y$12$7g9iE9gL/c1XL/0XxGvWQ.vQnVTlSRlA0YRXZN0VXwwja9ZiiN03S', NULL, '2025-11-10 07:07:24', '2025-11-10 07:07:24'),
(7, 'Nath', 'gerente@gmail.com', 'gerente', NULL, '$2y$12$jZCPl1LjD9b.kHlTl.T93OxVdGmV5M3K8K9uaL2ymMvMVnQZr26Q2', NULL, '2025-11-10 13:18:54', '2025-11-10 13:18:54');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `sucursal_id` bigint(20) UNSIGNED DEFAULT NULL,
  `total` decimal(12,2) NOT NULL DEFAULT 0.00,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`id`, `user_id`, `sucursal_id`, `total`, `fecha`, `created_at`, `updated_at`) VALUES
(1, 4, 1, 45.50, '2025-11-10 06:25:25', '2025-11-10 06:25:25', '2025-11-10 06:25:25'),
(2, 4, 1, 682.50, '2025-11-10 06:27:36', '2025-11-10 06:27:36', '2025-11-10 06:27:36'),
(3, 4, 2, 910.00, '2025-11-10 06:27:49', '2025-11-10 06:27:49', '2025-11-10 06:27:49'),
(4, 4, 1, 682.50, '2025-11-10 06:28:02', '2025-11-10 06:28:02', '2025-11-10 06:28:02'),
(5, 4, 1, 48.00, '2025-11-10 06:28:08', '2025-11-10 06:28:08', '2025-11-10 06:28:08'),
(6, 4, 1, 500.00, '2025-11-10 06:28:17', '2025-11-10 06:28:17', '2025-11-10 06:28:17'),
(7, 4, 2, 500.00, '2025-11-10 06:28:24', '2025-11-10 06:28:24', '2025-11-10 06:28:24'),
(8, 4, 1, 45.50, '2025-11-10 06:54:33', '2025-11-10 06:54:33', '2025-11-10 06:54:33'),
(9, 4, 1, 116.00, '2025-11-10 06:55:00', '2025-11-10 06:55:00', '2025-11-10 06:55:00'),
(10, 4, 1, 45.50, '2025-11-10 07:04:31', '2025-11-10 07:04:31', '2025-11-10 07:04:31'),
(11, 6, 1, 55.99, '2025-11-10 07:07:34', '2025-11-10 07:07:34', '2025-11-10 07:07:34'),
(12, 4, 1, 205.00, '2025-11-10 21:39:59', '2025-11-10 21:39:59', '2025-11-10 21:39:59');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta_items`
--

CREATE TABLE `venta_items` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `venta_id` bigint(20) UNSIGNED NOT NULL,
  `producto_id` bigint(20) UNSIGNED NOT NULL,
  `cantidad` int(11) NOT NULL,
  `precio_unit` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Volcado de datos para la tabla `venta_items`
--

INSERT INTO `venta_items` (`id`, `venta_id`, `producto_id`, `cantidad`, `precio_unit`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 45.50, '2025-11-10 06:25:25', '2025-11-10 06:25:25'),
(2, 2, 1, 15, 45.50, '2025-11-10 06:27:36', '2025-11-10 06:27:36'),
(3, 4, 1, 15, 45.50, '2025-11-10 06:28:02', '2025-11-10 06:28:02'),
(4, 5, 2, 15, 3.20, '2025-11-10 06:28:08', '2025-11-10 06:28:08'),
(5, 6, 3, 20, 25.00, '2025-11-10 06:28:17', '2025-11-10 06:28:17'),
(6, 8, 1, 1, 45.50, '2025-11-10 06:54:33', '2025-11-10 06:54:33'),
(7, 9, 1, 2, 45.50, '2025-11-10 06:55:00', '2025-11-10 06:55:00'),
(8, 9, 3, 1, 25.00, '2025-11-10 06:55:00', '2025-11-10 06:55:00'),
(9, 10, 1, 1, 45.50, '2025-11-10 07:04:31', '2025-11-10 07:04:31'),
(10, 11, 4, 1, 55.99, '2025-11-10 07:07:34', '2025-11-10 07:07:34'),
(11, 12, 1, 1, 120.00, '2025-11-10 21:39:59', '2025-11-10 21:39:59'),
(12, 12, 2, 1, 20.00, '2025-11-10 21:39:59', '2025-11-10 21:39:59'),
(13, 12, 3, 1, 65.00, '2025-11-10 21:39:59', '2025-11-10 21:39:59');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indices de la tabla `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indices de la tabla `cotizacions`
--
ALTER TABLE `cotizacions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_cotizacions_user` (`user_id`),
  ADD KEY `fk_cotizacions_sucursal` (`sucursal_id`);

--
-- Indices de la tabla `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indices de la tabla `inventarios`
--
ALTER TABLE `inventarios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `inventarios_producto_id_foreign` (`producto_id`),
  ADD KEY `inventarios_sucursal_id_foreign` (`sucursal_id`);

--
-- Indices de la tabla `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indices de la tabla `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `logs`
--
ALTER TABLE `logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `logs_user_id_foreign` (`user_id`);

--
-- Indices de la tabla `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indices de la tabla `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `productos_sku_unique` (`sku`);

--
-- Indices de la tabla `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indices de la tabla `sucursales`
--
ALTER TABLE `sucursales`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `traslados`
--
ALTER TABLE `traslados`
  ADD PRIMARY KEY (`id`),
  ADD KEY `traslados_producto_id_foreign` (`producto_id`),
  ADD KEY `traslados_origen_id_foreign` (`origen_id`),
  ADD KEY `traslados_destino_id_foreign` (`destino_id`),
  ADD KEY `traslados_user_id_foreign` (`user_id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ventas_user_id_foreign` (`user_id`),
  ADD KEY `ventas_sucursal_id_foreign` (`sucursal_id`);

--
-- Indices de la tabla `venta_items`
--
ALTER TABLE `venta_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `venta_items_venta_id_foreign` (`venta_id`),
  ADD KEY `venta_items_producto_id_foreign` (`producto_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cotizacions`
--
ALTER TABLE `cotizacions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `inventarios`
--
ALTER TABLE `inventarios`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT de la tabla `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `logs`
--
ALTER TABLE `logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT de la tabla `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT de la tabla `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT de la tabla `sucursales`
--
ALTER TABLE `sucursales`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `traslados`
--
ALTER TABLE `traslados`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `venta_items`
--
ALTER TABLE `venta_items`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cotizacions`
--
ALTER TABLE `cotizacions`
  ADD CONSTRAINT `fk_cotizacions_sucursal` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cotizacions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `inventarios`
--
ALTER TABLE `inventarios`
  ADD CONSTRAINT `inventarios_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `inventarios_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `logs`
--
ALTER TABLE `logs`
  ADD CONSTRAINT `logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `traslados`
--
ALTER TABLE `traslados`
  ADD CONSTRAINT `traslados_destino_id_foreign` FOREIGN KEY (`destino_id`) REFERENCES `sucursales` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `traslados_origen_id_foreign` FOREIGN KEY (`origen_id`) REFERENCES `sucursales` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `traslados_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `traslados_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD CONSTRAINT `ventas_sucursal_id_foreign` FOREIGN KEY (`sucursal_id`) REFERENCES `sucursales` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `ventas_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `venta_items`
--
ALTER TABLE `venta_items`
  ADD CONSTRAINT `venta_items_producto_id_foreign` FOREIGN KEY (`producto_id`) REFERENCES `productos` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `venta_items_venta_id_foreign` FOREIGN KEY (`venta_id`) REFERENCES `ventas` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
