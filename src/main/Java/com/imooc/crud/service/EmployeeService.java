package com.imooc.crud.service;

import com.imooc.crud.bean.Employee;
import com.imooc.crud.bean.EmployeeExample;
import com.imooc.crud.bean.Msg;
import com.imooc.crud.dao.DepartmentMapper;
import com.imooc.crud.dao.EmployeeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmployeeService {

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    DepartmentMapper departmentMapper;

    /**
     * 查询所有员工
     * @return
     */
    public List<Employee> getAll() {
        // 调用dao层 查询员工的所有信息（带上部门信息） 查询所有，没有查询条件
        return employeeMapper.selectByExampleWithDept(null);
    }

    /**
     * 员工保存方法
     * @param employee
     */
    public void saveEmp(Employee employee) {
        employeeMapper.insertSelective(employee);
    }

    /**
     * 校验用户名是否可用
     * @param empName
     * @return true ：代表当前姓名可用 false ：代表当前姓名在数据库中已经存在 不可用
     */
    public boolean checkuser(String empName) {

        EmployeeExample example = new EmployeeExample();
        // 创建查询条件
        EmployeeExample.Criteria criteria = example.createCriteria();
        // 拼装我们要的条件  员工的名字等于给定的值
        criteria.andEmpNameEqualTo(empName);
        // 按照条件统计符合条件的记录数
        long count = employeeMapper.countByExample(example);
        return count == 0;
    }

    /**
     * 按照员工Id查询员工
     * @param id
     * @return
     */
    public Employee getEmp(Integer id) {
        Employee employee = employeeMapper.selectByPrimaryKey(id);
        return employee;
    }

    /**
     * 员工更新方法
     * @param employee
     */
    public void updateEmp(Employee employee) {
        // 根据主键有选择的更新
        employeeMapper.updateByPrimaryKeySelective(employee);
    }

    /**
     * 员工删除
     * @param id
     */
    public void deleteEmp(Integer id) {
        //建议还是在service层用事务控制进行处理，先删除从表中数据，再删除主表中数据。
//        Employee employee = employeeMapper.selectByPrimaryKey(id);
//        departmentMapper.deleteByPrimaryKey(employee.getdId());
        employeeMapper.deleteByPrimaryKey(id);
    }

    public void deleteBatch(List<Integer> ids) {
        EmployeeExample employeeExample = new EmployeeExample();
        // 创建条件
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        // delete from xxx where emp_id in (1,2,3...)
        criteria.andEmpIdIn(ids);
        employeeMapper.deleteByExample(employeeExample);
    }
}
