import com.eric.mapper.EmployeeMapper;
import com.eric.pojo.Employee;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

/**
 * @Date: 2020/8/19 10:52
 * @author: Eric
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {

    @Autowired
    SqlSession sqlSession;

    // 使用测试方法向 t_emp 表中插入数据
    @Test
    public void testInsertEmp() {
        // 批量插入员工，可以使用批量操作的 sqlSession
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for (int i = 0; i < 1000; ++i) {
            String uid = UUID.randomUUID().toString().substring(0, 5) + i;
            mapper.insertSelective(new Employee(null, uid, "M", uid + "@126.com", 1));
        }
        sqlSession.close();
        System.out.println("批量执行成功");
    }
}
