/*
Navicat MySQL Data Transfer

Source Server         : 192.168.99.199_3306
Source Server Version : 50542
Source Host           : 192.168.99.199:3306
Source Database       : cjrl

Target Server Type    : MYSQL
Target Server Version : 50542
File Encoding         : 65001

Date: 2016-01-19 16:14:03
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `jb46o_market_holiday`
-- ----------------------------
DROP TABLE IF EXISTS `jb46o_market_holiday`;
CREATE TABLE `jb46o_market_holiday` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `date` varchar(10) DEFAULT NULL,
  `time` varchar(10) DEFAULT NULL,
  `region` varchar(400) DEFAULT NULL,
  `market` varchar(400) DEFAULT NULL,
  `holiday` varchar(400) DEFAULT NULL,
  `plan` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=135 DEFAULT CHARSET=utf8;