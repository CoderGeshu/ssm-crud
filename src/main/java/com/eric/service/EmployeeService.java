package com.eric.service;

import com.eric.mapper.EmployeeMapper;
import com.eric.pojo.Employee;
import com.eric.pojo.EmployeeExample;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @Date: 2020/8/19 15:00
 * @author: Eric
 */
@Service("employeeService")
public class EmployeeService {
    private EmployeeMapper employeeMapper;

    @Autowired
    public EmployeeService(EmployeeMapper employeeMapper) {
        this.employeeMapper = employeeMapper;
    }

    /**
     * 查询所有员工
     *
     * @return 所有员工信息列表
     */
    public List<Employee> getAll() {
        return employeeMapper.selectByExampleWithDept(null);
    }

    /**
     * 保存员工
     *
     * @param employee 员工信息
     */
    public void saveEmployee(Employee employee) {
        employeeMapper.insertSelective(employee);
    }

    /**
     * 检验用户名是否可用
     *
     * @param empName 员工姓名
     * @return true：代表当前姓名可用   false：不可用
     */
    public boolean checkUser(String empName) {
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        return employeeMapper.countByExample(example) == 0;
    }

    /**
     * 根据员工 id 查询员工信息
     *
     * @param id 员工 id
     * @return 员工实体
     */
    public Employee getEmployeeById(Integer id) {
        return employeeMapper.selectByPrimaryKey(id);
    }

    /**
     * 根据员工 id 更新员工信息
     *
     * @param employee 员工信息
     * @return true：更新成功；false：更新失败
     */
    public boolean updateEmployee(Employee employee) {
        return employeeMapper.updateByPrimaryKeySelective(employee) != 0;
    }

    /**
     * 根据员工 id 删除员工信息
     *
     * @param id 员工 id
     * @return true：删除成功；false：删除失败
     */
    public boolean deleteEmployById(Integer id) {
        return employeeMapper.deleteByPrimaryKey(id) != 0;
    }


    /**
     * 批量删除员工信息
     *
     * @param ids 要删除的员工id列表
     */
    public boolean deleteEmployeeBatch(List<Integer> ids) {
        EmployeeExample example = new EmployeeExample();
        EmployeeExample.Criteria criteria = example.createCriteria();
        // delete from xxx where emp_id in(1,2,3)
        criteria.andEmpIdIn(ids);
        return employeeMapper.deleteByExample(example) != 0;
    }
}
