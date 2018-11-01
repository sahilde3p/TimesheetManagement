<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" isELIgnored="false"%>
    <%@page import="ca.anygroup.database.*" %>
	<%@page import="java.util.ArrayList" %>
	<%@page import="ca.anygroup.beans.Company" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Select Company</title>
<%
response.setHeader("Cache-Control", "no-cache,no-store,must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setHeader("Expires", "0");
if(session.getAttribute("underProcess")==null){
	response.sendRedirect("login.jsp");
	}%>
</head>
<body>

<form action="selectCompany" method="post">
<table>
	<tr>
			<td>Company:</td>
			<td>
			<select name="company">
			<% DatabaseHandler db = new DatabaseHandler();
				ArrayList<Company> list = db.returnCompanies();
			for(Company c :list){
				out.print("<option value='"+c.getId()+"'>"+c.getName()+"</option>");
			}
			%>
			</select>
			</td>
	<tr>
			<td> <input type="submit" value="Submit"> </td>
	</tr>
	<tr>
	<font color='red'><b>${msg}</b></font>
		</tr>
</table>
</form>
</body>
</html>