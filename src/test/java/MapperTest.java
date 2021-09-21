import com.eric.mapper.DepartmentMapper;
import com.eric.mapper.EmployeeMapper;
import com.eric.pojo.Department;
import com.eric.pojo.Employee;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 * 测试 mapper 层的工作
 * 推荐 Spring 项目使用 Spring 的单元测试，可以自动注入我们需要的组件
 * 1、需要导入 spring-test 依赖
 * 2、使用 @ContextConfiguration 注解指定 Spring 的配置文件位置
 * 3、使用 Junit4 中的 @RunWith 指定使用 SpringJUnit4ClassRunner 单元测试模块
 * 4、这样便可以直接 AutoWired 要使用的组件
 *
 * @Date: 2020/8/19 10:52
 * @author: Eric
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {

    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;

    /**
     * 测试 DepartmentMapper
     */
    @Test
    public void testCRUD() {
        // 1、创建Spring IOC容器
//        ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
        // 2、从容器中获取Mapper
//        DepartmentMapper departmentMapper = ioc.getBean(DepartmentMapper.class);
        System.out.println(departmentMapper);

        // 1、插入几个部门
//        departmentMapper.insertSelective(new Department(null, "开发部"));
//        departmentMapper.insertSelective(new Department(null, "测试部"));

        // 2、生成员工数据，测试插入员工
//        employeeMapper.insertSelective(new Employee(null, "Eric", "M", "eric@126.com",1));

        // 3、批量插入员工，可以使用批量操作的 sqlSession
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for (int i = 0; i < 1000; ++i) {
            String uid = UUID.randomUUID().toString().substring(0, 5) + i;
            mapper.insertSelective(new Employee(null, uid, "M", uid + "@126.com", 1));
        }
        sqlSession.close();
        System.out.println("批量执行成功");
    }
}
