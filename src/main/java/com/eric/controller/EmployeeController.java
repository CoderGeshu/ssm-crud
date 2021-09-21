package com.eric.controller;

import com.eric.bean.Message;
import com.eric.pojo.Employee;
import com.eric.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.*;

/**
 * @Date: 2020/8/19 15:01
 * @author: Eric
 */
@Controller
public class EmployeeController {
    private EmployeeService employeeService;

    @Autowired
    public EmployeeController(EmployeeService employeeService) {
        this.employeeService = employeeService;
    }

    // 一个性能测试
    @RequestMapping("/demo")
    @ResponseBody
    public Message getAllEmployees() {
        List<Employee> employees = employeeService.getAll();
        return Message.success().add("employees", employees);
    }

    /**
     * 获取所有员工信息
     * 使用了插件 PageHelper，需要增加相关依赖，并在mybatis配置中增加此插件
     *
     * @param pn    起始页码
     * @param model 模型
     * @return 返回的页面
     */
    @RequestMapping("/emps")
    public String getAllEmployees(@RequestParam(value = "pn", defaultValue = "1") Integer pn,
                                  Model model) {
        // 引入 PageHelper 插件
        // 在查询之前只需要调用，传入起始页码，以及每页的大小（记录条数）
        PageHelper.startPage(pn, 5);
        // startPage 后紧跟的第一个查询就为一个分页查询
        List<Employee> employees = employeeService.getAll();
        // 使用 PageInfo 包装查询后的结果，同时使用导航页的功能，传入连续显示的页数
        // 它封装了详细的分页信息，包括我们查询出来的数据
        PageInfo<Employee> pageInfo = new PageInfo<Employee>(employees, 5);
        // 只需要将 PageInfo 交给页面即可
        model.addAttribute("pageInfo", pageInfo);
        return "list";
    }

    /**
     * 获取所有员工信息
     * <code>@ResponseBody</code>可以将返回对象自动转换为Json字符串
     *
     * @param pn 起始页码
     * @return PageInfo对象
     */
    @RequestMapping("/emps2")
    @ResponseBody
    public Message getEmployeesWithJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn) {
        // 引入 PageHelper 插件
        // 在查询之前只需要调用，传入起始页码，以及每页的大小（记录条数）
        PageHelper.startPage(pn, 5);
        // startPage 后紧跟的第一个查询就为一个分页查询
        List<Employee> employees = employeeService.getAll();
        // 使用 PageInfo 包装查询后的结果，同时使用导航页的功能，传入连续显示的页数
        // 它封装了详细的分页信息，包括我们查询出来的数据
        PageInfo<Employee> pageInfo = new PageInfo<Employee>(employees, 5);
        return Message.success().add("pageInfo", pageInfo);
    }

    /**
     * 检查用户名是否可用
     *
     * @param empName 用户名
     * @return 是否可用的信息
     */
    @RequestMapping("/checkUser")
    @ResponseBody
    public Message checkUser(@RequestParam("empName") String empName) {
        //先判断用户名是否是合法的表达式;
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})";
        if (!empName.matches(regx)) {
            return Message.failed().add("va_msg", "(后端校验）用户名必须是6-16位数字和字母的组合或者2-5位中文");
        }
        //数据库用户名重复校验
        boolean b = employeeService.checkUser(empName);
        if (b) {
            return Message.success();
        } else {
            return Message.failed().add("va_msg", "（后端校验）用户名不可用");
        }
    }

    /**
     * 员工保存
     * 支持 JSR303 校验，防止绕过前端，需要导入Hibernate-Validator
     */
    @RequestMapping(value = "/emp", method = RequestMethod.POST)
    @ResponseBody
    public Message saveEmployee(@Valid Employee employee, BindingResult result) {
        if (result.hasErrors()) {
            // 校验失败，应该返回失败，在模态框中显示校验失败的错误信息
            Map<String, Object> map = new HashMap<String, Object>();
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError fieldError : errors) {
                System.out.println("错误的字段名：" + fieldError.getField());
                System.out.println("错误信息：" + fieldError.getDefaultMessage());
                map.put(fieldError.getField(), fieldError.getDefaultMessage());
            }
            return Message.failed().add("errorFields", map);
        } else {
            // 没有校验错误才保存员工信息
            employeeService.saveEmployee(employee);
            return Message.success();
        }
    }

    /**
     * 根据员工 id 查询员工信息
     *
     * @param id 员工 id
     * @return 查询结果封装信息
     */
    @RequestMapping(value = "/emp/{id}", method = RequestMethod.GET)
    @ResponseBody
    public Message getEmployeeById(@PathVariable("id") Integer id) {
        return Message.success().add("employee", employeeService.getEmployeeById(id));
    }

    /**
     * 如果直接发送ajax=PUT形式的请求封装的数据
     * Employee 封装对象结果：
     * [empId=1014, empName=null, gender=null, email=null, dId=null]
     * <p>
     * 问题：
     * 请求体中有数据；
     * 但是Employee对象封装不上；
     * 使用的sql就会变成：update tbl_emp  where emp_id = 1014，语法报错
     * <p>
     * 原因：
     * Tomcat：
     * 1、将请求体中的数据，封装一个map。
     * 2、request.getParameter("empName")就会从这个map中取值。
     * 3、SpringMVC封装POJO对象的时候。
     * 会把POJO中每个属性的值，request.getParameter("email");
     * AJAX发送PUT请求引发的血案：
     * PUT请求，请求体中的数据，request.getParameter("empName")拿不到
     * Tomcat一看是PUT不会封装请求体中的数据为map，只有POST形式的请求才封装请求体为map
     * org.apache.catalina.connector.Request--parseParameters() (3111);
     * <p>
     * protected String parseBodyMethods = "POST";
     * if( !getConnector().isParseBodyMethod(getMethod()) ) {
     * success = true;
     * return;
     * }
     * <p>
     * 解决方案；
     * 我们要能支持直接发送PUT之类的请求还要封装请求体中的数据
     * 1、配置上HttpPutFormContentFilter；
     * 2、它的作用：将请求体中的数据解析包装成一个map；
     * 3、request被重新包装，request.getParameter()被重写，就会从自己封装的map中取数据。
     * 员工更新方法
     *
     * @param employee 自动封装的员工
     * @return 执行结果消息
     */
    // 使用empId与Employee属性名保持一致，spring-mvc才能自动封装
    @RequestMapping(value = "/emp/{empId}", method = RequestMethod.PUT)
    @ResponseBody
    public Message updateEmployee(Employee employee) {
        return employeeService.updateEmployee(employee) ? Message.success() : Message.failed();
    }

    /**
     * 根据员工 id 删除员工信息
     * 单个删除和批量删除二合一
     * 批量删除使用：1-2-3 形式
     * 单个删除使用：1 形式
     *
     * @param ids 员工 id （单个 id 或多个 id）
     * @return 执行结果封装信息
     */
    @RequestMapping(value = "/emp/{ids}", method = RequestMethod.DELETE)
    @ResponseBody
    public Message deleteEmployee(@PathVariable("ids") String ids) {
        if (ids.contains("-")) {
            // 批量删除
            String[] str_ids = ids.split("-");
            List<Integer> del_ids = new ArrayList<Integer>();
            // 组装 id 集合
            for (String string : str_ids) {
                del_ids.add(Integer.parseInt(string));
            }
            return employeeService.deleteEmployeeBatch(del_ids) ? Message.success() : Message.failed();
        } else {
            // 单个删除
            Integer id = Integer.parseInt(ids);
            return employeeService.deleteEmployById(id) ? Message.success() : Message.failed();
        }
    }
}
