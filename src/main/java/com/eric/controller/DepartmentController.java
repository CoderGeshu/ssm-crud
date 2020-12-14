package com.eric.controller;

import com.eric.bean.Message;
import com.eric.pojo.Department;
import com.eric.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

/**
 * 处理与部门有关的请求
 *
 * @Date: 2020/8/23 17:14
 * @author: Eric
 */
@Controller
public class DepartmentController {

    private final DepartmentService departmentService;

    @Autowired
    public DepartmentController(DepartmentService departmentService) {
        this.departmentService = departmentService;
    }

    // 返回所有部门信息
    @RequestMapping(value = "/depts")
    @ResponseBody
    public Message getDepts(){
        // 查询所有部门信息
        List<Department> depts = departmentService.getDepts();
        return Message.success().add("depts", depts);
    }
}
