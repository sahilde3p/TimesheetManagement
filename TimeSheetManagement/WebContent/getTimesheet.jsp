<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@page import="java.util.ArrayList" %>
    <%@page import="java.util.Map" %>
	<%@page import="ca.anygroup.beans.*" %>
	<%@page import="ca.anygroup.database.*" %>
	<%@page import="java.text.DecimalFormat" %>
	
<!DOCTYPE html>
<html>
<head>
<style>

 th, td {
    border: 1px solid black;
    padding: 5px;
}
table {
    border-spacing: 0px;
}

</style>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>


<form action="getPeriodByCompany" method="get">



<% 
if(request.getAttribute("timesheet")==null && request.getAttribute("periods")==null)
{
	out.print("<select name=\"companyId\">");
DatabaseHandler db = new DatabaseHandler();
ArrayList<Company> list = db.returnCompanies();
for(Company c :list){
out.print("<option value='"+c.getId()+"'>"+c.getName()+"</option>");
}
out.println("</select><input type=\"submit\" value=\"Submit\">");
}
%>

</form>
<form action="getAllTimesheets" method="get">
<%
if(request.getAttribute("periods")!=null){
	out.print("<input type='hidden' name='companyId' value="+request.getAttribute("companyId")+">");
	out.print("<select name=\"periodId\">");
	ArrayList<Period> period = (ArrayList)request.getAttribute("periods");
	for(Period p : period){
		out.print("<option value='"+p.getPeriodId()+"'>"+p.getPeriodFrom()+" - "+p.getPeriodTo()+"</option>");
	}
	out.print("</select>");
	out.println("<input type=\"submit\" value=\"Submit\">");
}
%>
<table>

<%
DecimalFormat df = new DecimalFormat("#.##");
if(request.getAttribute("timesheet")!=null){
	out.println("<tr><th>Name</th><th>Monday</th><th>Tuesday</th><th>Wednesday</th><th>Thursday</th><th>Friday</th><th>Saturday</th><th>Sunday</th><th>Total Regular Hours</th><th>Total Overtime</th></tr>");
Map<String,UpdatedTimesheetWithNameAndDate> map = (Map)request.getAttribute("timesheet");

double total =0;
double ot =0;
for(Map.Entry<String,UpdatedTimesheetWithNameAndDate> m : map.entrySet()){
	total=0;
	ot=0;
	for(int i=0;i<7;i++){
		total += ((UpdatedTimesheetWithNameAndDate)m.getValue()).day[i][0];
	}
	for(int i=0;i<7;i++){
		ot += ((UpdatedTimesheetWithNameAndDate)m.getValue()).day[i][1];
	}
out.println("<tr><td>"+m.getKey()+"</td><td>"+df.format((((UpdatedTimesheetWithNameAndDate)m.getValue()).day[0][0]+((UpdatedTimesheetWithNameAndDate)m.getValue()).day[0][1]))+"</td><td>"+df.format((((UpdatedTimesheetWithNameAndDate)m.getValue()).day[1][0]+((UpdatedTimesheetWithNameAndDate)m.getValue()).day[1][1]))+"</td><td>"+df.format((((UpdatedTimesheetWithNameAndDate)m.getValue()).day[2][0]+((UpdatedTimesheetWithNameAndDate)m.getValue()).day[2][1]))+"</td><td>"+df.format((((UpdatedTimesheetWithNameAndDate)m.getValue()).day[3][0]+((UpdatedTimesheetWithNameAndDate)m.getValue()).day[3][1]))+"</td><td>"+df.format((((UpdatedTimesheetWithNameAndDate)m.getValue()).day[4][0]+((UpdatedTimesheetWithNameAndDate)m.getValue()).day[4][1]))+"</td><td>"+df.format((((UpdatedTimesheetWithNameAndDate)m.getValue()).day[5][0]+((UpdatedTimesheetWithNameAndDate)m.getValue()).day[5][1]))+"</td><td>"+df.format((((UpdatedTimesheetWithNameAndDate)m.getValue()).day[6][0]+((UpdatedTimesheetWithNameAndDate)m.getValue()).day[6][1]))+"</td><td>"+df.format(total)+"</td><td>"+df.format(ot)+"</td></tr>");
}
}
%>
</table>
</form>

</body>
</html>