package com.imooc.crud.service;

import com.imooc.crud.bean.Department;
import com.imooc.crud.dao.DepartmentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DepartmentService {

    @Autowired
    private DepartmentMapper departmentMapper;

    public List<Department> getDepts() {
        // 按照条件查询所有的部门信息，查所有，没有条件
        List<Department> list = departmentMapper.selectByExample(null);
        return list;
    }
}
