package com.imooc.crud.test;

import com.github.pagehelper.PageInfo;
import com.imooc.crud.bean.Employee;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MockMvcBuilder;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

/**
 * 使用Spring测试模块提供的测试请求功能，测试crud请求的准确性
 * Spring4测试的时候，需要servlet3.0的支持
 */


@RunWith(SpringJUnit4ClassRunner.class)// 用Spring单元测试驱动来做，在Spring容器中做
@WebAppConfiguration // 这个注解可以使web ioc容器对象 也能通过@Autowired自动注入
// 加载Spring和SpringMVC的配置文件




@ContextConfiguration(locations = {"classpath:applicationContext.xml", "file:D:\\IDEASSM框架整合\\ssm-crud\\src\\main\\webapp\\WEB-INF\\dispatcherServlet-servlet.xml"})
public class MvcTest {

    // 传入Springmvc的IOC
    @Autowired
    WebApplicationContext context;// web ioc容器对象  注入

    //虚拟mvc请求， 获取到处理结果
    MockMvc mockMvc;

    @Before
    public void initMockMvc(){
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    /**
     * 模拟请求测试类
     * @throws Exception
     */
    @Test
    public void testPage() throws Exception {
        // 模拟请求拿到返回值    /emps?pn=1
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn", "5")).andReturn();

        // 请求成功以后，请求域中会有pageInfo； 我们可以取出pageInfo进行验证
        MockHttpServletRequest request = result.getRequest();
        PageInfo pageInfo = (PageInfo) request.getAttribute("pageinfo");
        System.out.println("当前页码 ：" + pageInfo.getPageNum());
        System.out.println("总页码 ：" + pageInfo.getPages());
        System.out.println("总记录数 ：" + pageInfo.getTotal());
        System.out.println("在页面需要连续显示的页码 ：");
        int[] nums = pageInfo.getNavigatepageNums();
        for (int i :nums){
            System.out.print("  " + i);
        }
        System.out.println();
        // 获取员工数据
        List<Employee> list = pageInfo.getList();
        for (Employee employee : list){
            System.out.println("ID:" + employee.getEmpId() + "==>Name:" + employee.getEmpName());
        }
    }

}
