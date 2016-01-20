/*
Navicat MySQL Data Transfer

Source Server         : localhost
Source Server Version : 50546
Source Host           : localhost:3306
Source Database       : 91jin

Target Server Type    : MYSQL
Target Server Version : 50546
File Encoding         : 65001

Date: 2016-01-20 12:36:38
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for jb46o_interpreter
-- ----------------------------
DROP TABLE IF EXISTS `jb46o_interpreter`;
CREATE TABLE `jb46o_interpreter` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `datanameid` int(10) NOT NULL,
  `dataid` int(10) NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `nextpubdate` varchar(32) DEFAULT NULL,
  `dataagent` varchar(255) DEFAULT NULL,
  `frequency` varchar(32) DEFAULT NULL,
  `statistic` varchar(255) DEFAULT NULL,
  `dataeffect` varchar(255) DEFAULT NULL,
  `datadefinition` varchar(255) DEFAULT NULL,
  `concernreason` varchar(255) DEFAULT NULL,
  `graphdata` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of jb46o_interpreter
-- ----------------------------
