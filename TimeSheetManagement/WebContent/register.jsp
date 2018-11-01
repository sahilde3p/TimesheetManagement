<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
	
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Register</title>

</head>
<body>
	<form action='register' method='post'>
		<table>
			<tr>
				<td>Name:</td>
				<td> <input type="text" name="name"> </td>
			</tr>
			<tr>
				<td>Email:</td>
				<td> <input type="text" name="email"> </td>
			</tr>
			<tr>
				<td>Password:</td>
				<td> <input type="password" name="password"> </td>
			</tr>
			<tr>
				<td>Confirm Password:</td>
				<td> <input type="password" name="cpassword"> </td>
			</tr>
			
			<tr>
				<td> <input type="submit" value="submit"> </td>
			</tr>
		</table>



	</form>
<font color="red"><b>${msg}</b></font>
</body>
</html>