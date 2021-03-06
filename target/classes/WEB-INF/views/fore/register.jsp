<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="sf" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>login</title>
<!-- 引入bootstrap文件 和jquery -->
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery-3.1.0.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath }/static/js/bootstrap/css/bootstrap.min.css">
<script type="text/javascript" src="${pageContext.request.contextPath }/static/js/bootstrap/js/bootstrap.min.js"></script>

<style type="text/css">
.header{
display:line-block;
line-height:135px;
position:relative;
}
.shopping{
font-size:400%;
color:#C91623;
margin-left:30px;
margin-right:30px;
}
.welcome{
font-size:200%;
}
.login{
text-align:right;
position:absolute;
right:20px;
top:50px;
}
.account:{
line-height:150%;
font-size:150%;
margin-right:5px;
}
.headerLine{
clear:both;
height:0px;
border-bottom:5px groove #F1F1F1;
}
.form{
width:30%;
margin-left:auto;
margin-right:auto;
margin-top:10px;
}
#submit{
margin-left:auto !important;
margin-right:auto !important;
}
</style>
<!-- 表单验证js控件 -->
<!-- <script type="text/javascript" src="resource/js/jquery-validation-1.14.0/lib/jquery.js"></script> -->
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery-validation-1.14.0/dist/jquery.validate.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery-validation-1.14.0/dist/localization/messages_zh.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/js/jquery-validation-1.14.0/dist/additional-methods.js"></script></head>

<script type="text/javascript">
//定义一个全局变量记住邮箱是否存在
var flag=false;

//代替sumbmit按钮，验证通过之后才能提交
$.validator.setDefaults({
    submitHandler: function(form) {
    	if(flag)//如果邮箱不存在才提交！
    		form.submit();
    }
});

//注意这个验证插件，设置每个属性的位置不能摆错，括号位置错误等问题会导致效果出不来
 $().ready(function(){
 //定义一个变量记住方法
 var validator=$("#userForm").validate(
{
//这里注意是这么一种格式rules{}，messages{} 中间括号，字符等不能有问题，如果对应不上，可能不会报错，但是前端审核效果出不来 
rules:{
//用户名
name:"required",
//密码
password:{
required:true,
minlength:6,
//pattern_lihao:"^(?![0-9]+$)(?![a-zA-Z]+$)\w+{6,}$"
//pattern:"/\w+/"
},
//确认密码
comfirm_password:{
required:true,
minlength:6,
equalTo:"#password"
},

/* email:{
	required:true,
	email:true
		
	} */
}//rules结束大括号
,

messages:{
name:"用户名必填！",
//密码
password:{
required:"密码必填！",
minlength:"密码最小长度是6！",
//pattern_lihao:"密码应该由6位以上数字和字母组成！"
},
//确认密码
comfirm_password:{
required:"密码必填！",
minlength:"密码最小长度是6！",
equalTo:"两次密码不相等！"
},
//邮箱
email:{
	required:"邮箱必填！",
	email:"邮箱格式不对！"
		
	}


}//messages结束大括号

});//validate
 });
</script>
<!-- 使用ajax判断邮箱是否存在 -->
<script type="text/javascript">
//匹配邮箱格式是否正确
function patternEmail(){
var email=$("#email").val();
	var patt=new RegExp("^[\\d\\w_]+[@][\\d\\w]+[.][\\w.]+$");
	var isEmail=patt.test(email.toString());
	document.getElementById("isexist").innerText="";//清空内容
	if(!isEmail)
	{
	document.getElementById("isexist").innerText="请输入正确的邮箱！";
	return false;
	}
	else
		return true;
	}
	
function detection(){ 
	var email={email:$("#email").val()};
	
	//var email=$("#email").val();
	if(patternEmail()){
$.ajax({
url:"${pageContext.request.contextPath}/user/isexist",
type:"post",
dataType:"text",
data:JSON.stringify(email),
contentType:"'application/json; charset=UTF-8",
success:function(data){
	
	if (data=="0"){
		//邮箱已经注册
		//alert(data);
	document.getElementById("isexist").innerText="邮箱已经注册！";
	flag=false;
		
	}
	else{
		//邮箱可以使用
		document.getElementById("isexist").innerText="邮箱可以使用！";
		flag=true;
	}	
},
error:function(data){
	alert("ajax发生错误！");
}

});
	}
}



</script>
</head>


<body>
<div class="header">
<span class="shopping">shopping</span><span class="welcome">欢迎注册</span>   <a class="login" href="${pageContext.request.contextPath}/user/login"><span class="account">已有账号</span>请登录</a>
</div>
<div class="headerLine"></div>
<div class="form">
<sf:form modelAttribute="user" action="${pageContext.request.contextPath}/user/register"  id="userForm" method="post">
<div class="form-group">
<label for="email">邮箱:</label>
<sf:input path="email"  class="form-control" id="email" onchange="detection()" placeholder="输入邮箱" /><span><a name="isexist" id="isexist"  style="color:red;text-decoration: none"></a></span>
</div>

<div class="form-group">
<label for="name">用户名:</label>
<sf:input path="name"  class="form-control" id="name" placeholder="输入用户名" />
</div>
<div class="form-group">
<label for="password">密码:</label>
<sf:password path="password"  class="form-control" id="password" placeholder="输入密码" />
</div>

<div class="form-group">
<label for="comfirm_password">密码确认：</label>
<input type="password" name="comfirm_password"  class="form-control" id="comfirm_password" placeholder="密码确认" />
</div>
<input type="submit" value="提交" id="submit"  class="btn btn-default">
</sf:form>
</div>
</body>
</html>