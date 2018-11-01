package ca.anygroup.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.ZoneId;
import java.util.ArrayList;

import org.springframework.web.bind.annotation.RequestParam;

import ca.anygroup.beans.Company;
import ca.anygroup.beans.Period;
import ca.anygroup.beans.Timesheet;
import ca.anygroup.beans.UpdatedTimesheet;
import ca.anygroup.beans.User;
import ca.anygroup.controller.TimesheetHandler;


public class DatabaseHandler {
	
	public boolean isAdmin = false;
	public boolean isValid = false;
	public String user;
	public String company;
	Connection con = null;
	PreparedStatement pst = null;
	
	public void connect() {
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		try {
			con = DriverManager.getConnection("jdbc:mysql://localhost:3306/timesheet", "root", "12345678");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	public void disconnect() {
		try {
			pst.close();
			con.close();
			
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		
	}
	
	public boolean register(String name,String user,String password) {
		connect();
		try {
			pst = con.prepareStatement("insert into auth values (?,?,0,?,?,0)");
			pst.setString(1, user);
			pst.setString(2, password);
			pst.setInt(3, 1);//CompanyId
			pst.setString(4, name);
			int i = pst.executeUpdate();
			
			return i>0?true:false;
			
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		finally {
			disconnect();
		}
		return false;
	}
	
	
	public boolean insertCompany(String companyId,String email)
	{
		connect();
		try {
			pst = con.prepareStatement("update auth set companyid=? where email=?");
			pst.setInt(1, Integer.parseInt(companyId));
			pst.setString(2, email);
			int i = pst.executeUpdate();
			return i>0;
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		finally {			disconnect();
		}
		return false;
	}
	
	public boolean checkCompany(String email)
	{
		connect();
		try {
			pst = con.prepareStatement("select companyId from auth where email=?");
			pst.setString(1, email);
			ResultSet rs = pst.executeQuery();
			rs.next();
			if(rs.getInt(1)==1)
			{
				return true;
			}
			else {
				return false;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			
		}
		finally {			disconnect();
		}
		return false;
	}
	
	
	public boolean login(String username,String password) {
		
		connect();
		try {
			pst = con.prepareStatement("select * from auth where email = ? and binary password = ?");
			pst.setString(1, username);
			pst.setString(2, password);
		ResultSet rs =	pst.executeQuery();
		if(rs.next())
		{
			
			isAdmin = rs.getInt(6)==1?true:false;
			isValid = rs.getInt(3)==1?true:false;
			
			if(isValid==true) {
				pst = con.prepareStatement("select auth.name,company.name from auth inner join company on auth.companyid = company.id where email = ? ");
				pst.setString(1, username);
				rs = pst.executeQuery();
				rs.next();
				user = rs.getString(1);
				company = rs.getString(2);
				
			}
			return true;
		}
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		finally {			disconnect();
		}
		return false;
	}
	public ArrayList<Company> returnCompanies()
	{
		connect();
		ArrayList<Company> list = new ArrayList<>();
		try {
			pst = con.prepareStatement("select * from company where id<>1");
			ResultSet rs =pst.executeQuery();
			while(rs.next())
			{
				list.add(new Company(rs.getInt(1),rs.getString(2)));
			}
			return list;
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		finally {
			disconnect();
		}
		
		return list;
	}
	
	public boolean checkExisting(String email) {
		connect();
	try {
		pst = con.prepareStatement("select * from auth where email=?");
		pst.setString(1, email);
		ResultSet rs = pst.executeQuery();
		if(rs.next()) {
			
			return false;
		}
		else {
			return true;
		}
	} catch (SQLException e) {
	
		e.printStackTrace();
		System.exit(0);
	}
	finally {
		disconnect();
	}
	
	return true;
	}
	
	public ArrayList<User> getUnauthorisedUsers(){
		connect();
		ArrayList<User> list = new ArrayList<>();
		try {
			pst = con.prepareStatement("select auth.email,auth.name,company.name from auth inner join company on auth.companyid=company.id where isvalid=0");
			ResultSet rs = pst.executeQuery();
			while(rs.next())
			{
				list.add(new User(rs.getString(1),rs.getString(2),rs.getString(3)));
			}
			
			return list;
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		finally {
			disconnect();
		}
		
		return list;
	}
	public boolean addCompany(String companyName)
	{
		connect();
		try {
			pst = con.prepareStatement("insert into company (name) values (?);");
			pst.setString(1, companyName);
			int i  = pst.executeUpdate();
			return i>0?true:false;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		finally {
			disconnect();
		}
		
		return false;
	}
		
	public boolean authorizeUser(String email)
	{
		
			connect();
			try {
				System.out.println(email);
				pst = con.prepareStatement("update auth set isvalid=1 where email=?");
				
				pst.setString(1, email);
				
				int i = pst.executeUpdate();
				if(i>0) {
					return true;
				}
				else {
					return false;
				}
			} catch (SQLException e) {
				
				e.printStackTrace();
			}
			finally{
				disconnect();
			}
			return false;
		}
	
	public int getPeriod(Period period)
	{
		connect();
		try {
			pst = con.prepareStatement("select id from period where from_date = ? and to_date = ?");
			pst.setObject(1, period.getPeriodFrom());
			pst.setObject(2, period.getPeriodTo());
			ResultSet rs = pst.executeQuery();
			if(rs.next()) {
				return rs.getInt(1);
			}
			else {
			PreparedStatement pst1 = con.prepareStatement("insert into period (from_date,to_date) values(?,?)");
				pst1.setObject(1, period.getPeriodFrom());
				pst1.setObject(2, period.getPeriodTo());
				int i = pst1.executeUpdate();
				if(i>0) {
					
					rs = pst.executeQuery();
					rs.next();
					return rs.getInt(1);
					
				}
				pst1.close();
			}
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		finally {
			
			disconnect();
		}
		
		return 0;
		
	}
	
	public boolean updateTimesheet(Timesheet timesheet, String email)
	{
		int periodId = getPeriod(timesheet.getPeriod());
		
		
		connect();
		
		try {
			pst = con.prepareStatement("select * from timesheet where day = ? and email=?");
			pst.setObject(1, timesheet.getDate());
			pst.setString(2, email);
			ResultSet rs = pst.executeQuery();
			if(rs.next()) {
				
				pst = con.prepareStatement("update timesheet set hours=? , overtime=? where email=? and day = ?");
				pst.setDouble(1, timesheet.getHours());
				pst.setDouble(2, timesheet.getOverTime());
				pst.setString(3, email);
				pst.setObject(4, timesheet.getDate());
				int i =pst.executeUpdate();
				if(i>0) {
					
					return true;
				}
				else {
					return false;
				}
			}
			else {
			pst = con.prepareStatement("insert into timesheet (email,periodid,day,hours,overtime) values (?,?,?,?,?)");
			pst.setString(1, email);
			pst.setInt(2, periodId);
			pst.setObject(3,timesheet.getDate());
			pst.setDouble(4, timesheet.getHours());
			pst.setDouble(5, timesheet.getOverTime());
			int i = pst.executeUpdate();
			return i>0?true:false;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
			}
		finally {
			
			disconnect();
		}
		
		
	}
	public ArrayList<Period> getPeriod(String email)
	{
		connect();
		ArrayList<Period> list = new ArrayList<>();
		try {
			pst = con.prepareStatement("select distinct from_date, to_date, period.id from period inner join timesheet on period.id = timesheet.periodid where email = ?");
			pst.setString(1, email);
			ResultSet rs = pst.executeQuery();
			while(rs.next())
			{
				list.add(new Period(rs.getDate(1).toLocalDate(),rs.getDate(2).toLocalDate(),rs.getInt(3)));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		finally {
			
			disconnect();
		}
		return list;
	}
	public ArrayList<User> getUsers(int companyId){
		connect();
		ArrayList<User> list = new ArrayList<>();
		try {
			pst = con.prepareStatement("select auth.email,auth.name,company.name from auth inner join company on auth.companyid = company.id where auth.companyid=?");
			pst.setInt(1, companyId);
			ResultSet rs = pst.executeQuery();
			while(rs.next()) {
				list.add(new User(rs.getString(1),rs.getString(2),rs.getString(3)));
			}
			return list;
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
finally {
			
			disconnect();
		}
		return null;
	}
	
	public UpdatedTimesheet getHours(String email, Period period)
	{
		int id = getPeriod(period);
		connect();
		ArrayList<Timesheet> list = new ArrayList<>();
		
		try {
			pst = con.prepareStatement("select * from timesheet where email=? and periodid=?");
			pst.setString(1, email);
			pst.setInt(2, id);
			ResultSet rs = pst.executeQuery();
			while(rs.next()) {
				Timesheet timesheet = new Timesheet();
				timesheet.setPeriod(period);
				timesheet.setHours(rs.getDouble(5));
				timesheet.setOverTime(rs.getDouble(6));
				timesheet.setDate(rs.getDate(4).toLocalDate());
				list.add(timesheet);
			}
			return new TimesheetHandler().updatedTimesheetGenerator(list);
		} catch (SQLException e) {
		
			e.printStackTrace();
		}
		finally {
			
			disconnect();
		}
		return new UpdatedTimesheet();
	}
	
	public ArrayList<Timesheet> returnHours(String email,int periodId)
	{
		connect();
		ArrayList<Timesheet> list = new ArrayList<>();
		try {
			pst =  con.prepareStatement("select period.from_date,period.to_date,day,hours,overtime from timesheet inner join period on timesheet.periodid = period.id where email =? and periodid=?");
			pst.setString(1, email);
			pst.setInt(2, periodId);
			
			ResultSet rs = pst.executeQuery();
			while(rs.next())
			{
				list.add(new Timesheet(rs.getDate(3).toLocalDate(), rs.getDouble(4), rs.getDouble(5), new Period(rs.getDate(1).toLocalDate(), rs.getDate(2).toLocalDate(),periodId)));
			}
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		finally {
			
			disconnect();
		}
		return list;
	}
	
	
	
	
}
