# README

**项目简介**

基于 Maven + Spring + SpringMVC + MyBatis + Bootstrap 的组合，快速开发的一个完整的 CRUD 功能项目，本项目除了对框架组合的基本使用外，还涉及到许多的开发细节：Bootstrap 搭建页面，数据分页，Rest 风格的 URI，@ResponseBody 注解完成 AJAX，AJAX 发送 PUT 请求的问题，jQuery 前端校验和 JSR303 数据校验等。

**项目所用技术**

- SSM 框架
- MySQL 数据库
- Maven 项目开发管理工具
- Bootstrap 前端页面布局
- jQuery 及 AJAX 前端技术
-  JSON
- RESTful 设计风格
- PageHelper 分页技术

**项目的启动**

1. 项目克隆到本地

   ```
   git clone **
   ```

2. 在本地 IDE 中导入本项目（本人使用的是 IDEA），因为是 SSM 的 Web 项目，所以需要配置 Tomcat，这一步骤此处不再详细展开（有问题，找度娘）。

3. 使用 `src/main/resources/db`  目录下的 `db.sql` 语句创建相应的数据库，注意数据库配置文件`jdbc.properties` 与本地数据库环境的一致性。

4. 运行 `src/test/java/MapperTest.java` 测试类，其目的是向数据库中插入数据。

5. 启动 Tomcat，运行项目。

**项目功能展示**

- 支持分页显示用户信息、对用户信个或批量删除；

![展示1](https://gitee.com/eric0228/pic-go-images/raw/master/img/image-20201214162125295.png)

- 支持录入信息的前后端校验

![展示2](https://gitee.com/eric0228/pic-go-images/raw/master/img/image-20201214162430565.png)

- 更多功能请自行探索

**注意**

本项目旨在用来和大家学习交流，方便快速掌握 SSM 框架技术，不参与任何商用成分。

此项目来源于 B 站视频 https://www.bilibili.com/video/BV17W411g7zP，由本人根据视频实现，其中删去了部分内容：

- 使用单元测试来检测 SSM 框架的可用性及分页结果；
- MyBatis 逆向工程；
- 一些细节讲述。

感兴趣的童鞋可以自行去观看视频。