<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>员工列表</title>
    <%
        // 此时pageContext域中存放的项目路径对象是以 / 开始， 但是不是以 /  结束的
        pageContext.setAttribute("APP_PATH",request.getContextPath());
    %>
    <!-- web的路径问题
        不以 / 开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题
        以 / 开始的相对路径，找资源以服务器的路径为标准 （http://localhost:3306）； 需要加上项目名
            http://localhost:3306/crud
     -->
    <!-- 引入Jquery -->
    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-1.12.4.min.js">

    </script>
    <!-- 引入样式 -->
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>

<!-- 员工修改的模态框 -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <p class="form-control-static" id="empName_update_static"></p>
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_update_input" placeholder="email@imooc.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <!-- 部门提交部门id即可 -->
                            <select class="form-control" name="dId" id="dept_update_select"></select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>
        </div>
    </div>
</div>


<!-- 员工添加的模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@imooc.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <!-- 部门提交部门id即可 -->
                            <select class="form-control" name="dId" id="dept_add_select"></select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 搭建显示界面 -->
<div class="container">
    <!-- 标题 -->
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <!-- 按钮 -->
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
         </div>
    </div>
<!-- 显示表格数据 -->
<div class="row">
    <div class="col-md-12">
        <table class="table table-hover" id="emps_table">
            <thead>
            <tr>
                <th>
                    <input type="checkbox" id="check_all"/>
                </th>
                <th>#</th>
                <th>empName</th>
                <th>gender</th>
                <th>email</th>
                <th>deptName</th>
                <th>操作</th>
            </tr>
            </thead>
            <tbody>
            </tbody>
        </table>
    </div>
</div>
    <!-- 显示分页信息 -->
    <div class="row">
        <!-- 分页文字信息 -->
        <div class="col-md-6" id="page_info_area"></div>
        <!-- 分页条信息 -->
        <div class="col-md-6" id="page_nav_area"></div>
    </div>
</div>
<script type="text/javascript">

    // 保存总记录数 当前页
    var totalRecord, currentPage;

    // 1、页面加载完成以后， 直接发送一个ajax请求， 要到分页数据
    $(function () {
        // 去首页
        to_page(1);
    });

    // ajax请求跳转到哪一页的方法
    function to_page(pn) {
        $.ajax({
            url : "${APP_PATH}/emps",
            data : "pn=" + pn,
            type : "get",
            success : function (result) { // result 就是服务器响应给流浪器的数据
                console.log(result);
                // 1、解析并显示员工数据
                build_emps_table(result);
                // 2、解析并显示分页信息
                build_page_info(result);
                // 3、解析显示分页条
                build_page_nav(result);
            }
        });
    };

    // 解析并显示员工数据
    function build_emps_table(result) {
        // 清空table表格
        $("#emps_table tbody").empty();

        // 获取员工数据
        var emps = result.extend.pageInfo.list;
        // 循环遍历
        $.each(emps, function (index, item) {//遍历每一个元素的回调函数 index 索引， item 当前对象
            // alert(item.empName);
            var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var genderTd = $("<td></td>").append(item.gender == 'M' ? "男" : "女");
            var emailTd = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.department.deptName);
            /*
            <button class="btn btn-primary btn-sm">
                                <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                                编辑
                            </button>
            */
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
            // 为编辑按钮一个自定义的属性，来表示当前员工的id
            editBtn.attr("edit_id", item.empId);
            /*
            <button class="btn btn-danger btn-sm">
                                <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                                删除
                            </button>
            */
            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
            // 为删除按钮添加一个自定义的属性，来表示当前删除的员工id
            delBtn.attr("delete_id", item.empId);
            // 编辑和删除按钮所在的单元格
            var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
            // append方法执行完成以后还是返回原来的元素，
            $("<tr></tr>").append(checkBoxTd)
                .append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(emailTd)
                .append(deptNameTd)
                .append(btnTd)
                .appendTo("#emps_table tbody");
        });
    }

    // 解析显示分页信息
    function build_page_info(result) {
        // 清空显示分页信息
        $("#page_info_area").empty();

        var pageInfo = result.extend.pageInfo;
        /*
        当前页,总页,总条记录
         */
        $("#page_info_area").append("当前"+ pageInfo.pageNum
            +"页,总"+ pageInfo.pages
            +"页,总"+ pageInfo.total +"条记录");
        totalRecord = pageInfo.total;
        currentPage = pageInfo.pageNum;
    }

    // 解析显示分页导航条 , 点击分页要能去下一页。。。
    function build_page_nav(result) {
        // page_nav_area
        // 清空分页导航条信息
        $("#page_nav_area").empty();


        var  ul = $("<ul></ul>").addClass("pagination");
        // 构建元素
        // 首页的<li>
        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href", "#"));
        // 前一页
        var prePageLi = $("<li></li>").append($("<a></a>").append($("<span></span>").append("&laquo;")));
        // 判断是否有前一页，如果没有前一页，首页和前一页都不能点击
        if (result.extend.pageInfo.hasPreviousPage == false){
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        }else{
            // 为元素添加点击翻页的事件
            firstPageLi.click(function () { // 首页
                to_page(1);
            });
            prePageLi.click(function () { // 前一页
                to_page(result.extend.pageInfo.prePage);
            })
        }

        // 构建元素
        // 后一页
        var nextPageLi = $("<li></li>").append($("<a></a>").append($("<span></span>").append("&raquo;")));
        // 末页的<li>
        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href", "#"));
        // 判断是否有下一页，如果没有下一页，末页和下一页不能点击
        if (result.extend.pageInfo.hasNextPage == false){
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        }else{
            // 为元素添加点击翻页事件
            nextPageLi.click(function () {// 下一页
                to_page(result.extend.pageInfo.pageNum + 1);
            });
            lastPageLi.click(function () {
                to_page(result.extend.pageInfo.pages);
            });
        }

        // 添加首页和前一页的提示
        ul.append(firstPageLi).append(prePageLi);
        // 遍历要显示的其他页码 并给ul中添加页码提示 1, 2, 3, 4, 5 ...
        $.each(result.extend.pageInfo.navigatepageNums, function (index, item) {// 遍历每一个元素的回调函数
            
            var  numLi = $("<li></li>").append($("<a></a>").append($("<span></span>").append(item)));
            if (result.extend.pageInfo.pageNum == item){
                numLi.addClass("active");
            }
            // 给每个li绑定点击事件, 再来发ajax请求
            numLi.click(function () {
                to_page(item);// 跳转到当前页码
            })
            ul.append(numLi);
        });
        // 条加后一页和末页的提示
        ul.append(nextPageLi).append(lastPageLi);
        // 把ul加入到nav中
        var  navEle = $("<nav></nav>").append(ul);
        // 把导航条添加到div中去
        navEle.appendTo("#page_nav_area")
    }

    // 清空模态框表单样式及内容
    function reset_form(ele){
        // 重置表单内容
        $(ele)[0].reset();
        // 清空表单样式 find() -- 找到所有元素
        $(ele).find("*").removeClass("has-error has-success")
        $(ele).find(".help-block").text("");
    }

    // 点击新增按钮弹出模态框。
    $("#emp_add_modal_btn").click(function () {
        // 清除表单数据 （表单完整重置(表单的数据，表单的样式)） jQuery没有reset方法， 这个方法时dom对象的方法
        reset_form("#empAddModal form");
        // $("#empAddModal form")[0].reset();
        // 发送ajax请求， 查出部门信息， 显示在下拉列表中
        getDepts("#empAddModal select");
        // 弹出模态框
        $("#empAddModal").modal({
            backdrop : "static" // 点击模态框的背景时模态框也不会消失
        });
    });

    // 查出所有的部门信息并显示在下拉列表中
    function getDepts(ele) {
      // 清空之前下拉列表的值
      $(ele).empty();
      $.ajax({
        url:"${APP_PATH}/depts",
        type:"GET",
        success:function (result) {
            console.log(result);
            // 显示部门信息在下拉列表中
            // 用id找， 也可以不用id找
            // $("#modal fade select").append("");
            $.each(result.extend.depts, function () {//index, item 也可以不传参数， 用this代替当前元素
                var optionEle = $("<option value=''></option>").append(this.deptName).attr("value", this.deptId)
                optionEle.appendTo(ele);
            });
        }
      });
    };

    // 校验表单数据
    function validate_add_form(){
        //1、要校验的数据，使用正则表达式
        var empName = $("#empName_add_input").val();
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        if (!regName.test(empName)){
            // alert("用户名可以是2-5为中文或者是6-16位英文和数字的组合")
            // 给input标签的父元素添加 "has-error" 元素
            show_validate_msg("#empName_add_input", "error", "用户名可以是2-5为中文或者是6-16位英文和数字的组合");
            return false;
        }else{
            show_validate_msg("#empName_add_input", "success", "");
        }
        // 判断用户名是否有误
        empName_add_check($("#empName_add_input").value);

        // 2、校验邮箱信息
        var email = $("#email_add_input").val();
        var regEmail =  /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!regEmail.test(email)){
            // alert("邮箱格式不正确");
            // 给input标签的父元素添加 "has-class" 元素
            show_validate_msg("#email_add_input", "error", "邮箱格式不正确");
            return false;
        }else{
            show_validate_msg("#email_add_input", "success", "");
        }
        return true;
    }

    // 显示校验结果的提示信息
    function show_validate_msg(ele, status, msg){
        // 应该清空这个元素之前的样式
        $(ele).parent().removeClass("has-success has-error");
        $(ele).next("span").text("");
        if ("success" == status){
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
        }else if("error" == status){
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }

    // 校验用户名是否可用   给emName绑定change()事件，当用户名输入框的内容发生改变调用
    $("#empName_add_input").change(function () {
        // 发送ajax请求校验用户名是否可用
        var empName = this.value;
        empName_add_check(empName);
    });

    // 验证用户名是否可用的ajax方法
    function empName_add_check(ele){
        // var empName = $(ele).value;
        $.ajax({
            url:"${APP_PATH}/checkuser",
            data:"empName="+ele,
            type:"POST",
            success:function (result) {
                if (result.code == 100){
                    show_validate_msg("#empName_add_input", "success", "用户名可用");
                    $("#emp_save_btn").attr("ajax-va", "success");
                }else{
                    show_validate_msg("#empName_add_input", "error", result.extend.va_msg);
                    $("#emp_save_btn").attr("ajax-va", "error");
                }
            }
        });
    };
    
    // 点击保存，保存员工
    $("#emp_save_btn").click(function () {
        // 1、将模态框中填写的表单数据提交给服务器进行保存
        // 2、先对要提交给服务器的数据进行前端校验校验
        // if (!validate_add_form()){
        //     return false;
        // };


        // 3、判断之前的ajax用户名校验是否成功， 如果成功再进行保存，
        if ($(this).attr("ajax_va") == "error"){
            return false;
        }

        // 4、发送ajax请求保存员工
        // alert($("#empAddModal form").serialize()); serialize() 方法通过序列化表单值创建 URL 编码文本字符串。
        //                                              您可以选择一个或多个表单元素（如输入和/或文本区），或表单元素本身。
        //                                              序列化的值可在生成 AJAX 请求时用于 URL 查询字符串中。
        $.ajax({
           url:"${APP_PATH}/emps",
           type:"POST",
           data:$("#empAddModal form").serialize(),
           success:function (result) {
               console.log(result);

               if (result.code == 100){
                   // 1、关闭模态框.msg);
                   // 员工保存成功
                   $("#empAddModal").modal('hide');
                   // 2、来到最后一页，显示刚才保存的数据
                   // 发送ajax请求显示最后一页数据即可
                   //
                   to_page(totalRecord);
               }else {
                // 显示失败信息
                   console.log(result);
                   //有哪个字段的错误信息就显示哪个字段的
                   if (undefined != result.extend.errorFields.email) {
                       // 显示员工的邮箱错误信息
                       show_validate_msg("#email_add_input", "error", result.extend.errorFields.email);
                   }
                   if (undefined != result.extend.errorFields.empName) {
                       // 显示员工的名字错误信息
                       show_validate_msg("#empName_add_input", "error", result.extend.errorFields.empName);
                   }
               }
           }
        });
    });


    // 编辑按钮的点击事件
    // 这样通过 $(".class属性").click()给编辑按钮绑定事件是绑不成的
    // 1、我们是按钮创建之前就绑定了click，所以绑定不上。
    //      1）、可以在创建按钮的时候绑定事件。 2）绑定点击事件.live() -- 可以给后添加进来的元素绑定点击事件
    // jQuery新版还没有live方法，使用on()进行替代 "click"--指的是要绑定的事件， ".edit_btn"--代表选择器，是document的后代，
    $(document).on("click",".edit_btn",  function () {
        // alert("edit");
        // 1、查出部门信息，并显示部门列表
        getDepts("#empUpdateModal select");
        // 2、查出员工信息显示员工信息
        getEmp($(this).attr("edit_id"));
        // 3、弹出模态框  把员工的id传递给模态框的更新按钮
        $("#emp_update_btn").attr("edit_id", $(this).attr("edit_id"));
        $("#empUpdateModal").modal({
            backdrop : "static" // 点击模态框的背景时模态框也不会消失
        });
    });

    // 查出员工信息显示员工信息
    function getEmp(id) {
        $.ajax({
            url:"${APP_PATH}/emps/" + id,
            type: "GET",
            success:function (result) {
                console.log(result);
                var empData = result.extend.emp;
                $("#empName_update_static").text(empData.empName);
                $("#email_update_input").val(empData.email);
                $("#empUpdateModal input[name=gender]").val([empData.gender]);
                $("#empUpdateModal select").val([empData.dId]);
            }
        });
    }

    // 点击更新，更新员工信息
    $("#emp_update_btn").click(function () {
        // 1、验证邮箱是否合法
        var email = $("#email_update_input").val();
        var regEmail =  /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!regEmail.test(email)){
            // alert("邮箱格式不正确");
            // 给input标签的父元素添加 "has-class" 元素
            show_validate_msg("#email_update_input", "error", "邮箱格式不正确");
            return false;
        }else{
            show_validate_msg("#email_update_input", "success", "");
        }

        // 2、发送ajax请求保存更新的员工数据
        $.ajax({
            url:"${APP_PATH}/emps/" + $(this).attr("edit_id"),
            // type:"POST",
            // data:$("#empUpdateModal form").serialize() + "&_method=PUT"
            type:"PUT",
            data:$("#empUpdateModal form").serialize(),
            success:function (result) {
                // alert(result.msg);
                // 1、关闭对话框
                $("#empUpdateModal").modal("hide");
                // 2、回到本页面
                to_page(currentPage);
            }
        });
    });

    // 单个删除按钮的点击事件
    $(document).on("click", ".delete_btn", function () {
        // 1、弹出是否确认删除对话框
        var empName = $(this).parents("tr").find("td:eq(2)").text();

        var empId = $(this).attr("delete_id");
        // alert($(this).parents("tr").find("td:eq(1)").text());
        if (confirm("确认删除[" + empName + "]吗？")){
            // 确认， 发送ajax请求删除即可
            $.ajax({
                url:"${APP_PATH}/emps/" + empId,
                type:"DELETE",
                success:function (result) {
                    alert(result.msg);
                    // 回到本页
                    to_page(currentPage);
                }
            });
        }
    });

    // 完成全选/ 全不选功能
    $("#check_all").click(function () {
        // attr获取checked是Undifined;
        // 我们这些dom原生的属性，推荐使用prop获取属性， attr获取自定义属性的值
        // prop修改和读取dom原生的属性的值
//        alert($(this).prop("checked"));

        $(".check_item").prop("checked", $(this).prop("checked"));
    });

    // 为每一条记录(.check_item)的选中和不选中绑定点击事件， 后创建的，所以用$(document).on()
    $(document).on("click", ".check_item", function () {
        // 判断当前选择中的元素是否5个
        var flag = $(".check_item:checked").length == $(".check_item").length;
        $("#check_all").prop("checked", flag);
    });

    // 点击全部删除就批量删除
    $("#emp_delete_all_btn").click(function () {
        var empNames = "";
        var del_idstr = "";
       $.each($(".check_item:checked"), function (index, item) {
           // 组装员工名字的字符串
          empNames += $(item).parents("tr").find("td:eq(2)").text() + ",";
          // 组装员工id的字符串
           del_idstr += $(item).parents("tr").find("td:eq(1)").text() + "-";
       });

       // 去除empNames多余的，和del_idstr多余的-
        empNames = empNames.substring(0, empNames.length - 1);
        del_idstr = del_idstr.substring(0, del_idstr.length - 1);
       if (confirm("确认删除[" + empNames + "]吗?")){
           // 发送ajax请求删除
           $.ajax({
               url:"${APP_PATH}/emps/" + del_idstr,
               type:"DELETE",
               success:function (result) {
                   alert(result.msg);
                   // 回到当前页面
                   to_page(currentPage);
               }
           });
       }
    });
</script>
</body>
</html>
