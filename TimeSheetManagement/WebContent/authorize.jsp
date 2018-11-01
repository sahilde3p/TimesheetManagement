<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" isELIgnored="false"%>
    <%@ page import="ca.anygroup.database.DatabaseHandler" %>
    <%@ page import="java.util.ArrayList,ca.anygroup.beans.User" %>
<!DOCTYPE html>
<html>
<head>
<%if(session.getAttribute("adminAuth")==null){
	response.sendRedirect("/TimeSheetManagement/login.jsp");
	}%>
<meta charset="ISO-8859-1">
<style>
table, th, td {
    border: 1px solid black;
    padding: 5px;
}
table {
    border-spacing: 15px;
}
</style>
<title>Access Privileges</title>
</head>
<body>
<table>
<tr><th>Unauthorised Users</th></tr>
<tr><th>Name</th><th>Company</th><th>Access Permission</th></tr>
<% ArrayList<User> list = new DatabaseHandler().getUnauthorisedUsers();
	for(User u : list){
		out.println("<tr><td>"+u.getName()+"</td><td>"+u.getCompany()+"</td><td><a href='/TimeSheetManagement/addAuth/"+u.getEmail()+"/'>Authorize</a></td></tr>");
	}
%>
<br>
<font color="red"><b>${msg}</b></font>
</table>
</body>
</html>