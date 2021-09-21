import com.eric.pojo.Employee;
import com.github.pagehelper.PageInfo;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

/**
 * 使用 Sprig 测试模块提供的测试请求功能，测试 crud 的正确性
 * Spring4 测试的时候，需要 Servlet3.0 的支持，所以要注意 Servlet 的版本
 *
 * @Date: 2020/8/19 15:39
 * @author: Eric
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration // 用来使用正确装配 WebApplicationContext
@ContextConfiguration(locations = {"classpath:applicationContext.xml", "classpath:spring-mvc.xml"})
public class MvcTest {

    // 传入 spring-mvc 的 ioc
    @Autowired
    WebApplicationContext context;

    // 虚拟 mvc 请求，获取到处理结果
    MockMvc mockMvc;

    // 初始化 MockMvc
    @Before
    public void initMockMvc() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void testPage() throws Exception {
        // 模拟请求并拿到返回值
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps")
                .param("pn", "4")).andReturn();
        // 请求成功之后，请求域会有 PageInfo，我们可以取出 PageInfo 进行验证
        MockHttpServletRequest request = result.getRequest();
        PageInfo<Employee> pageInfo = (PageInfo<Employee>) request.getAttribute("pageInfo");
        System.out.println("当前页码：" + pageInfo.getPageNum());
        System.out.println("总页码：" + pageInfo.getPages());
        System.out.println("总记录数：" + pageInfo.getTotal());
        System.out.println("在页面需要连续显示的页码：");
        int[] nums = pageInfo.getNavigatepageNums();
        for (int i : nums) {
            System.out.print(i + " ");
        }
        System.out.println();
        // 获取 pageIfo 里封装的员工数据
        List<Employee> employees = pageInfo.getList();
        for (Employee employee : employees) {
            System.out.println("ID: " + employee.getEmpId() + "==>Name: " + employee.getEmpName());
        }
    }
}
