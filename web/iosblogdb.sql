-- MySQL dump 10.13  Distrib 5.5.47, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: iosblogdb
-- ------------------------------------------------------
-- Server version	5.5.47-0ubuntu0.14.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissi_permission_id_84c5c92e_fk_auth_permission_id` (`permission_id`),
  CONSTRAINT `auth_group_permissi_permission_id_84c5c92e_fk_auth_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permissi_content_type_id_2f476e4b_fk_django_content_type_id` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add 一级分类',1,'add_domain'),(2,'Can change 一级分类',1,'change_domain'),(3,'Can delete 一级分类',1,'delete_domain'),(4,'Can add 二级分类',2,'add_aspect'),(5,'Can change 二级分类',2,'change_aspect'),(6,'Can delete 二级分类',2,'delete_aspect'),(7,'Can add 视角',3,'add_angle'),(8,'Can change 视角',3,'change_angle'),(9,'Can delete 视角',3,'delete_angle'),(10,'Can add 网址',4,'add_bookmark'),(11,'Can change 网址',4,'change_bookmark'),(12,'Can delete 网址',4,'delete_bookmark'),(13,'Can add log entry',5,'add_logentry'),(14,'Can change log entry',5,'change_logentry'),(15,'Can delete log entry',5,'delete_logentry'),(16,'Can add permission',6,'add_permission'),(17,'Can change permission',6,'change_permission'),(18,'Can delete permission',6,'delete_permission'),(19,'Can add group',7,'add_group'),(20,'Can change group',7,'change_group'),(21,'Can delete group',7,'delete_group'),(22,'Can add user',8,'add_user'),(23,'Can change user',8,'change_user'),(24,'Can delete user',8,'delete_user'),(25,'Can add content type',9,'add_contenttype'),(26,'Can change content type',9,'change_contenttype'),(27,'Can delete content type',9,'delete_contenttype'),(28,'Can add session',10,'add_session'),(29,'Can change session',10,'change_session'),(30,'Can delete session',10,'delete_session'),(31,'Can add application',11,'add_application'),(32,'Can change application',11,'change_application'),(33,'Can delete application',11,'delete_application'),(34,'Can add grant',12,'add_grant'),(35,'Can change grant',12,'change_grant'),(36,'Can delete grant',12,'delete_grant'),(37,'Can add access token',13,'add_accesstoken'),(38,'Can change access token',13,'change_accesstoken'),(39,'Can delete access token',13,'delete_accesstoken'),(40,'Can add refresh token',14,'add_refreshtoken'),(41,'Can change refresh token',14,'change_refreshtoken'),(42,'Can delete refresh token',14,'delete_refreshtoken');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user`
--

LOCK TABLES `auth_user` WRITE;
/*!40000 ALTER TABLE `auth_user` DISABLE KEYS */;
INSERT INTO `auth_user` VALUES (1,'pbkdf2_sha256$24000$TE0HmHZnfmqz$+6jvqlCXh4UTFCf3hUXa4pYCIWz5hqk5jfnY1fymavQ=','2016-02-18 00:00:32',1,'iosblog','','','iosblog@iosblog.so',1,1,'2016-02-08 22:50:12');
/*!40000 ALTER TABLE `auth_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_groups`
--

LOCK TABLES `auth_user_groups` WRITE;
/*!40000 ALTER TABLE `auth_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_perm_permission_id_1fbb5f2c_fk_auth_permission_id` (`permission_id`),
  CONSTRAINT `auth_user_user_perm_permission_id_1fbb5f2c_fk_auth_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_user_user_permissions`
--

LOCK TABLES `auth_user_user_permissions` WRITE;
/*!40000 ALTER TABLE `auth_user_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_user_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin__content_type_id_c4bce8eb_fk_django_content_type_id` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `django_admin__content_type_id_c4bce8eb_fk_django_content_type_id` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (1,'2016-02-08 23:06:21','1','程序开发',1,'Added.',1,1),(2,'2016-02-08 23:06:26','2','设计',1,'Added.',1,1),(3,'2016-02-08 23:06:38','1','程序',2,'已修改 name 。',1,1),(4,'2016-02-08 23:06:51','1','iOS',1,'Added.',2,1),(5,'2016-02-08 23:06:57','2','Python',1,'Added.',2,1),(6,'2016-02-08 23:07:07','3','C++',1,'Added.',2,1),(7,'2016-02-08 23:07:36','3','C++',3,'',2,1),(8,'2016-02-08 23:08:00','2','Python',3,'',2,1),(9,'2016-02-08 23:08:17','1','博客',1,'Added.',3,1),(10,'2016-02-08 23:08:43','2','必备',1,'Added.',3,1),(11,'2016-02-08 23:08:48','3','社区',1,'Added.',3,1),(12,'2016-02-08 23:09:02','2','资料',2,'已修改 name 。',3,1),(13,'2016-02-15 11:10:38','4','文章',1,'Added.',3,1),(14,'2016-02-15 13:50:22','4','General',1,'Added.',2,1),(15,'2016-02-16 17:41:27','5','C++',1,'Added.',2,1),(16,'2016-02-17 01:04:34','6','安全',1,'Added.',2,1),(17,'2016-02-17 01:05:09','7','工具',1,'Added.',2,1),(18,'2016-02-17 01:05:32','7','工具',3,'',2,1),(19,'2016-02-17 01:05:48','5','工具',1,'Added.',3,1),(20,'2016-02-17 20:41:16','5','C++',3,'',2,1),(21,'2016-02-17 20:41:33','6','Security',2,'已修改 name 。',2,1),(22,'2016-02-17 23:53:47','2','设计',2,'已修改 iconfont 。',1,1),(23,'2016-02-17 23:54:09','1','开发技术',2,'已修改 name 和 iconfont 。',1,1),(24,'2016-02-17 23:54:30','2','创意设计',2,'已修改 name 。',1,1),(25,'2016-02-17 23:54:55','3','最佳产品',1,'Added.',1,1),(26,'2016-02-18 00:02:59','1','iOS',2,'已修改 iconfont 。',2,1),(27,'2016-02-18 00:05:43','1','iOS',2,'已修改 iconfont 。',2,1),(28,'2016-02-18 00:05:52','8','Android',1,'Added.',2,1);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (5,'admin','logentry'),(7,'auth','group'),(6,'auth','permission'),(8,'auth','user'),(9,'contenttypes','contenttype'),(13,'oauth2_provider','accesstoken'),(11,'oauth2_provider','application'),(12,'oauth2_provider','grant'),(14,'oauth2_provider','refreshtoken'),(10,'sessions','session'),(3,'x123','angle'),(2,'x123','aspect'),(4,'x123','bookmark'),(1,'x123','domain');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2016-02-08 22:48:11'),(2,'auth','0001_initial','2016-02-08 22:48:11'),(3,'admin','0001_initial','2016-02-08 22:48:12'),(4,'admin','0002_logentry_remove_auto_add','2016-02-08 22:48:12'),(5,'contenttypes','0002_remove_content_type_name','2016-02-08 22:48:12'),(6,'auth','0002_alter_permission_name_max_length','2016-02-08 22:48:12'),(7,'auth','0003_alter_user_email_max_length','2016-02-08 22:48:12'),(8,'auth','0004_alter_user_username_opts','2016-02-08 22:48:12'),(9,'auth','0005_alter_user_last_login_null','2016-02-08 22:48:12'),(10,'auth','0006_require_contenttypes_0002','2016-02-08 22:48:12'),(11,'auth','0007_alter_validators_add_error_messages','2016-02-08 22:48:12'),(12,'oauth2_provider','0001_initial','2016-02-08 22:48:12'),(13,'oauth2_provider','0002_08_updates','2016-02-08 22:48:13'),(14,'sessions','0001_initial','2016-02-08 22:48:13'),(15,'x123','0001_initial','2016-02-08 22:48:13'),(16,'x123','0002_auto_20160123_2340','2016-02-08 22:48:14'),(17,'x123','0003_auto_20160217_2336','2016-02-17 23:43:15'),(18,'x123','0004_auto_20160217_2357','2016-02-17 23:58:49'),(19,'x123','0005_auto_20160218_0004','2016-02-18 00:05:20');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_de54fa62` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('wp2c5y6rk3qoe9r5fxmjmc17w46yepo9','ZDg2ZDQ2Y2MwZjAxZTlkMjNiMTUyMDgyNDIzMmRiOGRiMDU0ZmE3YTp7Il9hdXRoX3VzZXJfYmFja2VuZCI6ImRqYW5nby5jb250cmliLmF1dGguYmFja2VuZHMuTW9kZWxCYWNrZW5kIiwiX2F1dGhfdXNlcl9pZCI6IjEiLCJfYXV0aF91c2VyX2hhc2giOiJkYjFkNmZiMDYwOWFmMzc0NDAxZDQ4MzRjMWNjMGMxY2E4NTNmYmNhIn0=','2016-03-03 00:00:32'),('yfio4i4afm95iw9pc8f105q2gwrfz87k','MWMwZmE2MzRiN2M1MWU5NGNiYWMxYTQ1NmYzNzU3NjJhYjE1MDMyNjp7Il9hdXRoX3VzZXJfaGFzaCI6ImRiMWQ2ZmIwNjA5YWYzNzQ0MDFkNDgzNGMxY2MwYzFjYTg1M2ZiY2EiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOiIxIn0=','2016-02-28 11:09:24');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth2_provider_accesstoken`
--

DROP TABLE IF EXISTS `oauth2_provider_accesstoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oauth2_provider_accesstoken` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(255) NOT NULL,
  `expires` datetime NOT NULL,
  `scope` longtext NOT NULL,
  `application_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth2_application_id_b22886e1_fk_oauth2_provider_application_id` (`application_id`),
  KEY `oauth2_provider_accesstoken_user_id_6e4c9a65_fk_auth_user_id` (`user_id`),
  KEY `oauth2_provider_accesstoken_94a08da1` (`token`),
  CONSTRAINT `oauth2_application_id_b22886e1_fk_oauth2_provider_application_id` FOREIGN KEY (`application_id`) REFERENCES `oauth2_provider_application` (`id`),
  CONSTRAINT `oauth2_provider_accesstoken_user_id_6e4c9a65_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth2_provider_accesstoken`
--

LOCK TABLES `oauth2_provider_accesstoken` WRITE;
/*!40000 ALTER TABLE `oauth2_provider_accesstoken` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth2_provider_accesstoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth2_provider_application`
--

DROP TABLE IF EXISTS `oauth2_provider_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oauth2_provider_application` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client_id` varchar(100) NOT NULL,
  `redirect_uris` longtext NOT NULL,
  `client_type` varchar(32) NOT NULL,
  `authorization_grant_type` varchar(32) NOT NULL,
  `client_secret` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `user_id` int(11) NOT NULL,
  `skip_authorization` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `client_id` (`client_id`),
  KEY `oauth2_provider_application_user_id_79829054_fk_auth_user_id` (`user_id`),
  KEY `oauth2_provider_application_9d667c2b` (`client_secret`),
  CONSTRAINT `oauth2_provider_application_user_id_79829054_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth2_provider_application`
--

LOCK TABLES `oauth2_provider_application` WRITE;
/*!40000 ALTER TABLE `oauth2_provider_application` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth2_provider_application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth2_provider_grant`
--

DROP TABLE IF EXISTS `oauth2_provider_grant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oauth2_provider_grant` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `expires` datetime NOT NULL,
  `redirect_uri` varchar(255) NOT NULL,
  `scope` longtext NOT NULL,
  `application_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `oauth2_application_id_81923564_fk_oauth2_provider_application_id` (`application_id`),
  KEY `oauth2_provider_grant_user_id_e8f62af8_fk_auth_user_id` (`user_id`),
  KEY `oauth2_provider_grant_c1336794` (`code`),
  CONSTRAINT `oauth2_provider_grant_user_id_e8f62af8_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `oauth2_application_id_81923564_fk_oauth2_provider_application_id` FOREIGN KEY (`application_id`) REFERENCES `oauth2_provider_application` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth2_provider_grant`
--

LOCK TABLES `oauth2_provider_grant` WRITE;
/*!40000 ALTER TABLE `oauth2_provider_grant` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth2_provider_grant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth2_provider_refreshtoken`
--

DROP TABLE IF EXISTS `oauth2_provider_refreshtoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oauth2_provider_refreshtoken` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(255) NOT NULL,
  `access_token_id` int(11) NOT NULL,
  `application_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `access_token_id` (`access_token_id`),
  KEY `oauth2_application_id_2d1c311b_fk_oauth2_provider_application_id` (`application_id`),
  KEY `oauth2_provider_refreshtoken_user_id_da837fce_fk_auth_user_id` (`user_id`),
  KEY `oauth2_provider_refreshtoken_94a08da1` (`token`),
  CONSTRAINT `oauth2_provider_refreshtoken_user_id_da837fce_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  CONSTRAINT `oauth2_application_id_2d1c311b_fk_oauth2_provider_application_id` FOREIGN KEY (`application_id`) REFERENCES `oauth2_provider_application` (`id`),
  CONSTRAINT `oauth_access_token_id_775e84e8_fk_oauth2_provider_accesstoken_id` FOREIGN KEY (`access_token_id`) REFERENCES `oauth2_provider_accesstoken` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth2_provider_refreshtoken`
--

LOCK TABLES `oauth2_provider_refreshtoken` WRITE;
/*!40000 ALTER TABLE `oauth2_provider_refreshtoken` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth2_provider_refreshtoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `x123_angle`
--

DROP TABLE IF EXISTS `x123_angle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `x123_angle` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `zindex` int(11) NOT NULL,
  `description` longtext,
  `iconfont` varchar(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `x123_angle`
--

LOCK TABLES `x123_angle` WRITE;
/*!40000 ALTER TABLE `x123_angle` DISABLE KEYS */;
INSERT INTO `x123_angle` VALUES (1,'博客','2016-02-08 23:08:17','2016-02-08 23:08:17',0,'',''),(2,'资料','2016-02-08 23:08:43','2016-02-08 23:09:02',0,'',''),(3,'社区','2016-02-08 23:08:48','2016-02-08 23:08:48',0,'',''),(4,'文章','2016-02-15 11:10:38','2016-02-15 11:10:38',0,'',''),(5,'工具','2016-02-17 01:05:48','2016-02-17 01:05:48',0,'','');
/*!40000 ALTER TABLE `x123_angle` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `x123_aspect`
--

DROP TABLE IF EXISTS `x123_aspect`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `x123_aspect` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `zindex` int(11) NOT NULL,
  `description` longtext,
  `domain_id` int(11) NOT NULL,
  `iconfont` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `x123_aspect_662cbf12` (`domain_id`),
  CONSTRAINT `x123_aspect_domain_id_9512eeea_fk_x123_domain_id` FOREIGN KEY (`domain_id`) REFERENCES `x123_domain` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `x123_aspect`
--

LOCK TABLES `x123_aspect` WRITE;
/*!40000 ALTER TABLE `x123_aspect` DISABLE KEYS */;
INSERT INTO `x123_aspect` VALUES (1,'iOS','2016-02-08 23:06:51','2016-02-18 00:05:43',0,'',1,''),(4,'General','2016-02-15 13:50:22','2016-02-15 13:50:22',0,'',1,''),(6,'Security','2016-02-17 01:04:34','2016-02-17 20:41:33',0,'',1,''),(8,'Android','2016-02-18 00:05:52','2016-02-18 00:05:52',0,'',1,'');
/*!40000 ALTER TABLE `x123_aspect` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `x123_bookmark`
--

DROP TABLE IF EXISTS `x123_bookmark`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `x123_bookmark` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(200) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `url` longtext NOT NULL,
  `description` longtext,
  `favicon` longtext,
  `image` longtext,
  `feed_url` longtext,
  `feed_type` smallint(6) NOT NULL,
  `clicks` bigint(20) NOT NULL,
  `zindex` int(11) NOT NULL,
  `content_type` int(11) NOT NULL,
  `angle_id` int(11) NOT NULL,
  `aspect_id` int(11) NOT NULL,
  `creator_id` int(11) NOT NULL,
  `region` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `x123_bookmark_angle_id_8f4c6286_fk_x123_angle_id` (`angle_id`),
  KEY `x123_bookmark_aspect_id_15825847_fk_x123_aspect_id` (`aspect_id`),
  KEY `x123_bookmark_3700153c` (`creator_id`),
  CONSTRAINT `x123_bookmark_angle_id_8f4c6286_fk_x123_angle_id` FOREIGN KEY (`angle_id`) REFERENCES `x123_angle` (`id`),
  CONSTRAINT `x123_bookmark_aspect_id_15825847_fk_x123_aspect_id` FOREIGN KEY (`aspect_id`) REFERENCES `x123_aspect` (`id`),
  CONSTRAINT `x123_bookmark_creator_id_3a9d5570_fk_auth_user_id` FOREIGN KEY (`creator_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `x123_bookmark`
--

LOCK TABLES `x123_bookmark` WRITE;
/*!40000 ALTER TABLE `x123_bookmark` DISABLE KEYS */;
INSERT INTO `x123_bookmark` VALUES (2,'objc中国','2016-02-08 23:19:28','2016-02-08 23:19:28','http://objccn.io/','','http://objccn.io/assets/images/favicon.png',NULL,'',0,4,0,0,2,1,1,0),(3,'Pilky.me - the eternal ramblings of the voices inside my head','2016-02-14 11:09:57','2016-02-14 11:09:57','http://pilky.me/','','',NULL,'',0,0,0,0,1,1,1,0),(4,'Joel on Software','2016-02-14 11:30:23','2016-02-14 11:30:23','http://www.joelonsoftware.com/','','',NULL,'',0,0,0,0,1,1,1,0),(5,'YCFlame\'s Pensieve','2016-02-14 13:27:27','2016-02-14 13:27:27','http://ycflame.com/','','http://ycflame.com/favicon.ico',NULL,'',0,0,0,0,1,1,1,0),(6,'answer_huang - iOS developer，Python fans','2016-02-14 14:05:10','2016-02-14 14:05:10','http://answerhuang.duapp.com/','','',NULL,'',0,0,0,0,1,1,1,0),(7,'破船之家','2016-02-14 14:15:00','2016-02-14 14:15:00','http://beyondvincent.com/','','http://beyondvincent.com/favicon.png',NULL,'',0,0,0,0,1,1,1,0),(8,'Krzysztof Zabłocki - Krzysztof Zabłocki','2016-02-14 14:35:22','2016-02-14 14:35:22','http://merowing.info/','','',NULL,'',0,0,0,0,1,1,1,0),(9,'Coding Time','2016-02-14 16:13:21','2016-02-14 16:13:21','http://codingtime.me/','','http://codingtime.me/favicon.ico',NULL,'',0,0,0,0,1,1,1,0),(10,'KooFrank\'s Den','2016-02-14 16:43:38','2016-02-14 16:43:38','http://koofrank.com/','','http://koofrank.com/assets/images/favicon.png',NULL,'',0,0,0,0,1,1,1,0),(11,'di wu\' blog','2016-02-14 16:47:54','2016-02-14 16:47:54','http://diwu.me/','','http://diwu.me/assets/favicon.png?v=533b8e84a0',NULL,'',0,0,0,0,1,1,1,0),(12,'NSHipster','2016-02-14 16:51:28','2016-02-16 17:42:17','http://nshipster.com/','','http://nshipster.com/favicon.ico',NULL,'',0,0,0,0,2,1,1,0),(13,'David Rönnqvist','2016-02-14 17:19:04','2016-02-14 17:19:04','http://ronnqvi.st/','','http://ronnqvi.st/images/favicon.ico',NULL,'',0,0,0,0,1,1,1,0),(14,'Robb is Robert Böhnke','2016-02-14 17:33:40','2016-02-16 18:03:53','http://robb.is/','','',NULL,'',0,0,0,0,1,1,1,0),(15,'jailbreakdevelopers: Subreddit for iOS jailbreak developer community','2016-02-15 10:24:47','2016-02-15 10:24:47','https://www.reddit.com/r/jailbreakdevelopers/','','https://www.redditstatic.com/favicon.ico',NULL,'',0,0,0,0,3,1,1,0),(16,'如何面试 iOS 工程师？ - 知乎','2016-02-15 11:11:51','2016-02-15 11:11:51','https://www.zhihu.com/question/19604641','','https://static.zhihu.com/static/favicon.ico',NULL,'',0,0,0,0,4,1,1,0),(17,'V2EX','2016-02-15 13:50:39','2016-02-15 13:50:39','http://www.v2ex.com/','','http://www.v2ex.com/static/img/icon_rayps_64.png',NULL,'',0,0,0,0,3,4,1,0),(18,'Imgur: The most awesome images on the Internet','2016-02-15 13:52:59','2016-02-15 13:52:59','http://imgur.com/','','',NULL,'',0,0,0,0,3,4,1,0),(19,'唐巧的技术博客','2016-02-15 14:35:39','2016-02-15 14:35:39','http://blog.devtang.com/','','http://blog.devtang.com/favicon.png',NULL,'',0,0,0,0,1,1,1,0),(20,'Just for fun – Morisunshine\'s Blog','2016-02-15 17:34:58','2016-02-15 17:34:58','http://morisunshine.com/','','http://morisunshine.com/favicon.ico',NULL,'',0,0,0,0,1,1,1,0),(21,'OS X Development','2016-02-15 17:51:31','2016-02-15 17:51:31','http://jwilling.com/','','http://jwilling.com/assets/images/favicon.ico',NULL,'',0,0,0,0,1,1,1,0),(22,'Developers Academy','2016-02-16 13:23:33','2016-02-16 13:23:33','http://learn.developersacademy.io/','','',NULL,'',0,0,0,0,2,1,1,0),(23,'叶孤城___ - 简书','2016-02-16 15:34:29','2016-02-16 15:34:29','http://www.jianshu.com/users/b82d2721ba07/latest_articles','','http://baijii-common.b0.upaiyun.com/icons/favicon.ico',NULL,'',0,0,0,0,1,1,1,0),(24,'Migrant','2016-02-16 17:18:21','2016-02-16 17:18:21','http://objcio.com/','','http://objcio.com/favicon.png',NULL,'',0,0,0,0,1,1,1,0),(25,'DOPCN','2016-02-16 17:19:03','2016-02-16 17:19:03','http://blog.fengweizhou.com/','','http://blog.fengweizhou.com/assets/images/favicon.ico',NULL,'',0,0,0,0,1,1,1,0),(26,'Rm1210\'Blog · 为愚人描绘欢乐，为沉思者描绘忧郁','2016-02-16 17:24:23','2016-02-16 17:24:23','http://rm1210.github.io/','','',NULL,'',0,0,0,0,1,1,1,0),(27,'Approaching Analogies','2016-02-16 17:25:42','2016-02-16 17:25:42','http://arigrant.com/','','http://arigrant.com/favicon.ico',NULL,'',0,0,0,0,1,1,1,0),(28,'Ray Wenderlich | Tutorials for iPhone / iOS Developers and Gamers','2016-02-16 17:39:18','2016-02-16 17:39:18','http://www.raywenderlich.com/','','http://www.raywenderlich.com/favicon.ico',NULL,'',0,0,0,0,2,1,1,0),(29,'How-To Tutorials & Free Online Courses by Envato Tuts+','2016-02-16 17:40:01','2016-02-16 17:40:01','http://tutsplus.com/','','http://static.tutsplus.com/assets/favicon-8b86ba48e7f31535461f183680fe2ac9.png',NULL,'',0,0,0,0,2,1,1,0),(30,'objc.io','2016-02-16 17:44:44','2016-02-16 17:44:44','https://www.objc.io/','','https://www.objc.io/favicon.ico',NULL,'',0,0,0,0,2,1,1,0),(31,'Subjective-C · a study of innovative iOS interfaces','2016-02-16 17:47:54','2016-02-16 17:47:54','http://subjc.com/','','http://subjc.com/assets/images/favicon.ico',NULL,'',0,0,0,0,1,1,1,0),(33,'txx\'s blog','2016-02-16 17:54:11','2016-02-16 17:54:11','http://blog.txx.im/','','',NULL,'',0,0,0,0,1,1,1,0),(34,'Introduction | ios核心动画高级技巧','2016-02-16 17:56:53','2016-02-16 17:56:53','https://zsisme.gitbooks.io/ios-/content/','','https://zsisme.gitbooks.io/ios-/content/gitbook/images/favicon.ico',NULL,'',0,0,0,0,2,1,1,0),(35,'Adoption Curve Dot Net','2016-02-16 18:02:37','2016-02-16 18:02:37','https://adoptioncurve.net/','','https://adoptioncurve.net/favicon.png',NULL,'',0,0,0,0,1,1,1,0),(36,'Itty Bitty Labs','2016-02-16 18:02:55','2016-02-16 18:02:55','http://blog.ittybittyapps.com/','','http://blog.ittybittyapps.com/favicon.png',NULL,'',0,0,0,0,1,1,1,0),(37,'Stuart Hall - iOS Development','2016-02-16 18:03:11','2016-02-16 18:03:11','http://stuartkhall.com/','','http://stuartkhall.com/favicon.ico',NULL,'',0,0,0,0,1,1,1,0),(38,'nvie.com','2016-02-16 18:03:21','2016-02-16 18:03:21','http://nvie.com/','','http://nvie.com/img/favicon.ico',NULL,'',0,0,0,0,1,1,1,0),(39,'Indie Ambitions ← Looking forward to freedom from the daily grind','2016-02-16 18:03:36','2016-02-16 18:03:36','http://indieambitions.com/','','http://indieambitions.com/wp-content/uploads/2012/09/favicon.ico',NULL,'',0,0,0,0,1,1,1,0),(40,'Command Shift','2016-02-16 18:03:44','2016-02-16 18:03:44','http://commandshift.co.uk/','','',NULL,'',0,0,0,0,1,1,1,0),(41,'Think & Build - Tutorials about OS X, iOS and web development!','2016-02-16 18:04:01','2016-02-16 18:04:01','http://www.thinkandbuild.it/','','http://www.thinkandbuild.it/favicon.png',NULL,'',0,0,0,0,1,1,1,0),(42,'iOS App Dev Libraries, Controls, Tutorials, Examples and Tools','2016-02-16 18:04:14','2016-02-16 18:04:14','https://maniacdev.com/','','https://maniacdev.com/favicon.ico',NULL,'',0,0,0,0,1,1,1,0),(43,'NSHipster 中文版','2016-02-16 18:08:56','2016-02-16 18:08:56','http://nshipster.cn/','','http://nshipster.cn/favicon.ico',NULL,'',0,0,0,0,2,1,1,0),(44,'傻蛋联网设备搜索平台（傻蛋）','2016-02-17 01:04:46','2016-02-17 01:05:55','https://www.oshadan.com/','','https://www.oshadan.com/favicon.ico',NULL,'',0,0,0,0,5,6,1,0),(45,'Cooper\'s Blog','2016-02-17 17:58:44','2016-02-17 17:58:44','http://tanqisen.github.io/','','http://tanqisen.github.io/favicon.png',NULL,'',0,0,0,0,1,1,1,0);
/*!40000 ALTER TABLE `x123_bookmark` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `x123_domain`
--

DROP TABLE IF EXISTS `x123_domain`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `x123_domain` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `zindex` int(11) NOT NULL,
  `description` longtext,
  `iconfont` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `x123_domain`
--

LOCK TABLES `x123_domain` WRITE;
/*!40000 ALTER TABLE `x123_domain` DISABLE KEYS */;
INSERT INTO `x123_domain` VALUES (1,'开发技术','2016-02-08 23:06:21','2016-02-17 23:54:09',0,'','&#xe601;'),(2,'创意设计','2016-02-08 23:06:26','2016-02-17 23:54:30',0,'','&#xe602;'),(3,'最佳产品','2016-02-17 23:54:55','2016-02-17 23:54:55',0,'','&#xe61d;');
/*!40000 ALTER TABLE `x123_domain` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-02-18  0:24:22
