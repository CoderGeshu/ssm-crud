package com.eric.service;

import com.eric.mapper.DepartmentMapper;
import com.eric.pojo.Department;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Date: 2020/8/23 17:15
 * @author: Eric
 */
@Service("departmentService")
public class DepartmentService {

    private final DepartmentMapper departmentMapper;

    @Autowired
    public DepartmentService(DepartmentMapper departmentMapper) {
        this.departmentMapper = departmentMapper;
    }

    public List<Department> getDepts() {
        return departmentMapper.selectByExample(null);
    }
}
