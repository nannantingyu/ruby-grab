/*
Navicat MySQL Data Transfer

Source Server         : 192.168.99.199_3306
Source Server Version : 50542
Source Host           : 192.168.99.199:3306
Source Database       : cjrl

Target Server Type    : MYSQL
Target Server Version : 50542
File Encoding         : 65001

Date: 2016-01-19 16:13:53
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `jb46o_finance_data`
-- ----------------------------
DROP TABLE IF EXISTS `jb46o_finance_data`;
CREATE TABLE `jb46o_finance_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` varchar(10) DEFAULT NULL,
  `time` varchar(10) DEFAULT NULL,
  `region` varchar(400) DEFAULT NULL,
  `quota` varchar(400) DEFAULT NULL,
  `weight` varchar(400) DEFAULT NULL,
  `former_value` varchar(400) DEFAULT NULL,
  `predict_value` varchar(400) DEFAULT NULL,
  `public_value` varchar(400) DEFAULT NULL,
  `influnce` varchar(20) DEFAULT '',
  `datanameid` int(10) NOT NULL,
  `dataid` int(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=144537 DEFAULT CHARSET=utf8;

create table student(
  `id` int(10) not null primary key auto_increment,
  `name` varchar(20) not null,
  `gender` varchar(10) not null default 'male',
  `age` int(3) not null default 1
) ENGINE=InnoDB Default charset=utf8;

insert into student(name, gender, age) values('yaoyao', 'female', 21);
insert into student(name, gender, age) values('nannan', 'male', 24);