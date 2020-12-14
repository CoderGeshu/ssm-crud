CREATE DATABASE ssm_curd;
USE ssm_curd;

DROP TABLE IF EXISTS `t_dept`;
CREATE TABLE `t_dept`
(
    `dept_id`   int(11)      NOT NULL AUTO_INCREMENT,
    `dept_name` varchar(255) NOT NULL,
    PRIMARY KEY (`dept_id`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 3
  DEFAULT CHARSET = utf8;

INSERT INTO `t_dept`
VALUES (1, '开发部'),
       (2, '测试部');

DROP TABLE IF EXISTS `t_emp`;
CREATE TABLE `t_emp`
(
    `emp_id`   int(11)      NOT NULL AUTO_INCREMENT,
    `emp_name` varchar(255) NOT NULL,
    `gender`   char(1)      DEFAULT NULL,
    `email`    varchar(255) DEFAULT NULL,
    `d_id`     int(11)      DEFAULT NULL,
    PRIMARY KEY (`emp_id`),
    FOREIGN KEY (`d_id`) REFERENCES `t_dept` (`dept_id`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 1016
  DEFAULT CHARSET = utf8;