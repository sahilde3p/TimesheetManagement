<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<%

if(session.getAttribute("adminAuth")==null){
	response.sendRedirect("login.jsp");
	}%>

<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<form action="registerCompany" method="post">
<input type="text" name="companyName">

<input type="submit" value="Submit">

</form>
${msg}
</body>
</html>