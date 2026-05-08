-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 08, 2026 at 04:11 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `workshop_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `customer_type` enum('Regular','VIP','Walk-in') DEFAULT 'Regular',
  `insurance` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`id`, `name`, `phone`, `email`, `address`, `customer_type`, `insurance`) VALUES
(2, 'ed', '099898888', 'gsghuhuhsushu2@hhjjs', NULL, 'Regular', NULL),
(5, 'joe', '095986 676787', 'findme@67nnmk', NULL, 'Regular', NULL),
(6, 'ed', '095986 676787', 'gsghuhuhsushu2@hhjjs', NULL, 'Regular', NULL),
(12, 'zee', '097 456 6895', 'nonn@tyhjk', '3354 ryan ave roodepoort', 'Regular', NULL),
(13, 'Joesie', '12345678', 'joesie@gmail.com', '34 sandton av', 'VIP', NULL),
(14, 'Aslam', '083 212 6269', 'aslam.c@easicall.co.za', '3354 ryan ave roodepoort', 'Regular', NULL),
(16, 'Test Customer', '0123456789', '', '123 Test Street', 'Regular', NULL),
(17, 'Test Customer', '0123456789', '', '123 Test Street', 'Regular', NULL),
(18, 'Test Customer', '0123456789', 'test@example.com', '123 Test Street', 'Regular', NULL),
(19, 'Test Customer', '0123456789', 'test@example.com', '123 Test Street', 'Regular', NULL),
(20, 'Test Customer', '0123456789', 'test@example.com', '123 Test Street', 'Regular', NULL),
(22, 'Zanele', '063 116 4565', 'zeemain@gmail.com', '34 naledi ext', 'Walk-in', NULL),
(23, 'Cebile', '064 234 5678', 'cebile@findme', '34 naledi ext', 'Regular', NULL),
(24, 'Thabo', '061 546 6542', 'thabo@08gmail.com', '70 bashee ave', 'Walk-in', 'Hippo insurance');

-- --------------------------------------------------------

--
-- Table structure for table `expenses`
--

CREATE TABLE `expenses` (
  `id` int(11) NOT NULL,
  `expense_number` varchar(50) DEFAULT NULL,
  `expense_date` date NOT NULL,
  `category_id` int(11) NOT NULL,
  `description` text DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `amount_excl_vat` decimal(10,2) NOT NULL,
  `vat_amount` decimal(10,2) DEFAULT 0.00,
  `amount_incl_vat` decimal(10,2) NOT NULL,
  `payment_method` enum('Cash','Card','EFT') NOT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `expenses`
--

INSERT INTO `expenses` (`id`, `expense_number`, `expense_date`, `category_id`, `description`, `supplier_id`, `amount_excl_vat`, `vat_amount`, `amount_incl_vat`, `payment_method`, `created_by`, `created_at`) VALUES
(1, 'EXP-1771237124', '2026-02-16', 1, 'Brought parts from auto cars', 2, 10000.00, 1500.00, 11500.00, 'Cash', 1, '2026-02-16 10:18:44'),
(2, 'EXP-1771239660', '2026-02-15', 6, '', 1, 15000.00, 1500.00, 16500.00, 'Cash', 1, '2026-02-16 11:01:00'),
(3, 'EXP-1771246555', '2026-02-25', 7, '', NULL, 15000.00, 1500.00, 16500.00, 'Card', 1, '2026-02-16 12:55:55');

-- --------------------------------------------------------

--
-- Table structure for table `expense_categories`
--

CREATE TABLE `expense_categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `expense_categories`
--

INSERT INTO `expense_categories` (`id`, `name`) VALUES
(1, 'Parts'),
(2, 'Labour'),
(3, 'Office Supplies'),
(4, 'Utilities'),
(5, 'Miscellaneous'),
(6, 'Lids'),
(7, 'Thato Salary');

-- --------------------------------------------------------

--
-- Table structure for table `income`
--

CREATE TABLE `income` (
  `id` int(11) NOT NULL,
  `income_date` date NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `income`
--

INSERT INTO `income` (`id`, `income_date`, `description`, `amount`, `category_id`, `created_at`) VALUES
(1, '2026-02-16', 'Invoice 345678 paid', 10000.00, 3, '2026-02-16 14:35:17');

-- --------------------------------------------------------

--
-- Table structure for table `income_categories`
--

CREATE TABLE `income_categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `income_categories`
--

INSERT INTO `income_categories` (`id`, `name`, `created_at`) VALUES
(1, 'Services', '2026-02-16 14:24:07'),
(2, 'Parts Sales', '2026-02-16 14:24:07'),
(3, 'Other Income', '2026-02-16 14:24:07');

-- --------------------------------------------------------

--
-- Table structure for table `invoices`
--

CREATE TABLE `invoices` (
  `id` int(11) NOT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `invoice_date` date NOT NULL,
  `customer_name` varchar(100) DEFAULT NULL,
  `company_name` varchar(100) DEFAULT NULL,
  `vat_number` varchar(50) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `ship_to_name` varchar(100) DEFAULT NULL,
  `ship_to_company` varchar(100) DEFAULT NULL,
  `ship_to_contact` varchar(50) DEFAULT NULL,
  `ship_to_address` text DEFAULT NULL,
  `vehicle_make` varchar(50) DEFAULT NULL,
  `vehicle_model` varchar(50) DEFAULT NULL,
  `vehicle_year` year(4) DEFAULT NULL,
  `vin_number` varchar(50) DEFAULT NULL,
  `registration_number` varchar(50) DEFAULT NULL,
  `odometer_reading` varchar(50) DEFAULT NULL,
  `next_service` varchar(50) DEFAULT NULL,
  `salesperson` varchar(50) DEFAULT NULL,
  `po_number` varchar(50) DEFAULT NULL,
  `ship_date` date DEFAULT NULL,
  `ship_via` varchar(50) DEFAULT NULL,
  `payment_type` varchar(50) DEFAULT NULL,
  `terms` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `subtotal` decimal(10,2) DEFAULT NULL,
  `vat` decimal(10,2) DEFAULT NULL,
  `shipping` decimal(10,2) DEFAULT 0.00,
  `total` decimal(10,2) DEFAULT NULL,
  `total_profit` decimal(15,2) NOT NULL DEFAULT 0.00,
  `items` text DEFAULT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('Unpaid','Paid') DEFAULT 'Unpaid',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `paid_at` datetime DEFAULT NULL,
  `payment_reference` varchar(100) DEFAULT NULL,
  `discount` decimal(15,2) DEFAULT 0.00,
  `payment_method` varchar(50) DEFAULT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `account_number` varchar(50) DEFAULT NULL,
  `reference` varchar(255) DEFAULT NULL,
  `payment_status` varchar(50) DEFAULT 'Pending',
  `paid_date` datetime DEFAULT NULL,
  `customer_signature` varchar(255) DEFAULT NULL,
  `signed_datetime` datetime DEFAULT NULL,
  `payment_date` date DEFAULT NULL,
  `amount_paid` decimal(10,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `invoices`
--

INSERT INTO `invoices` (`id`, `invoice_number`, `invoice_date`, `customer_name`, `company_name`, `vat_number`, `address`, `phone`, `ship_to_name`, `ship_to_company`, `ship_to_contact`, `ship_to_address`, `vehicle_make`, `vehicle_model`, `vehicle_year`, `vin_number`, `registration_number`, `odometer_reading`, `next_service`, `salesperson`, `po_number`, `ship_date`, `ship_via`, `payment_type`, `terms`, `notes`, `subtotal`, `vat`, `shipping`, `total`, `total_profit`, `items`, `total_amount`, `status`, `created_at`, `paid_at`, `payment_reference`, `discount`, `payment_method`, `bank_name`, `account_number`, `reference`, `payment_status`, `paid_date`, `customer_signature`, `signed_datetime`, `payment_date`, `amount_paid`) VALUES
(4, 'INV-1768901865', '2026-01-20', 'Baddie', '', '', '3354 ryan ave roodepoort', '095986 676787', 'Zee', 'EasiCars', 'mr A', 'MIDRAND', 'BMW x3', '2020', NULL, '133f', '43557', 'gggurthg', '3 nov', '', '', NULL, '', '', '', '', 100.00, 15.00, 0.00, 115.00, 0.00, '[{\"qty\":\"2\",\"desc\":\"Wipers\",\"price\":\"50\"},{\"qty\":\"1\",\"desc\":\"\",\"price\":\"0\"}]', 115.00, 'Paid', '2026-01-20 09:46:41', NULL, NULL, 0.00, NULL, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(5, 'INV-1768902879', '2026-01-20', 'Baddie', 'Easicall', '23468', '3354 ryan ave roodepoort', '073 123 4568', 'Zee', 'EasiCars', 'mr A', 'MIDRAND', 'BMW x3', '2020', NULL, '133f', '43557', 'gggurthg', '3 nov', 'Lerato', '1986', NULL, '', '', '', '', 400.00, 60.00, 0.00, 460.00, 0.00, '\"[{\\\"qty\\\":4,\\\"desc\\\":\\\"Wipers\\\",\\\"price\\\":50},{\\\"qty\\\":2,\\\"desc\\\":\\\"oil\\\",\\\"price\\\":100},{\\\"qty\\\":1,\\\"desc\\\":\\\"\\\",\\\"price\\\":0}]\"', 460.00, 'Paid', '2026-01-20 09:56:03', NULL, NULL, 0.00, NULL, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(6, 'INV-1768903084', '2026-01-20', 'Baddie', 'Sweets Store', '23468', '34 sandton av', '073 123 4568', 'Zee', 'EasiCars', 'mr A', 'MIDRAND', 'BMW x3', '2020', NULL, '133f', '43557', 'gggurthg', '3 nov', 'Lerato', '1986', '0000-00-00', '', '', '', '', 2055.00, 308.25, 0.00, 2363.25, 0.00, '[{\"qty\":2,\"desc\":\"Helix 5lt 10w40\",\"price\":1000},{\"qty\":1,\"desc\":\"oil\",\"price\":55},{\"qty\":1,\"desc\":\"\",\"price\":0}]', 0.00, 'Paid', '2026-01-20 10:01:31', NULL, NULL, 0.00, NULL, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(7, 'INV-1768984454', '2026-01-21', 'Thuli', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1900.00, 285.00, 0.00, 2185.00, 0.00, '[{\"qty\":1,\"desc\":\"Aircon Service\",\"price\":750},{\"qty\":1,\"desc\":\"Wheel Balancing\",\"price\":300},{\"qty\":1,\"desc\":\"General Service\",\"price\":850}]', 0.00, 'Paid', '2026-01-21 09:08:16', NULL, NULL, 0.00, NULL, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(8, 'INV-1768986586', '2026-01-21', 'Thuli', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3750.00, 562.50, 0.00, 4312.50, 0.00, '[{\"qty\":1,\"desc\":\"Aircon Service\",\"price\":750},{\"qty\":1,\"desc\":\"Engine Diagnostics\",\"price\":600},{\"qty\":2,\"desc\":\"Brake Pads Replacement\",\"price\":1200},{\"qty\":1,\"desc\":\"\",\"price\":0}]', 0.00, 'Paid', '2026-01-21 09:12:05', NULL, NULL, 0.00, NULL, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(10, 'INV-1769177044', '2026-01-23', 'Nhla', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 6150.00, 922.50, 0.00, 7072.50, 0.00, '[{\"qty\":1,\"desc\":\"\",\"price\":0},{\"qty\":1,\"desc\":\"Gearbox Service\",\"price\":4800},{\"qty\":1,\"desc\":\"Aircon Service\",\"price\":750},{\"qty\":1,\"desc\":\"Engine Diagnostics\",\"price\":600},{\"qty\":1,\"desc\":\"\",\"price\":0}]', 0.00, 'Unpaid', '2026-01-23 14:05:15', NULL, NULL, 0.00, NULL, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(11, 'INV-1769578844', '2026-01-28', 'zeee', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 1600.00, 240.00, 0.00, 1820.00, 550.00, NULL, 0.00, 'Unpaid', '2026-01-28 05:42:41', NULL, NULL, 0.00, NULL, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(13, 'INV-1769578971', '2026-01-28', 'Zanele', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 200.00, 30.00, 0.00, 230.00, 100.00, NULL, 0.00, 'Unpaid', '2026-01-28 05:43:07', NULL, NULL, 0.00, 'credit_card', 'Credit Card', 'N/A', NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(14, 'INV-1769579197', '2026-01-28', 'Zanele', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 200.00, 30.00, 0.00, 230.00, 100.00, NULL, 0.00, 'Paid', '2026-01-28 05:49:04', NULL, NULL, 0.00, NULL, NULL, NULL, NULL, 'Paid', '2026-02-18 13:30:07', NULL, NULL, NULL, 230.00),
(15, 'INV-1769587395', '2026-01-28', 'zeee', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 2150.00, 322.50, 0.00, 2452.50, 1050.00, NULL, 0.00, 'Paid', '2026-01-28 08:09:48', NULL, NULL, 20.00, NULL, NULL, NULL, NULL, 'Paid', '2026-02-18 13:30:33', NULL, NULL, NULL, 2452.50),
(16, 'INV-1769588342', '2026-01-28', 'Baddie', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 800.00, 120.00, 0.00, 920.00, 150.00, NULL, 0.00, 'Unpaid', '2026-01-28 08:20:00', NULL, NULL, 0.00, 'credit_card', 'absa', '12346959', NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(17, 'INV-1769589368', '2026-01-28', 'Non', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 1700.00, 255.00, 0.00, 1955.00, 1050.00, NULL, 0.00, 'Paid', '2026-01-28 08:37:23', NULL, NULL, 0.00, NULL, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(18, 'INV-1769589791', '2026-01-28', 'Zanele', 'Sweets Store', '23468', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 700.00, 105.00, 0.00, 805.00, 300.00, '[{\"qty\":1,\"desc\":\"Helix 5lt 10w40\",\"cost\":50,\"price\":100,\"profit\":50},{\"qty\":1,\"desc\":\"Wheel Balancing\",\"cost\":350,\"price\":600,\"profit\":250},{\"qty\":1,\"desc\":\"\",\"cost\":0,\"price\":0,\"profit\":0}]', 0.00, 'Unpaid', '2026-01-28 08:43:51', NULL, NULL, 0.00, NULL, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(19, 'INV-1769590761', '2026-01-28', 'Zanele', 'Sweets Store', '23468', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 0.00, 0.00, 0.00, 0.00, 0.00, '[{\"qty\":1,\"desc\":\"\",\"cost\":0,\"price\":0,\"profit\":0}]', 0.00, 'Unpaid', '2026-01-28 08:59:24', NULL, NULL, 0.00, NULL, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(20, 'INV-1769683458', '2026-01-29', 'Cebile', 'car car', '55555', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 1390.00, 208.50, 0.00, 1578.50, 240.00, '[{\"qty\":1,\"desc\":\"car wheels\",\"cost\":450,\"price\":500,\"profit\":50},{\"qty\":1,\"desc\":\"car sweets\",\"cost\":700,\"price\":890,\"profit\":190}]', 0.00, 'Paid', '2026-01-29 10:45:55', NULL, NULL, 20.00, 'eft', 'FNB', '658888880000', NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(21, 'INV-1769686180', '2026-01-29', 'Zanele', 'Sweets Store', '23468', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 700.00, 105.00, 0.00, 805.00, 334.00, '[{\"qty\":1,\"desc\":\"Helix 5lt 10w40\",\"cost\":366,\"price\":700,\"profit\":334},{\"qty\":1,\"desc\":\"\",\"cost\":0,\"price\":0,\"profit\":0}]', 0.00, 'Unpaid', '2026-01-29 11:30:02', NULL, NULL, 0.00, 'eft', 'FNB', '658888880000', NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(22, 'INV-1769686917', '2026-01-29', 'Zanele', 'Car shop', '23468', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 1000.00, 150.00, 0.00, 1150.00, 200.00, '[{\"qty\":1,\"desc\":\"Helix 5lt 10w40\",\"cost\":800,\"price\":1000,\"profit\":200}]', 0.00, 'Unpaid', '2026-01-29 11:42:18', NULL, NULL, 0.00, NULL, NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(23, 'INV-1770025419', '2026-02-02', 'Zanele', 'Sweets Store', '23468', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 0.00, 0.00, 0.00, 0.00, 0.00, NULL, 0.00, 'Paid', '2026-02-02 09:43:42', NULL, NULL, 0.00, 'debit_credit', NULL, NULL, 'INV-1770025419', 'Pending Payment', NULL, NULL, NULL, NULL, 0.00),
(25, 'INV-1770038398', '2026-02-02', 'Zanele', 'Sweets Store', '23468', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 200.00, 30.00, 0.00, 230.00, 0.00, NULL, 0.00, 'Unpaid', '2026-02-02 13:23:43', NULL, NULL, 0.00, 'debit_credit', NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(26, 'INV-1770038786', '2026-02-02', 'Baddie', 'car car', '55555', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 300.00, 45.00, 0.00, 345.00, 0.00, NULL, 0.00, 'Unpaid', '2026-02-02 13:27:16', NULL, NULL, 0.00, 'debit_credit', NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(27, 'INV-1770040303', '2026-02-02', 'zeee', 'Sweets Store', '12345', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 899.00, 134.85, 0.00, 1033.85, 0.00, NULL, 0.00, 'Paid', '2026-02-02 13:52:34', NULL, NULL, 0.00, 'cash', NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(28, 'INV-1770099598', '2026-02-03', 'Zanele', 'Sweets Store', '23468', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 500.00, 75.00, 0.00, 575.00, 0.00, NULL, 0.00, 'Paid', '2026-02-03 06:21:06', NULL, NULL, 0.00, 'debit_credit', NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(29, 'INV-1770125179', '2026-02-03', 'Zanele', 'we buy cars', '55555', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 2800.00, 420.00, 0.00, 3220.00, 0.00, NULL, 0.00, 'Unpaid', '2026-02-03 13:28:24', NULL, NULL, 0.00, 'cash', NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(30, 'INV-1770386667', '2026-02-06', 'Cebile', 'we buy cars', '55555', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 400.00, 60.00, 0.00, 460.00, 0.00, NULL, 0.00, 'Unpaid', '2026-02-06 14:05:45', NULL, NULL, 0.00, 'cash', NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(32, 'INV-1770387092', '2026-02-06', 'Zanele', 'car car', '23468', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 300.00, 45.00, 0.00, 345.00, 0.00, NULL, 0.00, 'Unpaid', '2026-02-06 14:13:13', NULL, NULL, 0.00, 'cash', NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(33, 'INV-1770615263', '2026-02-09', 'Zanele', 'Sweets Store', '23468', NULL, NULL, NULL, NULL, NULL, NULL, 'Audi', '2020', NULL, '133f', '43557', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 900.00, 135.00, 0.00, 1035.00, 0.00, '0', 0.00, 'Paid', '2026-02-09 05:40:12', NULL, NULL, 0.00, 'eft', NULL, NULL, NULL, 'Paid', '2026-02-16 15:46:31', NULL, NULL, NULL, 1035.00),
(34, 'INV-1770615614', '2026-02-09', 'Zanele', 'Sweets Store', '23468', NULL, NULL, NULL, NULL, NULL, NULL, 'Audi', '2020', NULL, '133f', '43557', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 960.00, 144.00, 0.00, 1104.00, 0.00, '0', 0.00, 'Paid', '2026-02-09 05:40:41', NULL, NULL, 0.00, 'eft', NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(35, 'INV-1770618412', '2026-02-09', 'Zanele', 'Sweets Store', '23468', NULL, NULL, NULL, NULL, NULL, NULL, 'Audi', '2020', '0000', '133f', '43557', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 0.00, 0.00, 0.00, 0.00, 0.00, '[]', 0.00, 'Paid', '2026-02-09 06:27:41', NULL, NULL, 0.00, 'cash', NULL, NULL, NULL, 'Paid', '2026-02-18 15:35:15', NULL, NULL, NULL, 0.00),
(36, 'INV-1770619497', '2026-02-09', 'Zanele', 'Sweets Store', '23468', NULL, NULL, NULL, NULL, NULL, NULL, 'Audi', '2020', '2020', '133f', '43557', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 700.00, 105.00, 0.00, 805.00, 0.00, '0', 0.00, 'Unpaid', '2026-02-09 06:45:46', NULL, NULL, 0.00, 'cash', NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(38, 'INV-1770620625', '2026-02-09', 'Zanele', 'Sweets Store', '23468', NULL, NULL, NULL, NULL, NULL, NULL, 'Audi', '2020', '2021', '133f', '43557', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 200.00, 30.00, 0.00, 230.00, 0.00, '0', 0.00, 'Paid', '2026-02-09 07:04:55', NULL, NULL, 0.00, 'cash', NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(39, 'INV-1770620997', '2026-02-09', 'Non', 'Car shop', '23468', NULL, NULL, NULL, NULL, NULL, NULL, 'Audi', '2020', '2023', '133f', '43557', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 600.00, 90.00, 0.00, 690.00, 0.00, '0', 0.00, 'Unpaid', '2026-02-09 07:10:40', NULL, NULL, 0.00, 'cash', NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(40, 'INV-1770621508', '2026-02-09', 'zeee', 'Sweets Store', '12345', NULL, NULL, NULL, NULL, NULL, NULL, 'BMW x3', '2020', '2021', '133f', '43557', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 500.00, 75.00, 0.00, 575.00, 0.00, '0', 0.00, 'Unpaid', '2026-02-09 07:19:48', NULL, NULL, 0.00, 'cash', NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(41, 'INV-1770622936', '2026-02-09', 'zeee', 'Car shop', '23468', NULL, NULL, NULL, NULL, NULL, NULL, 'Audi', '2020', '2021', '133f', '43557', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 500.00, 75.00, 0.00, 575.00, 0.00, '0', 0.00, 'Unpaid', '2026-02-09 07:42:46', NULL, NULL, 0.00, 'cash', NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(42, 'INV-1770636041', '2026-02-09', 'Non', 'we buy cars', '23468', NULL, NULL, NULL, NULL, NULL, NULL, 'Audi', '2020', '0000', '133f', '43557', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 800.00, 120.00, 0.00, 920.00, 0.00, '0', 0.00, 'Unpaid', '2026-02-09 11:21:50', NULL, NULL, 0.00, 'cash', NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(43, 'INV-1770636512', '2026-02-09', 'Non', 'we buy cars', '23468', NULL, NULL, NULL, NULL, NULL, NULL, 'Audi', '2020', '0000', '133f', '43557', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 500.00, 75.00, 0.00, 575.00, 0.00, '0', 0.00, 'Unpaid', '2026-02-09 11:28:54', NULL, NULL, 0.00, 'cash', NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(44, 'INV-1770646513', '2026-02-09', 'Cebile', 'Sweets Store', '23468', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 500.00, 75.00, 0.00, 575.00, 0.00, NULL, 0.00, 'Unpaid', '2026-02-09 14:19:33', NULL, NULL, 0.00, 'Cash', NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(45, 'INV-1770646937', '2026-02-09', 'Cebile', 'Sweets Store', '23468', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 0.00, 0.00, 0.00, 0.00, 0.00, NULL, 0.00, 'Paid', '2026-02-09 14:22:18', NULL, NULL, 0.00, 'Cash', NULL, NULL, NULL, 'Paid', '2026-02-18 13:30:12', NULL, NULL, NULL, 0.00),
(46, 'INV-1770647515', '2026-02-09', 'Zanele', 'Sweets Store', '23468', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 700.00, 105.00, 0.00, 805.00, 0.00, NULL, 0.00, 'Unpaid', '2026-02-09 14:32:36', NULL, NULL, 0.00, '', NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(47, 'INV-1770979093', '2026-02-13', '', '', '', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 0.00, 0.00, 0.00, 0.00, 0.00, NULL, 0.00, 'Unpaid', '2026-02-13 10:38:44', NULL, NULL, 0.00, '', NULL, NULL, NULL, 'Pending', NULL, NULL, NULL, NULL, 0.00),
(50, 'INV-1770989400', '2026-02-13', 'Zanele', 'Sweets Store', '12345', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 590.00, 88.50, 0.00, 678.50, 0.00, NULL, 0.00, 'Paid', '2026-02-13 13:34:38', NULL, NULL, 0.00, 'Card', NULL, NULL, NULL, 'Pending', NULL, '', '0000-00-00 00:00:00', NULL, 0.00),
(51, 'INV-1770989735', '2026-02-13', 'Cebile', 'we buy cars', '121010', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 350.00, 52.50, 0.00, 402.50, 0.00, NULL, 0.00, 'Paid', '2026-02-13 13:36:28', NULL, NULL, 0.00, '', NULL, NULL, NULL, 'Paid', '2026-02-18 15:35:23', '', '2026-02-13 15:36:00', NULL, 402.50),
(52, 'INV-1771250299', '2026-02-16', 'Poppy', 'Poppy cars', '12345678', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '', 575.00, 86.25, 0.00, 661.25, 0.00, NULL, 0.00, 'Paid', '2026-02-16 14:00:12', NULL, NULL, 0.00, 'Card', NULL, NULL, NULL, 'Paid', '2026-02-16 16:00:23', '', '2026-02-16 16:00:00', NULL, 661.25);

-- --------------------------------------------------------

--
-- Table structure for table `invoice_history`
--

CREATE TABLE `invoice_history` (
  `id` int(11) NOT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `action` varchar(255) NOT NULL,
  `performed_by` varchar(100) DEFAULT NULL,
  `action_date` datetime DEFAULT current_timestamp(),
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoice_items`
--

CREATE TABLE `invoice_items` (
  `id` int(11) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `qty` decimal(10,2) DEFAULT NULL,
  `cost_price` decimal(15,2) DEFAULT NULL,
  `selling_price` decimal(15,2) DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT NULL,
  `profit` decimal(15,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `invoice_items`
--

INSERT INTO `invoice_items` (`id`, `invoice_id`, `description`, `qty`, `cost_price`, `selling_price`, `amount`, `profit`) VALUES
(1, 14, 'Helix 5lt 10w40', 1.00, 100.00, 200.00, 200.00, 100.00),
(2, 15, 'Helix 5lt 10w40', 1.00, 500.00, 650.00, 650.00, 150.00),
(3, 15, 'Aircon Service', 1.00, 450.00, 800.00, 800.00, 350.00),
(4, 15, 'oil', 1.00, 150.00, 700.00, 700.00, 550.00),
(5, 16, 'Helix 5lt 10w40', 1.00, 200.00, 300.00, 300.00, 100.00),
(6, 16, 'oil', 1.00, 450.00, 500.00, 500.00, 50.00),
(7, 16, '', 1.00, 0.00, 0.00, 0.00, 0.00),
(8, 17, 'Helix 5lt 10w40', 1.00, 150.00, 300.00, 300.00, 150.00),
(9, 17, 'oil', 1.00, 400.00, 1200.00, 1200.00, 800.00),
(10, 17, 'General Service', 2.00, 50.00, 100.00, 200.00, 100.00),
(12, 25, 'Major Service', 1.00, 500.00, 200.00, 200.00, NULL),
(13, 25, '', 0.00, 0.00, 0.00, 0.00, NULL),
(14, 25, '', 0.00, 0.00, 0.00, 0.00, NULL),
(15, 26, 'car oil', 1.00, 200.00, 300.00, 300.00, NULL),
(16, 26, 'Oil Change', 0.00, 100.00, 400.00, 0.00, NULL),
(17, 26, '', 0.00, 0.00, 0.00, 0.00, NULL),
(18, 27, 'Major Service', 1.00, 600.00, 899.00, 899.00, NULL),
(19, 27, 'Brake Pads', 0.00, 60.00, 100.00, 0.00, NULL),
(20, 28, 'Oil Change', 1.00, 400.00, 500.00, 500.00, NULL),
(21, 28, 'Brake Pads', 0.00, 299.00, 500.00, 0.00, NULL),
(22, 29, 'Oil Change', 1.00, 300.00, 400.00, 400.00, NULL),
(23, 29, 'Brake Pads', 2.00, 50.00, 200.00, 400.00, NULL),
(24, 29, 'Omonda brakes', 2.00, 500.00, 1000.00, 2000.00, NULL),
(25, 44, '0', 1.00, NULL, 200.00, 200.00, NULL),
(26, 44, '0', 1.00, NULL, 300.00, 300.00, NULL),
(27, 45, '0', 1.00, NULL, 200.00, 0.00, NULL),
(28, 46, '0', 1.00, NULL, 500.00, 500.00, NULL),
(29, 46, '0', 1.00, NULL, 200.00, 200.00, NULL),
(30, 47, '0', 1.00, NULL, 0.00, 0.00, NULL),
(37, 50, '0', 1.00, NULL, 200.00, 200.00, NULL),
(38, 50, '0', 1.00, NULL, 390.00, 390.00, NULL),
(39, 51, '0', 1.00, NULL, 100.00, 100.00, NULL),
(40, 51, '0', 1.00, NULL, 250.00, 250.00, NULL),
(41, 52, '0', 1.00, NULL, 500.00, 500.00, NULL),
(42, 52, '0', 1.00, NULL, 75.00, 75.00, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `jobcards`
--

CREATE TABLE `jobcards` (
  `id` int(11) NOT NULL,
  `created_by` int(11) NOT NULL,
  `jobcard_number` varchar(30) DEFAULT NULL,
  `customer_id` int(11) NOT NULL,
  `vehicle_id` int(11) DEFAULT NULL,
  `problem_description` text NOT NULL,
  `technician_id` int(11) DEFAULT NULL,
  `start_day` date DEFAULT NULL,
  `finish_day` date DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'New',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `name` varchar(50) DEFAULT NULL,
  `surname` varchar(50) DEFAULT NULL,
  `cell_number` varchar(20) DEFAULT NULL,
  `alt_number` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `id_passport` varchar(50) DEFAULT NULL,
  `vehicle_reg` varchar(20) DEFAULT NULL,
  `make` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `year` year(4) DEFAULT NULL,
  `colour` varchar(30) DEFAULT NULL,
  `vin` varchar(50) DEFAULT NULL,
  `work_required` text DEFAULT NULL,
  `equipment_needed` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jobcards`
--

INSERT INTO `jobcards` (`id`, `created_by`, `jobcard_number`, `customer_id`, `vehicle_id`, `problem_description`, `technician_id`, `start_day`, `finish_day`, `status`, `created_at`, `name`, `surname`, `cell_number`, `alt_number`, `address`, `id_passport`, `vehicle_reg`, `make`, `model`, `year`, `colour`, `vin`, `work_required`, `equipment_needed`) VALUES
(9, 2, 'JC20260113100614', 0, NULL, 'bracks are slippryty\r\nshacky car', NULL, NULL, NULL, 'Parts received', '2026-01-13 09:06:14', 'zee', 'easicall', '087 122 4444', '098 123 5555', '3354 ryan ave roodepoort', '86 199 800 62085', '5667787yh', 'LEMO', 'X3', '2008', NULL, NULL, NULL, NULL),
(14, 2, 'JC20260113101850', 0, NULL, 'rfghjhmj,', NULL, NULL, NULL, '', '2026-01-13 09:18:50', 'nonnie', 'easicall', '087 122 4444', '666878 78688', '3354 ryan ave roodepoort', '675666776787878778', '5667787yh', 'LEMO', 'tazz', '2099', NULL, NULL, NULL, NULL),
(15, 2, 'JC20260113102711', 0, NULL, 'Service the car\r\nCheck Aircon', NULL, NULL, NULL, 'Parts received', '2026-01-13 09:27:11', 'Aslam', 'Chicktay', '0832126269', '0847866910', '70 bashee ave', '7872970', '', '', '', '0000', NULL, NULL, NULL, NULL),
(18, 2, 'JC20260113143022', 0, NULL, 'wiper problems', NULL, '2026-02-16', '2026-02-20', 'Waiting for parts', '2026-01-13 13:30:22', 'Thuli', 'Momo', '073 090 1234', '011 876 1234', '34 sandton av', '9078100876543', 'Toyota', 'Yaris', 'x20', '2022', 'black', '123yes', NULL, NULL),
(19, 2, 'JC20260113145024', 0, NULL, 'car not working', NULL, NULL, NULL, 'Parts received', '2026-01-13 13:50:24', 'zee', 'easicall', '087 122 4444', '0847866910', '34 sandton av', '678747797898099', 'Toyota', 'Yaris', 'X3', '2018', 'black', 'WBAJTTN64446', NULL, NULL),
(20, 2, 'JC20260114073516', 0, NULL, 'Oil Service', NULL, '2026-01-13', '2026-01-20', 'Completed', '2026-01-14 06:35:16', 'Khaleed', 'Mohammed', '0613131310', '0621553281', 'L131 Midway Gardens Halfway Road Midrand', '7509086344184', 'CM19HTGP', 'Hyundai', 'IX35', '2013', 'Brown', 'XXXXX', NULL, NULL),
(21, 1, 'JC-TEST-001', 1, 1, '', NULL, NULL, NULL, 'Completed', '2026-01-27 08:51:49', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(23, 1, 'JC-TEST-002', 1, 1, 'Test problem', NULL, NULL, NULL, 'New', '2026-01-27 09:20:40', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(24, 1, 'JC-1769505870', 19, 10, 'Test problem', NULL, NULL, NULL, 'Parts received', '2026-01-27 09:24:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(25, 1, 'JC-FIXED-001', 20, 11, 'Test problem', NULL, NULL, NULL, 'New', '2026-01-27 10:09:58', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(27, 1, 'JC-1769511095', 22, 13, 'Auto-created for quotation', NULL, NULL, NULL, 'Completed', '2026-01-27 10:51:35', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(28, 1, 'JC-1770625166', 23, 14, 'Auto-created for quotation', NULL, NULL, NULL, 'Parts received', '2026-02-09 08:19:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(29, 0, 'JC20260212154206', 0, NULL, 'oil problems', NULL, '2020-10-10', '2020-10-20', 'Waiting for parts', '2026-02-12 14:42:06', 'ed', 'Phukela', '087 122 4444', '011 876 1234', '3354 ryan ave roodepoort', '678747797898099', 'Toyota', 'LEMO', 'LIMOZIN', '2020', 'green', '123yes', NULL, NULL),
(30, 0, 'JC20260218153234', 0, NULL, 'wheels', 3, NULL, NULL, 'New', '2026-02-18 14:32:34', 'Ntate', 'Mohammed', '087 122 4444', '098 123 5555', '34 sandton av', '678747797898099', 'Toyota', 'LEMO', 'X3', '2023', 'black', '56gg67', '0', 'wire'),
(32, 1, 'JC20260220135327', 14, NULL, 'cAR', 3, NULL, NULL, 'New', '2026-02-20 12:53:27', 'Aslam', 'Mohammed', '087 122 4444', '098 123 5555', '70 bashee ave', '86 199 800 62085', 'Toyota', 'LEMO', 'LIMOZIN', '2023', 'green', '56gg67', NULL, NULL),
(33, 1, 'JC20260221140313', 0, NULL, 'sdfgjkljhgfdghjkl;', 3, NULL, NULL, 'New', '2026-02-21 13:03:13', 'Ntate', NULL, '097 456 6895', NULL, '34 sandton av', NULL, 'Toyota', 'LEMO', 'X3', '2020', 'green', '56gg67', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `jobcardsparts`
--

CREATE TABLE `jobcardsparts` (
  `id` int(11) NOT NULL,
  `jobcard_id` int(11) DEFAULT NULL,
  `stock_id` int(11) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobcard_logs`
--

CREATE TABLE `jobcard_logs` (
  `id` int(11) NOT NULL,
  `jobcard_id` int(11) NOT NULL,
  `action` text NOT NULL,
  `performed_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `type` varchar(50) DEFAULT 'Update',
  `assigned_to` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jobcard_logs`
--

INSERT INTO `jobcard_logs` (`id`, `jobcard_id`, `action`, `performed_by`, `created_at`, `type`, `assigned_to`) VALUES
(1, 15, 'changed the breaks', 1, '2026-02-19 09:35:56', 'Update', NULL),
(2, 20, 'changed the breaks', 1, '2026-02-19 13:15:14', 'Update', NULL),
(3, 20, 'given to', 1, '2026-02-19 13:17:26', 'Update', NULL),
(4, 30, 'changed the breaks', 1, '2026-02-20 07:52:41', 'Update', NULL),
(5, 30, 'given to', 1, '2026-02-20 07:52:46', 'Update', NULL),
(6, 30, 'Thato took over from here cause we discovered another problem', 1, '2026-02-20 08:12:49', 'Update', NULL),
(7, 30, 'Thato took over from here cause we discovered another problem', 1, '2026-02-20 08:50:40', 'Transferred', NULL),
(8, 30, 'transfered to thando', 1, '2026-02-20 09:40:42', 'Transferred', NULL),
(9, 30, 'changed the tank', 1, '2026-02-20 10:29:23', 'Transferred', 'Joe'),
(10, 32, 'Jobcard created and assigned to Technician ID: 3', 1, '2026-02-20 12:53:27', 'Update', NULL),
(11, 33, 'Jobcard created and assigned to Technician ID: 3', 1, '2026-02-21 13:03:13', 'Update', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `jobcard_parts`
--

CREATE TABLE `jobcard_parts` (
  `id` int(11) NOT NULL,
  `jobcard_id` int(11) DEFAULT NULL,
  `stock_id` int(11) DEFAULT NULL,
  `quantity_used` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jobcard_parts`
--

INSERT INTO `jobcard_parts` (`id`, `jobcard_id`, `stock_id`, `quantity_used`) VALUES
(1, 0, NULL, 2),
(2, 2, 1, 1),
(3, 2, 1, 3),
(4, 2, 1, 3),
(5, 2, 3, 3),
(6, 2, 4, 2),
(7, 1, 4, 2),
(8, 1, 5, 2),
(9, 2, 3, 2),
(10, 6, 1, 2);

-- --------------------------------------------------------

--
-- Table structure for table `parts`
--

CREATE TABLE `parts` (
  `id` int(11) NOT NULL,
  `jobcard_id` int(11) NOT NULL,
  `part_name` varchar(100) NOT NULL,
  `quantity` int(11) DEFAULT 1,
  `status` enum('Ordered','Received') DEFAULT 'Ordered',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `parts`
--

INSERT INTO `parts` (`id`, `jobcard_id`, `part_name`, `quantity`, `status`, `created_at`) VALUES
(2, 18, 'wipers', 1, 'Ordered', '2026-01-13 13:31:16'),
(3, 15, 'wipers', 2, 'Received', '2026-01-13 13:33:56'),
(4, 19, 'engine', 1, 'Received', '2026-01-13 13:50:46'),
(7, 18, 'engine', 1, 'Ordered', '2026-01-13 13:59:48'),
(11, 9, 'wipers', 1, 'Received', '2026-01-13 14:08:23'),
(12, 20, 'Helix 5lt 10w40', 1, 'Received', '2026-01-14 06:39:56'),
(13, 20, 'oil', 1, 'Ordered', '2026-01-14 06:45:44'),
(14, 20, 'Gears', 1, 'Received', '2026-01-15 09:10:53'),
(15, 20, 'Gears', 1, 'Ordered', '2026-01-21 10:46:22'),
(16, 20, 'engine', 1, 'Ordered', '2026-01-21 13:49:50'),
(17, 20, 'oil', 1, 'Received', '2026-01-21 13:59:57'),
(18, 20, 'engine', 1, 'Received', '2026-01-21 14:44:05'),
(19, 24, 'Omonda wipe', 2, 'Ordered', '2026-01-30 10:03:47'),
(20, 27, 'oil gears  for sale', 1, 'Ordered', '2026-02-06 09:38:09'),
(21, 15, 'oil gears  for sale', 1, 'Received', '2026-02-10 10:52:20'),
(22, 28, 'oil', 1, 'Received', '2026-02-10 15:20:49'),
(23, 28, 'Helix 5lt 10w40', 2, 'Ordered', '2026-02-10 15:21:17'),
(24, 28, 'oil', 1, 'Ordered', '2026-02-12 14:27:42'),
(25, 19, 'oil gears  for sale', 1, 'Received', '2026-02-13 08:39:08'),
(26, 29, 'Gears', 1, 'Ordered', '2026-02-16 15:18:34');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_orders`
--

CREATE TABLE `purchase_orders` (
  `id` int(11) NOT NULL,
  `po_number` varchar(50) DEFAULT NULL,
  `supplier_id` int(11) NOT NULL,
  `order_date` date NOT NULL,
  `expected_date` date DEFAULT NULL,
  `subtotal` decimal(12,2) DEFAULT 0.00,
  `vat` decimal(12,2) DEFAULT 0.00,
  `total` decimal(12,2) DEFAULT 0.00,
  `status` enum('Pending','Received','Cancelled') DEFAULT 'Pending',
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchase_orders`
--

INSERT INTO `purchase_orders` (`id`, `po_number`, `supplier_id`, `order_date`, `expected_date`, `subtotal`, `vat`, `total`, `status`, `created_by`, `created_at`) VALUES
(1, 'PO-2026-0001', 2, '2026-02-18', '2026-02-23', 21601.00, 3240.15, 24841.15, 'Pending', 1, '2026-02-18 08:43:00'),
(2, 'PO-2026-0002', 1, '2026-02-18', '2026-02-25', 20801.00, 3120.15, 23921.15, 'Pending', 1, '2026-02-18 09:11:42'),
(3, 'PO-2026-0003', 2, '2026-02-10', '2026-02-20', 20001.00, 3000.15, 23001.15, 'Pending', 1, '2026-02-18 09:47:26'),
(5, 'PO-2026-0005', 2, '2026-02-10', '2026-02-20', 20001.00, 3000.15, 23001.15, 'Pending', 1, '2026-02-18 09:49:27'),
(7, 'PO-2026-0007', 1, '2026-02-10', '2026-02-20', 2200.00, 330.00, 2530.00, '', 1, '2026-02-18 09:54:06'),
(8, 'PO-2026-0008', 2, '2020-10-10', '2020-10-20', 1300.00, 195.00, 1495.00, 'Received', 1, '2026-02-18 10:06:12'),
(9, 'PO-2026-0009', 2, '2026-02-10', '2026-03-02', 70653.50, 10598.03, 81251.53, 'Received', 1, '2026-02-18 10:25:33');

-- --------------------------------------------------------

--
-- Table structure for table `purchase_order_items`
--

CREATE TABLE `purchase_order_items` (
  `id` int(11) NOT NULL,
  `purchase_order_id` int(11) NOT NULL,
  `stock_id` int(11) NOT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `unit_price` decimal(12,2) NOT NULL,
  `total` decimal(12,2) NOT NULL,
  `received_qty` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `purchase_order_items`
--

INSERT INTO `purchase_order_items` (`id`, `purchase_order_id`, `stock_id`, `quantity`, `unit_price`, `total`, `received_qty`) VALUES
(1, 1, 8, 2.00, 10000.50, 20001.00, 0),
(2, 1, 17, 4.00, 400.00, 1600.00, 0),
(3, 2, 17, 2.00, 400.00, 800.00, 0),
(4, 2, 11, 2.00, 10000.50, 20001.00, 0),
(5, 7, 17, 2.00, 400.00, 800.00, 0),
(6, 7, 9, 2.00, 700.00, 1400.00, 0),
(7, 8, 12, 2.00, 650.00, 1300.00, 2),
(8, 9, 11, 2.00, 10000.50, 20001.00, 2),
(9, 9, 12, 1.00, 650.00, 650.00, 1),
(10, 9, 8, 5.00, 10000.50, 50002.50, 5);

-- --------------------------------------------------------

--
-- Table structure for table `quotations`
--

CREATE TABLE `quotations` (
  `id` int(11) NOT NULL,
  `quotation_number` varchar(30) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `vehicle_id` int(11) DEFAULT NULL,
  `vehicle_text` varchar(100) DEFAULT NULL,
  `quotation_date` date NOT NULL,
  `valid_until` date DEFAULT NULL,
  `status` enum('Draft','Sent','Approved','Rejected') DEFAULT 'Draft',
  `created_by` int(11) DEFAULT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `approval_date` date DEFAULT NULL,
  `jobcard_id` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `subtotal` decimal(10,2) DEFAULT 0.00,
  `vat` decimal(10,2) DEFAULT 0.00,
  `discount` decimal(10,2) DEFAULT 0.00,
  `total` decimal(10,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quotations`
--

INSERT INTO `quotations` (`id`, `quotation_number`, `customer_id`, `vehicle_id`, `vehicle_text`, `quotation_date`, `valid_until`, `status`, `created_by`, `approved_by`, `approval_date`, `jobcard_id`, `notes`, `subtotal`, `vat`, `discount`, `total`, `created_at`) VALUES
(3, '', 14, NULL, NULL, '2025-12-08', '2025-12-20', 'Draft', NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, '2026-01-19 09:10:55'),
(6, 'Q-1768814375', 14, NULL, 'BMW', '2020-09-20', '2020-09-10', 'Draft', NULL, NULL, NULL, NULL, NULL, 0.00, 0.00, 0.00, 0.00, '2026-01-19 09:19:35'),
(7, 'Q-1768814418', 2, NULL, 'BMW', '2025-09-12', '2025-09-20', 'Approved', NULL, 1, '2026-01-27', NULL, NULL, 0.00, 0.00, 0.00, 0.00, '2026-01-19 09:20:18'),
(8, 'Q-1769507949', 19, 10, NULL, '2026-01-27', '2026-02-02', 'Approved', 1, 1, '2026-01-27', 24, 'Lebo said he will handle it ', 7.00, 15.00, 4.00, 4.05, '2026-01-27 09:59:09'),
(9, 'Q-1769511095', 22, 13, NULL, '2026-01-27', '2026-02-05', 'Approved', 1, 1, '2026-02-06', 27, 'Waiting for Zanele to say if she will take it ', 400.00, 15.00, 30.00, 430.00, '2026-01-27 10:51:35'),
(10, 'Q-1770625166', 23, 14, NULL, '2026-02-09', '2026-02-24', 'Draft', 1, NULL, NULL, 28, '', 550.00, 15.00, 0.00, 632.50, '2026-02-09 08:19:26');

-- --------------------------------------------------------

--
-- Table structure for table `quotation_items`
--

CREATE TABLE `quotation_items` (
  `id` int(11) NOT NULL,
  `quotation_id` int(11) NOT NULL,
  `stock_id` int(11) DEFAULT NULL,
  `description` varchar(255) NOT NULL,
  `quantity` decimal(10,2) DEFAULT 1.00,
  `unit_price` decimal(10,2) DEFAULT 0.00,
  `total` decimal(10,2) GENERATED ALWAYS AS (`quantity` * `unit_price`) STORED,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `quotation_items`
--

INSERT INTO `quotation_items` (`id`, `quotation_id`, `stock_id`, `description`, `quantity`, `unit_price`, `created_at`) VALUES
(1, 8, NULL, 'OIL', 1.00, 5.00, '2026-01-27 09:59:09'),
(2, 8, NULL, 'Wips', 1.00, 2.00, '2026-01-27 09:59:09'),
(3, 9, NULL, 'OIL', 2.00, 100.00, '2026-01-27 10:51:35'),
(4, 9, NULL, 'wipers', 4.00, 50.00, '2026-01-27 10:51:35'),
(5, 10, NULL, 'OIL', 1.00, 450.00, '2026-02-09 08:19:26'),
(6, 10, NULL, 'blue lights', 2.00, 50.00, '2026-02-09 08:19:26');

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `id` int(11) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `job_function` varchar(50) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `alt_phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `physical_address` varchar(255) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  `status` enum('Active','Inactive','On Leave') DEFAULT 'Active',
  `date_hired` date DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`id`, `full_name`, `job_function`, `phone`, `created_at`, `alt_phone`, `email`, `physical_address`, `city`, `province`, `postal_code`, `status`, `date_hired`, `date_of_birth`, `notes`) VALUES
(2, 'Joe', 'Store Clerk', '12345678', '2026-01-12 10:05:33', NULL, NULL, NULL, NULL, NULL, NULL, 'Active', NULL, NULL, NULL),
(3, 'Joe', 'Technician', '095986 676787', '2026-01-28 06:05:54', '6887988990', 'nonn@tyhjk', 'tr7r87380iko', 'yeyuu', 'gauteng', '1246', 'Active', '2008-10-09', '2026-01-09', ''),
(9, 'Thando', 'Technician', '084 453 5678', '2026-02-20 08:54:05', '011 934 5637', 'thando77@gmail.com', '25 Emdeni , wari steet,', 'Johhesburg', 'gauteng', '1246', 'Active', '2025-10-12', '2002-12-12', ''),
(14, 'Thando', 'Technician', '095986 676787', '2026-02-20 09:36:52', '6887988990', 'thando77@gmail.com', '25 Emdeni , wari steet,', 'Johhesburg', 'gauteng', '1246', 'Active', '2020-09-10', '2005-12-25', '');

-- --------------------------------------------------------

--
-- Table structure for table `stock`
--

CREATE TABLE `stock` (
  `id` int(11) NOT NULL,
  `stock_item_id` varchar(50) DEFAULT NULL,
  `part_name` varchar(150) NOT NULL,
  `manufacturer` varchar(100) DEFAULT NULL,
  `part_number` varchar(50) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `unit_price` decimal(10,2) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock`
--

INSERT INTO `stock` (`id`, `stock_item_id`, `part_name`, `manufacturer`, `part_number`, `supplier_id`, `quantity`, `unit_price`, `description`) VALUES
(1, NULL, '', NULL, 'brake pads', NULL, 10, 500.00, NULL),
(2, NULL, '', NULL, 'oil filters', NULL, 1, 100.00, NULL),
(3, NULL, '', NULL, 'Wipers blades', NULL, 1, 50.00, NULL),
(5, NULL, '', NULL, 'Brake fluid', NULL, 1, 90.00, NULL),
(8, '', 'engine', NULL, 'engine', 1, 10, 10000.50, 'shops - sweets'),
(9, 'ITEM56865', 'wipers', NULL, '444466', 1, 92, 700.00, 'its new as they come'),
(11, '9809', 'Omonda wipe', NULL, '7867', 1, 59, 10000.50, 'it helps with solve things for Omonde'),
(12, 'ITEM73987', 'Gears', NULL, '', 1, 168, 650.00, 'Gear parts for cars'),
(17, 'STK-1770895052', 'Mini keys', NULL, '34232', 2, 0, 400.00, 'locked keys');

-- --------------------------------------------------------

--
-- Table structure for table `stock_receipts`
--

CREATE TABLE `stock_receipts` (
  `id` int(11) NOT NULL,
  `invoice_number` varchar(50) NOT NULL,
  `receipt_date` date NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `stock_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `cost` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `stock_receipts`
--

INSERT INTO `stock_receipts` (`id`, `invoice_number`, `receipt_date`, `supplier_id`, `stock_id`, `quantity`, `cost`, `created_at`) VALUES
(1, '12345', '2026-10-06', 1, 12, 30, 100.00, '2026-01-15 14:33:51'),
(2, '12345', '2023-11-09', 1, 11, 5, 500.00, '2026-01-15 14:35:15'),
(3, '12345', '2023-11-09', 1, 8, 5, 500.00, '2026-01-15 14:35:42'),
(4, '12345', '2026-05-07', 1, 11, 50, 10.00, '2026-01-15 14:49:22'),
(5, '12345', '2020-10-11', 1, 12, 65, 100.00, '2026-01-16 07:47:06'),
(6, '6090', '2024-12-12', 1, 9, 90, 55.00, '2026-01-16 08:07:48'),
(7, '12345', '2020-10-10', 2, 12, 40, 250.00, '2026-02-10 10:54:36');

-- --------------------------------------------------------

--
-- Table structure for table `suppliers`
--

CREATE TABLE `suppliers` (
  `id` int(11) NOT NULL,
  `company_name` varchar(150) NOT NULL,
  `company_address` varchar(255) DEFAULT NULL,
  `company_ck` varchar(50) DEFAULT NULL,
  `vat_number` varchar(50) DEFAULT NULL,
  `company_tel` varchar(20) DEFAULT NULL,
  `company_email` varchar(100) DEFAULT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `contact_person_cell` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `suppliers`
--

INSERT INTO `suppliers` (`id`, `company_name`, `company_address`, `company_ck`, `vat_number`, `company_tel`, `company_email`, `contact_person`, `contact_person_cell`, `created_at`) VALUES
(1, 'Sweets Store', 'Randfointein\r\nrand streets', '2027-11-78', '23468', '011 789 3454', 'sweets@store.com', 'MR Store', '078 345 2346', '2026-01-14 09:45:26'),
(2, 'Auto Cars ', '34 Revunia', '2323907', '121010', '011 789 4565', 'auto@cars', 'mrs Auto', '063 178 8913', '2026-02-09 08:51:47');

-- --------------------------------------------------------

--
-- Table structure for table `supplier_invoices`
--

CREATE TABLE `supplier_invoices` (
  `id` int(11) NOT NULL,
  `purchase_order_id` int(11) NOT NULL,
  `supplier_invoice_number` varchar(100) DEFAULT NULL,
  `invoice_date` date DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `amount` decimal(12,2) DEFAULT NULL,
  `payment_status` enum('Unpaid','Partially Paid','Paid') DEFAULT 'Unpaid',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `supplier_payments`
--

CREATE TABLE `supplier_payments` (
  `id` int(11) NOT NULL,
  `supplier_invoice_id` int(11) NOT NULL,
  `payment_date` date DEFAULT NULL,
  `amount_paid` decimal(12,2) DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `reference_number` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(50) NOT NULL DEFAULT 'Technician',
  `status` enum('active','disabled') DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `email` varchar(150) NOT NULL,
  `mobile` varchar(20) NOT NULL,
  `otp_code` varchar(10) DEFAULT NULL,
  `otp_expiry` datetime DEFAULT NULL,
  `otp_attempts` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `status`, `created_at`, `email`, `mobile`, `otp_code`, `otp_expiry`, `otp_attempts`) VALUES
(1, 'admin', '$2y$10$RZhcT6vgr3pLJuuXTf2KhelsQHQt9PZVCPXj4zkwb0Lnm47oXYZze', 'Admin', 'active', '2026-02-06 11:23:33', 'user@example.com', '0123456789', NULL, NULL, 0),
(2, 'Manager1', '$2y$10$v11yLyr9hjv32YIfsAsMduv4y7B/082CwiG5ZvoPubcdvbCQXeA1e', 'Manager', 'active', '2026-02-12 09:44:01', 'user@example.com', '0123456789', NULL, NULL, 0),
(3, 'Joe', '$2y$10$CNhIFIJSEDUVhLP4L5OXGefkFA/r.eCJ3ZEYsknL0e3s8jIFV0nyK', 'technician', 'active', '2026-02-13 08:19:03', 'user@example.com', '0123456789', NULL, NULL, 0),
(5, 'Zanele', '$2y$10$o.QPeZqhWGYoEHerCmXMPOgf5Uzo3RlrtD9f3F6X4/bGUD2MNK1mO', 'manager', 'active', '2026-02-17 08:59:09', 'zanele.nemaphohoni@easicall.co.za', '063 116 5409', NULL, NULL, 0),
(6, 'Thando', '$2y$10$Wz.Vrrv/wTRGXbhAWIKoJOlCMp4jOd/8o803mJebtAZMCRiLxUVuS', 'technician', 'active', '2026-02-20 09:39:27', 'thando77@gmail.com', '063 116 1122', NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL,
  `customer_id` int(100) NOT NULL,
  `reg_no` varchar(50) NOT NULL,
  `model` varchar(50) NOT NULL,
  `make` varchar(50) NOT NULL,
  `year` int(11) NOT NULL,
  `vin` varchar(50) DEFAULT NULL,
  `colour` varchar(50) DEFAULT NULL,
  `vin_number` varchar(50) DEFAULT NULL,
  `registration_number` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vehicles`
--

INSERT INTO `vehicles` (`id`, `customer_id`, `reg_no`, `model`, `make`, `year`, `vin`, `colour`, `vin_number`, `registration_number`) VALUES
(1, 12, '102034', 'Toyota', 'Corolla', 2020, 'vin12345', NULL, NULL, NULL),
(3, 12, 'TOM', '4537', 'TAZZ', 2007, 'vin555', NULL, NULL, NULL),
(4, 12, '908676', 'tazz', 'Tazz', 2008, '29296', NULL, NULL, NULL),
(5, 6, '123456', '2020', 'Tazz', 2002, '', NULL, NULL, NULL),
(6, 2, '121212', 'X3', 'BMW', 2020, '', NULL, NULL, NULL),
(7, 13, '0000000000', 'LIMOZIN', 'LEMO', 2026, '', NULL, NULL, NULL),
(8, 14, 'jc64lwgp', '328I', 'BMW', 2012, 'WBAJTTN64446', NULL, NULL, NULL),
(10, 19, '', 'TestModel', 'TestMake', 0, NULL, NULL, NULL, NULL),
(11, 20, '', 'TestModel', 'TestMake', 0, NULL, NULL, NULL, NULL),
(13, 22, '123456gp', '2023', 'Suzuki', 2020, '', NULL, NULL, NULL),
(14, 23, '', 'X3', 'BMW x3', 0, NULL, 'blue', '133f', '43557'),
(15, 24, '345690', 'vw', 'Yaris', 2013, '56gg67', NULL, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `expenses`
--
ALTER TABLE `expenses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `expense_number` (`expense_number`);

--
-- Indexes for table `expense_categories`
--
ALTER TABLE `expense_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `income`
--
ALTER TABLE `income`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `income_categories`
--
ALTER TABLE `income_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `invoice_number` (`invoice_number`);

--
-- Indexes for table `invoice_history`
--
ALTER TABLE `invoice_history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoice_id` (`invoice_id`);

--
-- Indexes for table `jobcards`
--
ALTER TABLE `jobcards`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `jobcard_number` (`jobcard_number`),
  ADD KEY `fk_technician` (`technician_id`);

--
-- Indexes for table `jobcardsparts`
--
ALTER TABLE `jobcardsparts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `jobcard_logs`
--
ALTER TABLE `jobcard_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobcard_id` (`jobcard_id`);

--
-- Indexes for table `jobcard_parts`
--
ALTER TABLE `jobcard_parts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `parts`
--
ALTER TABLE `parts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobcard_id` (`jobcard_id`);

--
-- Indexes for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `po_number` (`po_number`);

--
-- Indexes for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `quotations`
--
ALTER TABLE `quotations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `quotation_number` (`quotation_number`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `vehicle_id` (`vehicle_id`),
  ADD KEY `created_by` (`created_by`),
  ADD KEY `approved_by` (`approved_by`),
  ADD KEY `jobcard_id` (`jobcard_id`);

--
-- Indexes for table `quotation_items`
--
ALTER TABLE `quotation_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `quotation_id` (`quotation_id`),
  ADD KEY `stock_id` (`stock_id`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `stock`
--
ALTER TABLE `stock`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `stock_item_id` (`stock_item_id`),
  ADD KEY `fk_supplier` (`supplier_id`);

--
-- Indexes for table `stock_receipts`
--
ALTER TABLE `stock_receipts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `supplier_id` (`supplier_id`),
  ADD KEY `stock_id` (`stock_id`);

--
-- Indexes for table `suppliers`
--
ALTER TABLE `suppliers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `supplier_invoices`
--
ALTER TABLE `supplier_invoices`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `supplier_payments`
--
ALTER TABLE `supplier_payments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_customer_id_idx` (`customer_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `expenses`
--
ALTER TABLE `expenses`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `expense_categories`
--
ALTER TABLE `expense_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `income`
--
ALTER TABLE `income`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `income_categories`
--
ALTER TABLE `income_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `invoice_history`
--
ALTER TABLE `invoice_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoice_items`
--
ALTER TABLE `invoice_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `jobcards`
--
ALTER TABLE `jobcards`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `jobcardsparts`
--
ALTER TABLE `jobcardsparts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobcard_logs`
--
ALTER TABLE `jobcard_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `jobcard_parts`
--
ALTER TABLE `jobcard_parts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `parts`
--
ALTER TABLE `parts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `purchase_orders`
--
ALTER TABLE `purchase_orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `purchase_order_items`
--
ALTER TABLE `purchase_order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `quotations`
--
ALTER TABLE `quotations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `quotation_items`
--
ALTER TABLE `quotation_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `stock`
--
ALTER TABLE `stock`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `stock_receipts`
--
ALTER TABLE `stock_receipts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `suppliers`
--
ALTER TABLE `suppliers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `supplier_invoices`
--
ALTER TABLE `supplier_invoices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `supplier_payments`
--
ALTER TABLE `supplier_payments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD CONSTRAINT `invoice_items_ibfk_1` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `jobcards`
--
ALTER TABLE `jobcards`
  ADD CONSTRAINT `fk_technician` FOREIGN KEY (`technician_id`) REFERENCES `staff` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `jobcard_logs`
--
ALTER TABLE `jobcard_logs`
  ADD CONSTRAINT `jobcard_logs_ibfk_1` FOREIGN KEY (`jobcard_id`) REFERENCES `jobcards` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `parts`
--
ALTER TABLE `parts`
  ADD CONSTRAINT `parts_ibfk_1` FOREIGN KEY (`jobcard_id`) REFERENCES `jobcards` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `quotations`
--
ALTER TABLE `quotations`
  ADD CONSTRAINT `quotations_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  ADD CONSTRAINT `quotations_ibfk_2` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`),
  ADD CONSTRAINT `quotations_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `quotations_ibfk_4` FOREIGN KEY (`approved_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `quotations_ibfk_5` FOREIGN KEY (`jobcard_id`) REFERENCES `jobcards` (`id`);

--
-- Constraints for table `quotation_items`
--
ALTER TABLE `quotation_items`
  ADD CONSTRAINT `quotation_items_ibfk_1` FOREIGN KEY (`quotation_id`) REFERENCES `quotations` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `quotation_items_ibfk_2` FOREIGN KEY (`stock_id`) REFERENCES `stock` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `stock`
--
ALTER TABLE `stock`
  ADD CONSTRAINT `fk_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`);

--
-- Constraints for table `stock_receipts`
--
ALTER TABLE `stock_receipts`
  ADD CONSTRAINT `stock_receipts_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers` (`id`),
  ADD CONSTRAINT `stock_receipts_ibfk_2` FOREIGN KEY (`stock_id`) REFERENCES `stock` (`id`);

--
-- Constraints for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD CONSTRAINT `fk_customer id` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
