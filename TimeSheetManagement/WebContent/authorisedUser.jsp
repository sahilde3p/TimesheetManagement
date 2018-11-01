<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" isELIgnored="false"%>
    <%@page import="java.time.*" %> 
    <%@page import="ca.anygroup.beans.UpdatedTimesheet" %>
     <%@page import="ca.anygroup.beans.User" %>
    <%@page import="java.time.format.*" %>
<!DOCTYPE html>
<html>
<head>
<style>
table, th, td {
    border: 1px solid black;
    padding: 5px;
}
table {
    border-spacing: 15px;
}
</style>
<meta charset="ISO-8859-1">
<title>Update Timesheet</title>
<%
response.setHeader("Cache-Control", "no-cache,no-store,must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setHeader("Expires", "0");
if(session.getAttribute("authorisedAuth")==null){
	response.sendRedirect("login.jsp");
	}
	%>

</head>
<body>
Welcome ${authorisedAuth.name}
	
		<% LocalDate dateNow = LocalDate.now();
		LocalDate week2D1 = dateNow.minusDays(dateNow.getDayOfWeek().compareTo(DayOfWeek.MONDAY));
		LocalDate week2D2 = week2D1.plusDays(6);
		
		String week2Date1 = week2D1.format(DateTimeFormatter.ofLocalizedDate(FormatStyle.MEDIUM));
		String week2Date2 = week2D2.format(DateTimeFormatter.ofLocalizedDate(FormatStyle.MEDIUM));
		
		
		LocalDate week1D1= week2D1.minusDays(7);
		LocalDate week1D2= week2D1.minusDays(1);
		
		String week1Date1 = week1D1.format(DateTimeFormatter.ofLocalizedDate(FormatStyle.MEDIUM));
		String week1Date2 = week1D2.format(DateTimeFormatter.ofLocalizedDate(FormatStyle.MEDIUM));
		
		
		LocalDate today =LocalDate.now();
		int i = today.getDayOfWeek().compareTo(DayOfWeek.WEDNESDAY);
		
		out.println("<form action=\"getweek\" method=\"post\">");
		if(i>0)
		{
			out.println("<input type='hidden' name='week2.periodFrom' value='"+week2Date1+"'>");
			out.println("<input type='hidden' name='week2.periodTo' value='"+week2Date2+"'>");
			out.println("<select name=\"week\">");
			out.println("<option value=\"week2\">"+ week2Date1+" to " +week2Date2+"</option>");
			out.println("</select>");
		}
		else{
			out.println("<input type='hidden' name='week2.periodFrom' value='"+week2Date1+"'>");
			out.println("<input type='hidden' name='week2.periodTo' value='"+week2Date2+"'>");
			out.println("<input type='hidden' name='week1.periodFrom' value='"+week1Date1+"'>");
			out.println("<input type='hidden' name='week1.periodTo' value='"+week1Date2+"'>");
			out.println("<select name=\"week\">");
			out.println("<option value=\"week1\">"+ week1Date1+" to " +week1Date2+"</option>");
			out.println("<option value=\"week2\">"+ week2Date1+" to " +week2Date2+"</option>");
			out.println("</select>");
			
		}
		out.println("<input type=\"submit\" value=\"Submit\">");
		out.println("</form>");
		UpdatedTimesheet update = (UpdatedTimesheet)request.getAttribute("update");
		if(request.getAttribute("period")!=null && request.getAttribute("period").equals("week1"))
		{
			out.println("<form action='submitTimesheet' method='post'>");
			out.println("<input type='hidden' name='periodFrom' value='"+week1Date1+"'>");
			out.println("<input type='hidden' name='periodTo' value='"+week1Date2+"'>");
			
			out.println("<table>");
			out.println("<tr><th colspan=\"2\">"+ week1Date1+" to " +week1Date2+"</th><th>"+((User)request.getSession().getAttribute("authorisedAuth")).getCompany()+"</th><th>"+((User)request.getSession().getAttribute("authorisedAuth")).getName()+"</th></tr>");
			out.println("<tr><th>Date</th><th>Day</th><th>Hours</th><th>Over-Time</th></tr>");
			
			for(int j =0;j<7;j++)
			{
				int d = week1D1.getDayOfMonth();
				int m = week1D1.getMonth().getValue();
				int y = week1D1.getYear();
				LocalDate week1Date = LocalDate.of(y,m,d);
				int v = week1Date.getDayOfWeek().getValue() - 1;
			out.println("<tr><td>"+week1Date+"</td>"+"<td>"+week1Date.getDayOfWeek()+"<td><input type ='text' name='"+week1Date.getDayOfWeek().name().toLowerCase()+"Hours' value='"+update.day[v][0]+"'></td><td><input type ='text' name='"+week1Date.getDayOfWeek().name().toLowerCase()+"Overtime' value='"+update.day[v][1]+"'></td></tr>");
						
					
				
				
			week1D1 = week1D1.plusDays(1);
			}
			out.println("</table>");
			out.println("<input type=\"submit\" value=\"Update\">");
			out.println("</form>");
		}
		else if(request.getAttribute("period")!=null &&request.getAttribute("period").equals("week2"))
		{
			out.println("<form action='submitTimesheet' method='post'>");
			out.println("<input type='hidden' name='periodFrom' value='"+week2Date1+"'>");
			out.println("<input type='hidden' name='periodTo' value='"+week2Date2+"'>");
			LocalDate date = LocalDate.now();
			LocalDate date1 = date.minusDays(date.getDayOfWeek().compareTo(DayOfWeek.MONDAY));
			out.println("<table>");
			out.println("<tr><th colspan=\"2\">"+ week2Date1+" to " +week2Date2+"</th><th>"+((User)request.getSession().getAttribute("authorisedAuth")).getCompany()+"</th><th>"+((User)request.getSession().getAttribute("authorisedAuth")).getName()+"</th></tr>");
			out.println("<tr><th>Date</th><th>Day</th><th>Hours</th><th>Over-Time</th></tr>");
			for(int j =0;j<=date.getDayOfWeek().compareTo(DayOfWeek.MONDAY);j++)
			{
				int v = date1.getDayOfWeek().getValue() - 1;
				
				if(date1.equals(date)){

					out.println("<tr><td>"+date1+"</td>"+"<td><b>"+date1.getDayOfWeek()+"</b></td><td><input type ='text' name='"+date1.getDayOfWeek().name().toLowerCase()+"Hours'  value='"+update.day[v][0]+"'></td><td><input type ='text' name='"+date1.getDayOfWeek().name().toLowerCase()+"Overtime' value='"+update.day[v][1]+"'></td></tr>");
					
					}
					else{
						
						out.println("<tr><td>"+date1+"</td>"+"<td>"+date1.getDayOfWeek()+"</td><td><input type ='text' name='"+date1.getDayOfWeek().name().toLowerCase()+"Hours' value='"+update.day[v][0]+"'></td><td><input type ='text' name='"+date1.getDayOfWeek().name().toLowerCase()+"Overtime'  value='"+update.day[v][1]+"'></td></tr>");
						
					}
				
				
				date1 = date1.plusDays(1);
			}
			out.println("</table>");
			out.println("<input type=\"submit\" value=\"Update\">");
			out.println("</form>");
		}
		
		
		
		
		
		%>
		
		<br/>	
		<font color='red'><b>${msg}</b></font>
<form action="signout" method="post">
<input type ="hidden" name="logout" value="authorisedAuth"/>
<input type ="submit" value="Signout"/>
</form>
</body>
</html>