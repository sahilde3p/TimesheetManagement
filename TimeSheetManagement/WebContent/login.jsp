<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" isELIgnored="false"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Login</title>
<%
response.setHeader("Cache-Control", "no-cache,no-store,must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setHeader("Expires", "0");
if(session.getAttribute("authorisedAuth")!=null)
	{
	response.sendRedirect("authorisedUser.jsp");
	}
else if(session.getAttribute("unauthorisedAuth")!=null)
{
	response.sendRedirect("unauthorisedUser.jsp");
}
else if(session.getAttribute("adminAuth")!=null){
	response.sendRedirect("adminUser.jsp");
}
	%>
</head>
<body>
<form action='login' method='post'>
<table>
<tr>
<td>Email/User:</td><td><input type="text" name="username"></td>
</tr>
<tr>
<td>Password:</td><td><input type="password" name="password"></td>
</tr>
<tr>
<td><input type="submit" name="login"></td><td><font color="red"><b>${msg}</b></font></td>
</tr>
</table>
</form>
</body>
</html>