
-- Dumping structure for table tpzcore.subscriptions
CREATE TABLE IF NOT EXISTS `subscriptions` (
  `identifier` varchar(50) NOT NULL,
  `expiration_date` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`identifier`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;