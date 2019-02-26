package com.imooc.crud.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.imooc.crud.bean.Employee;
import com.imooc.crud.bean.Msg;
import com.imooc.crud.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 处理员工CRUD请求
 */
@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    /**
     * 单个批量二合一
     * 批量删除：1-2-3
     * 单个删除：1
     * @param ids
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "/emps/{ids}", method = RequestMethod.DELETE)
    public Msg deleteEmpById(@PathVariable("ids")String ids){
        if (ids.contains("-")){ // 批量删除
            List<Integer> del_ids = new ArrayList<>();
            String[] str_ids = ids.split("-");
            // 组装id的集合
            for (String string:str_ids
                 ) {
                del_ids.add(Integer.parseInt(string));
            }
            employeeService.deleteBatch(del_ids);
        }else{ //单个删除
            Integer id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }
        return Msg.success();
    }

    /**
     * 员工更新方法
     *
     * 如果直接发送ajax=PUT形式的请求
     *  将要更新的员工数据：Employee{empId=1016, empName='null',
     *  gender='null', email='null', dId=null, department=null}
     *
     *  问题：
     *  请求体中有数据，
     *  但是Employee对象封装不上，
     *
     *  原因：
     *  Tomcat：
     *      1、将请求体中的数据，封装一个map。
     *      2、request.getParameter("empName")就会从这个map中取值。
     *      3、SpringMvc封装POJO对象的时候。
     *              会把POJO中每个属性的值，调用request.getParameter("email")来取；
     *  ajax发送PUT请求引发的
     *      PUT请求，请求体中的数据 request.getParameter("empName")拿不到
     *      Tomcat一看是PUT请求， 就不会封装请求体中的数据为Map，只有POST形式的请求才封装请求体为Map
     *
     * 解决方案：
     *  我们要能支持直接发送PUT之类的请求，还要封装请求体中的数据
     *  1、在web.xml中配置上HttpPutFormContentFilter
     *  2、他的作用：将请求体中的数据解析包装成一个map，
     *  3、request被重新包装， request.getParameter()被重写，就会从自己封装的Map中取数据
     *
     * @param employee
     * @return
     */
    @RequestMapping(value = "/emps/{empId}", method = RequestMethod.PUT)
    @ResponseBody
    public Msg saveEmp(Employee employee, HttpServletRequest request){
        System.out.println("请求体中的值" + request.getParameter("gender"));
        System.out.println("将要更新的员工数据：" + employee);
        employeeService.updateEmp(employee);
        return Msg.success();
    }

    /**
     * 按照员工id查询员工方法
     *  使用rest风格的url请求方式
     * @param id
     * @return
     */
    @RequestMapping(value = "/emps/{id}", method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id){

        Employee employee = employeeService.getEmp(id);
        return  Msg.success().add("emp", employee);
    }

    /**
     * 检查用户名是否可用
     * @param empName
     * @return
     */
    @ResponseBody
    @RequestMapping("/checkuser")
    public Msg checkuser(@RequestParam("empName") String empName){
        // 先判断用户名是否是合法的表达式
        String regex = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if (!empName.matches(regex)){
            return Msg.fail().add("va_msg", "用户名可以是2-5为中文或者是6-16位英文和数字的组合");
        }
        // 数据库用户名重复校验
        boolean b = employeeService.checkuser(empName);
        if (b){
            return Msg.success();
        }else{
            return Msg.fail().add("va_msg", "用户名不可用");
        }
    }

    /**
     * 员工保存
     * 1、支持JSR303检验
     * 2、导入Hibernate-Validator
     * @return
     */
    @RequestMapping(value = "/emps", method = RequestMethod.POST)
    @ResponseBody
    // @Valid 代表封装对象以后，这里边的数据要进行校验   BindingResult result 封装校验的结果
    public Msg saveEmp(@Valid Employee employee, BindingResult result){
        if (result.hasErrors()){
            // 校验失败,应该返回失败，在模态框中显示校验失败的错误信息
            Map<String, Object> map = new HashMap<>();
            List<FieldError> errors = result.getFieldErrors();
            for (FieldError fieldError : errors){
                System.out.println("错误的字段名：" + fieldError.getField());
                System.out.println("错误信息：" + fieldError.getDefaultMessage());
                map.put(fieldError.getField(), fieldError.getDefaultMessage());
            }
            return Msg.fail().add("errorFields", map);
        }else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }

    /**
     * 1、index.jsp页面直接发送ajax请求进行员工分页数据的查询
     * 2、服务器将查出的数据，以JSON字符串的形式返回给浏览器
     * 3、浏览器收到JSON字符串。可以使用js对JSON进行解析，使用js通过 dom增删改 改变页面
     * 4、返回JSON。实现客户端的无关性
     * @return
     */
    @RequestMapping("/emps")
    @ResponseBody // 将返回的模型数据对象转换为JSON格式 需要导入jackson包
    public Msg getEmpsWithJson(@RequestParam(value = "pn", defaultValue = "1")Integer pn){

        // 引入PageHelper分页插件 在查询之前调用，传入页码， 以及每一页的大小
        PageHelper.startPage(pn, 5);
        // 此查询在 startPage 之后，那么这个方法就是一个分页查询
        List<Employee> emps = employeeService.getAll();
        // 使用PageInfo对查询到的结果进行包装，封装完成之后，只需要将PageInfo交给页面就行
        // 封装了详细的分页信息，包括有我们查询出来的数据 , 传入连续显示的页数（导航页） -- 具体参照官方文档
        PageInfo pageInfo = new PageInfo(emps, 5);//navigatePages 导航页显示的个数
        return Msg.success().add("pageInfo", pageInfo);
    }

    /**
     * 查询员工数据（分页查询）
     * @param pn 根据请求传递过来的参数确定查询的是第几页的信息， 如果没有传递第几页，默认值为第一页
     * @return
     */
//    @RequestMapping("/emps")
    public String getEmps(@RequestParam(value = "pn",defaultValue = "1") Integer pn, Model model){
        // 这不是一个分页查询
        // 引入PageHelper分页插件
        // 在查询之前只需要调用， 传入页码，以及每一页的大小
        PageHelper.startPage(pn, 5);
        // startPage后面紧跟的这个查询就是一个分页查询
        List<Employee> emps = employeeService.getAll();

        // 用PageInfo对结果进行包装 只需要将pageInfo交给页面就行了 -- 参考官网
        // 封装了详细的分页信息，包括有我们查询出来的数据 , 传入连续显示的页数（导航页）
        PageInfo page = new PageInfo(emps, 5);

        model.addAttribute("pageInfo", page);
        return "list";
    }

}
