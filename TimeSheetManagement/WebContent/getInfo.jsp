<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    	<%@page import="java.util.ArrayList" %>
	<%@page import="ca.anygroup.beans.Company" %>
	<%@page import="ca.anygroup.beans.Timesheet" %>
	<%@page import="ca.anygroup.beans.User" %>
	<%@page import="ca.anygroup.beans.Period" %>
	<%@page import="ca.anygroup.database.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Timesheets</title>
</head>
<body>
<form action="getUser" method="get">

<select name="companyId">

<% DatabaseHandler db = new DatabaseHandler();
ArrayList<Company> list = db.returnCompanies();
for(Company c :list){
out.print("<option value='"+c.getId()+"'>"+c.getName()+"</option>");
}
%>
</select>
<input type="submit" value="Submit">
</form>
<form action="getPeriod" method="get">
<%
if(request.getAttribute("users")!=null){
	
	out.print("<select name=\"userId\">");
	ArrayList<User> user =(ArrayList)request.getAttribute("users");
	for(User u : user){
		out.print("<option value='"+u.getEmail()+"'>"+u.getName()+"</option>");
	}
	out.print("</select>");
	out.println("<input type=\"submit\" value=\"Submit\">");
}
%>
</form>
<form action="getHours" >
<% 
if(request.getAttribute("period")!=null){
	
	out.print("<select name=\"periodId\">");
	ArrayList<Period> period =(ArrayList)request.getAttribute("period");
	
	
	for(Period p : period){
		
		out.print("<option value='"+p.getPeriodId()+"'>"+p.getPeriodFrom() +" to "+p.getPeriodTo()+"</option>");
	}
	out.print("</select>");
	out.println("<input type=\"submit\" value=\"Submit\">");
}
%> 
</form>
<% 
if(request.getAttribute("timesheet")!=null){
	out.println("<table>");
	out.println("<tr>");

	out.println("<th>Day</th><th>Hours</th><th>Overtime</th>");
	out.println("</tr>");
	double hours=0;
	double overtime=0;
	ArrayList<Timesheet> time =(ArrayList)request.getAttribute("timesheet");
	for(Timesheet t : time)
	{
		hours += t.getHours();
		overtime += t.getOverTime();
		out.println("<tr><td>"+t.getDate()+"</td><td>"+t.getHours()+"</td><td>"+t.getOverTime()+"</td></tr>");
	}
	
	out.println("</table>");
	out.println("<br>Total Hours:<b> "+hours+"</b><br>");
	out.println("Total Overtime: <b>"+overtime+"<b>");
}

%>





</body>
</html>