<%--
  Created by IntelliJ IDEA.
  User: Eric
  Date: 2020/8/20
  Time: 11:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page isELIgnored="false" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>员工信息表</title>
    <%  // getContextPath 返回当前项目路径，以/开始但是不以/结束
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <!--
    web路径：
    不以 / 开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题。
    以 / 开始的相对路径，找资源，以服务器的路径(http://localhost:3306)为标准；
    需要加上项目名 http://localhost:3306/crud
    -->
    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css">
    <script src="${APP_PATH}/static/js/jquery-3.3.1.min.js"></script>
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>

    <!-- 搭建显示页面 -->
    <div class="container">
        <!-- 标题 -->
        <div class="row">
            <div class="col-md-12">
                <h1>SSM-CRUD</h1>
            </div>
        </div>
        <!-- 按钮 -->
        <div class="row">
            <div class="col-md-4 col-md-offset-8">
                <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
                <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
            </div>
        </div>
        <!-- 表格信息 -->
        <div class="row">
            <div class="col-md-12">
                <table class="table table-hover" id="employees_table">
                    <thead>
                    <tr>
                        <th>
                            <input type="checkbox" id="check_all">
                        </th>
                        <th>#</th>
                        <th>empName</th>
                        <th>gender</th>
                        <th>email</th>
                        <th>deptName</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>
        </div>
        <!-- 显示分页信息 -->
        <div class="row">
            <!-- 显示分页信息 -->
            <div class="col-md-6" id="page_info_area"></div>
            <!-- 分页条信息 -->
            <div class="col-md-6" id="page_nav_area"></div>
        </div>
    </div>

    <!-- 员工添加的模态框 -->
    <div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">添加员工</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
                            <div class="col-sm-10">
                                <input type="text" name="empName" class="form-control" id="empName_add_input"
                                       placeholder="empName">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="email_add_input" class="col-sm-2 control-label">email</label>
                            <div class="col-sm-10">
                                <input type="email" name="email" class="form-control" id="email_add_input"
                                       placeholder="email@126.com">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">gender</label>
                            <div class="col-sm-10">
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender1_add_input" value="M" checked> 男
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                                </label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="email_add_input" class="col-sm-2 control-label">deptName</label>
                            <div class="col-sm-4">
                                <%--部门提交部门id即可--%>
                                <select class="form-control" name="dId">
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
                </div>
            </div>
        </div>
    </div>

    <!-- 员工修改的模态框 -->
    <div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                            aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">修改员工信息</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">empName</label>
                            <div class="col-sm-10">
                                <p class="form-control-static" id="empName_update_static"></p>
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="email_update_input" class="col-sm-2 control-label">email</label>
                            <div class="col-sm-10">
                                <input type="email" name="email" class="form-control" id="email_update_input">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">gender</label>
                            <div class="col-sm-10">
                                <label class="radio-inline">
                                    <input type="radio" name="gender" value="M"> 男
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" value="F"> 女
                                </label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="email_add_input" class="col-sm-2 control-label">deptName</label>
                            <div class="col-sm-4">
                                <%--部门提交部门id即可--%>
                                <select class="form-control" name="dId">
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        // 总记录数，当前页
        let totalRecord, currentPage;
        // 页面加载完以后，直接去发送一个ajax请求，要到分页数据
        $(function () {
            // 获得首页
            to_page(1);
        });

        // 跳转到pn页码
        function to_page(pn) {
            $.ajax({
                url: "${APP_PATH}/emps",
                data: "pn=" + pn,
                type: "get",
                success: function (result) {
                    // console.log(result);
                    // 1. 解析并显示员工数据
                    build_employees_table(result);
                    // 2. 解析并显示分页信息
                    build_page_info(result);
                    // 3. 解析显示分页条数据
                    build_page_nav(result);
                }
            });
        }

        // 构建员工信息表
        function build_employees_table(result) {
            // 首先清空表格元素中的信息
            $("#employees_table tbody").empty();
            let employees = result.extend.pageInfo.list;
            $.each(employees, function (index, item) {
                // alert(item.empName);
                // 构建员工信息的单元格
                let checkboxTd = $("<td><input type='checkbox' class='check_item'/></td>");
                let empIdTd = $("<td></td>").append(item.empId);
                let empNameTd = $("<td></td>").append(item.empName);
                let genderTd = $("<td></td>").append(item.gender === "M" ? "男" : "女");
                let emailTd = $("<td></td>").append(item.email);
                let deptNameTd = $("<td></td>").append(item.department.deptName);
                // 两个操作按钮
                let editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
                    .append("编辑");
                // 为编辑按钮添加一个自定义属性，来表示当前员工的id
                editBtn.attr("edit-id", item.empId);
                let deleteBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                    .append($("<span></span>").addClass("glyphicon glyphicon-trash"))
                    .append("删除");
                // 为单个删除按钮添加一个自定义属性，来表示当前员工的id
                deleteBtn.attr("delete-id", item.empId);
                let btnTd = $("<td></td>").append(editBtn).append(" ").append(deleteBtn);
                // 构建员工的一行数据信息
                $("<tr></tr>").append(checkboxTd)
                    .append(empIdTd)
                    .append(empNameTd)
                    .append(genderTd)
                    .append(emailTd)
                    .append(deptNameTd)
                    .append(btnTd)
                    .appendTo("#employees_table tbody");
            });
        }

        //  解析显示分页条目数据
        function build_page_info(result) {
            // page_info_area
            // 首先清空分页信息区域
            $("#page_info_area").empty()
                .append("第" + result.extend.pageInfo.pageNum + "页，共"
                    + result.extend.pageInfo.pages + "页，共" +
                    result.extend.pageInfo.total + "条记录");
            // 记录总记录数
            totalRecord = result.extend.pageInfo.total;
            currentPage = result.extend.pageInfo.pageNum;
        }

        // 解析显示分页条信息
        function build_page_nav(result) {
            // page_nav_area
            // 清空分页条区域内容
            $("#page_nav_area").empty();
            let ul = $("<ul></ul>").addClass("pagination");
            // 首页和前一页
            let firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
            let prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
            if (result.extend.pageInfo.hasPreviousPage === false) {
                firstPageLi.addClass("disabled");
                prePageLi.addClass("disabled");
            } else {
                // 为元素添加翻页事件
                firstPageLi.click(function () {
                    to_page(1);
                });
                prePageLi.click(function () {
                    to_page(result.extend.pageInfo.pageNum - 1)
                });
            }
            // 后一页和尾页
            let nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
            let lastPageLi = $("<li></li>").append($("<a></a>").append("尾页").attr("href", "#"));
            if (result.extend.pageInfo.hasNextPage === false) {
                nextPageLi.addClass("disabled");
                lastPageLi.addClass("disabled");
            } else {
                // 为元素添加翻页事件
                nextPageLi.click(function () {
                    to_page(result.extend.pageInfo.pageNum + 1)
                });
                lastPageLi.click(function () {
                    to_page(result.extend.pageInfo.pages);
                });
            }
            // 向导航条中添加首页和前一页
            ul.append(firstPageLi).append(prePageLi);
            // 向导航条中添加中间显示的页码
            $.each(result.extend.pageInfo.navigatepageNums, function (index, item) {
                let numLi = $("<li></li>").append($("<a></a>").append(item));
                if (result.extend.pageInfo.pageNum === item) {
                    numLi.addClass("active");
                }
                // 为每个页码绑定事件
                numLi.click(function () {
                    to_page(item);
                });
                ul.append(numLi);
            });
            // 向导航条中添加下一页和尾页
            ul.append(nextPageLi).append(lastPageLi);
            // 把 ul 添加到 nav，并添加到分条区域，见 bootstrap
            $("<nav></nav>").append(ul).appendTo("#page_nav_area");
        }

        // 清空表单样式及内容
        function reset_form(ele) {
            $(ele)[0].reset();
            //清空表单样式
            $(ele).find("*").removeClass("has-error has-success");
            $(ele).find(".help-block").text("");
        }

        // 点击新增按钮弹出模态框
        $("#emp_add_modal_btn").click(function () {
            // 清除表单数据（表单完整重置（表单的数据，表单的样式））
            reset_form("#empAddModal form");
            // 发送ajax请求，查出部门信息，显示在下拉列表中
            getDepts("#empAddModal select");
            // 弹出模态框
            $("#empAddModal").modal({
                backdrop: "static"
            });
        });

        // 查出所有的部门信息，并显示在下拉列表中
        function getDepts(ele) {
            // 先把下拉框中的部门清空
            $(ele).empty();
            $.ajax({
                url: "${APP_PATH}/depts",
                type: "GET",
                success: function (result) {
                    // console.log(result);
                    // extend: {depts: [{deptId: 1, deptName: "开发部"}, {deptId: 2, deptName: "测试部"}]}}
                    // 显示部门在下拉列表中
                    $.each(result.extend.depts, function () {
                        let optionEle = $("<option></option>").append(this.deptName).attr("value", this.deptId);
                        optionEle.appendTo(ele);
                    })
                }
            });
        }

        // 校验表单数据
        function validate_add_form() {
            // 拿到校验数据，使用正则表达式
            // 1. 校验用户名，后端也会验证一下
            let empName = $("#empName_add_input").val();
            let regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5}$)/;
            if (!regName.test(empName)) {
                // alert("用户名可以是2-5位中文或者6-16位英文和数字的组合");
                show_validate_msg("#empName_add_input", "error", "用户名必须是6-16位数字和字母的组合或者2-5位中文");
                return false;
            } else {
                show_validate_msg("#empName_add_input", "success", "");
            }
            // 2. 校验邮箱信息
            let email = $("#email_add_input").val();
            let regEmail = /^([a-z0-9_.-]+)@([\da-z.-]+)\.([a-z.]{2,6})$/;
            if (!regEmail.test(email)) {
                // alert("邮箱格式不正确");
                //应该清空这个元素之前的样式
                show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
                return false;
            } else {
                show_validate_msg("#email_add_input", "success", "");
            }
            return true;
        }

        // 显示校验结果的提示信息
        function show_validate_msg(ele, status, msg) {
            // 清除当前元素的校验状态
            $(ele).parent().removeClass("has-success has-error");
            $(ele).next("span").text("");
            if ("success" === status) {
                $(ele).parent().addClass("has-success");
                $(ele).next("span").text(msg);
            } else if ("error" === status) {
                $(ele).parent().addClass("has-error");
                $(ele).next("span").text(msg);
            }
        }

        // 数据库校验用户名是否可用
        $("#empName_add_input").change(function () {
            //发送ajax请求校验用户名是否可用
            let empName = this.value;
            $.ajax({
                url: "${APP_PATH}/checkUser",
                data: "empName=" + empName,
                type: "POST",
                success: function (result) {
                    if (result.code === 100) {
                        show_validate_msg("#empName_add_input", "success", "用户名可用");
                        $("#emp_save_btn").attr("ajax-va", "success").removeAttr("disabled");
                    } else {
                        show_validate_msg("#empName_add_input", "error", result.extend.va_msg);
                        $("#emp_save_btn").attr("ajax-va", "error").attr("disabled", "true");
                    }
                }
            })
        });

        // 点击保存，保存员工信息
        $("#emp_save_btn").click(function () {
            // 1. 校验员工信息
            // 1.1 先前端校验输入的数据，如果不合法直接返回
            if (!validate_add_form()) {
                return false;
            }
            // 1.2 然后使用数据库的校验，验证用户名是否可用
            if ($(this).attr("ajax-va") === "error") {
                return false;
            }

            // 2. 发送ajax请求保存员工，此时再次利用后端验证，防止用户绕过前端校验
            $.ajax({
                url: "${APP_PATH}/emp",
                type: "POST",
                data: $("#empAddModal form").serialize(),
                success: function (result) {
                    if (result.code === 100) {
                        // 员工保存成功
                        // 1. 关闭模态框
                        $("#empAddModal").modal('hide');
                        // 2. 跳转至尾页显示保存结果
                        // 发送ajax请求显示最后一页
                        // 因为配置了分页合理化参数，所以可以使用一个较大的数字
                        to_page(totalRecord);
                    } else {
                        // 后端验证员工保存失败
                        // 员工姓名验证未通过，显示姓名错误信息
                        if (undefined === result.extend.errorFields.empName) {
                            show_validate_msg("#empName_add_input", "error", result.extend.errorFields.empName)
                        }
                        // 员工Email验证未通过，显示邮箱错误信息
                        if (undefined === result.extend.errorFields.email) {
                            show_validate_msg("#email_add_input", "error", result.extend.errorFields.email);
                        }
                    }
                }
            });
        });

        // 为编辑按钮绑定模态框
        // 注意我们是在按钮创建之前就绑定了click事件，所以需要一定的处理，两各解决方案：
        // 1）在创建按钮时绑定（太复杂）
        // 2）使用 on 方法，注意其用法（新版jQuery没有live方法了）
        $(document).on("click", ".edit_btn", function () {
            // 1. 查出并显示部门信息
            getDepts("#empUpdateModal select");
            // 2. 查出并显示员工信息（1、2顺序不可颠倒，不然部门信息无法正常显示
            getEmployeeById($(this).attr("edit-id"));
            // 弹出模态框
            $("#empUpdateModal").modal({
                backdrop: "static"
            });
            // 给弹出模态框的更新按钮绑定员工的id属性
            $("#emp_update_btn").attr("edit-id", $(this).attr("edit-id"));
        });

        $(document).on("click", ".delete_btn", function () {
            // 1. 弹出是否确认删除对话框
            let empName = $(this).parents("tr").find("td:eq(2)").text();
            let empId = $(this).attr("delete-id");
            if (confirm("确认删除【" + empName + "】吗？")) {
                // 确认删除，则发送ajax请求删除员工
                $.ajax({
                    url: "${APP_PATH}/emp/" + empId,
                    type: "DELETE",
                    success: function (result) {
                        // 显示处理结果
                        alert(result.msg);
                        // 回到本页
                        to_page(currentPage);
                    }
                })

            }
        });

        // 根据员工 id 查询员工信息
        function getEmployeeById(id) {
            $.ajax({
                url: "${APP_PATH}/emp/" + id,
                type: "GET",
                success: function (result) {
                    console.log(result);
                    let employee = result.extend.employee;
                    $("#empName_update_static").text(employee.empName);
                    $("#email_update_input").val(employee.email);
                    // 性别单选，选中当前员工的性别
                    $("#empUpdateModal input[name=gender]").val([employee.gender]);
                    // 下拉框选中当前员工的部门
                    $("#empUpdateModal select").val([employee.dId]);
                }
            });
        }

        // 点击更新按钮，更新员工信息
        $("#emp_update_btn").click(function () {
            // 校验邮箱信息是否合法
            let email = $("#email_update_input").val();
            let regEmail = /^([a-z0-9_.-]+)@([\da-z.-]+)\.([a-z.]{2,6})$/;
            if (!regEmail.test(email)) {
                show_validate_msg("#email_update_input", "error", "邮箱格式不正确");
                return false;
            } else {
                show_validate_msg("#email_update_input", "success", "");
            }

            // 发送ajax请求，保存员工数据
            $.ajax({
                url: "${APP_PATH}/emp/" + $(this).attr("edit-id"),
                type: "PUT",
                data: $("#empUpdateModal form").serialize(),
                success: function (result) {
                    // alert(result.msg);
                    // 关闭模态框
                    $("#empUpdateModal").modal("hide");
                    // 回到本页面
                    to_page(currentPage);
                }
            })
        });

        // 完成全选 or 全不全
        $("#check_all").click(function () {
            // 如果使用attr获取checked，结果为undefined，一般attr获取自定义属性的值
            // alert($(this).attr("checked"));
            // 这些dom原生的属性，我们使用prop修改和读取
            // alert($(this).prop("checked")); // true为选中，false为未选中
            // 我们把check_item设置成跟随check_all的状态变化
            $(".check_item").prop("checked", $(this).prop("checked"));
        });
        // 为check_item绑定事件
        $(document).on("click", ".check_item", function () {
            //判断当前页面选择中的元素是否全都勾选
            let flag = $(".check_item:checked").length === $(".check_item").length;
            $("#check_all").prop("checked", flag);
        });

        // 点击批量删除按钮触发批量删除事件
        $("#emp_delete_all_btn").click(function () {
            let empNames = "";
            let del_id_str = "";
            $.each($(".check_item:checked"), function () {
                empNames += $(this).parents("tr").find("td:eq(2)").text() + ",";
                // 组装员工 id 字符串
                del_id_str += $(this).parents("tr").find("td:eq(1)").text() + "-";
            });
            // 去除empNames最后的逗号
            empNames = empNames.substring(0, empNames.length - 1);
            // 去除员工id字符串最后的-
            del_id_str = del_id_str.substring(0, del_id_str.length - 1);
            if (confirm("确认删除【" + empNames + "】吗")) {
                $.ajax({
                    url: "${APP_PATH}/emp/" + del_id_str,
                    type: "DELETE",
                    success: function (result) {
                        // 显示处理结果信息
                        alert(result.msg);
                        // 回到当前页面
                        to_page(currentPage);
                    }
                })
            }
        });
    </script>
</body>
</html>
