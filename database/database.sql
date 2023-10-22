-- MySQL dump 10.13  Distrib 8.0.19, for osx10.15 (x86_64)
--
-- Host: localhost    Database: gianni
-- ------------------------------------------------------
-- Server version	8.0.19

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `addresses` (
  `ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `street` varchar(255) NOT NULL,
  `nr` varchar(15) NOT NULL,
  `postalcode` varchar(15) NOT NULL,
  `region` varchar(255) NOT NULL,
  `country` varchar(255) NOT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `uq_addresses` (`street`,`nr`,`postalcode`,`region`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clubs`
--

DROP TABLE IF EXISTS `clubs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clubs` (
  `ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `info` text NOT NULL,
  `address` bigint unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `address` (`address`),
  CONSTRAINT `clubs_ibfk_1` FOREIGN KEY (`address`) REFERENCES `addresses` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clubs`
--

LOCK TABLES `clubs` WRITE;
/*!40000 ALTER TABLE `clubs` DISABLE KEYS */;
/*!40000 ALTER TABLE `clubs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event_tickets`
--

DROP TABLE IF EXISTS `event_tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `event_tickets` (
  `ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `event` bigint unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `price` double(10,6) unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `event` (`event`),
  CONSTRAINT `event_tickets_ibfk_1` FOREIGN KEY (`event`) REFERENCES `events` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_tickets`
--

LOCK TABLES `event_tickets` WRITE;
/*!40000 ALTER TABLE `event_tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `event_tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `events`
--

DROP TABLE IF EXISTS `events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `events` (
  `ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(512) NOT NULL,
  `info` text NOT NULL,
  `club` bigint unsigned NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `club` (`club`),
  CONSTRAINT `events_ibfk_1` FOREIGN KEY (`club`) REFERENCES `clubs` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `events`
--

LOCK TABLES `events` WRITE;
/*!40000 ALTER TABLE `events` DISABLE KEYS */;
/*!40000 ALTER TABLE `events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tickets`
--

DROP TABLE IF EXISTS `tickets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tickets` (
  `ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user` bigint unsigned NOT NULL,
  `event_ticket` bigint unsigned NOT NULL,
  `payment_id` varchar(255) DEFAULT NULL,
  `payment_status` varchar(32) NOT NULL DEFAULT 'unpaid',
  `is_scanned` tinyint(1) NOT NULL DEFAULT '0',
  `code` varchar(512) NOT NULL,
  PRIMARY KEY (`ID`),
  KEY `user` (`user`),
  KEY `event_ticket` (`event_ticket`),
  CONSTRAINT `tickets_ibfk_1` FOREIGN KEY (`user`) REFERENCES `users` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `tickets_ibfk_2` FOREIGN KEY (`event_ticket`) REFERENCES `event_tickets` (`ID`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tickets`
--

LOCK TABLES `tickets` WRITE;
/*!40000 ALTER TABLE `tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `tickets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `ID` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `telnr` varchar(20) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(512) NOT NULL,
  PRIMARY KEY (`ID`),
  UNIQUE KEY `telnr` (`telnr`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-10-22  9:26:36
