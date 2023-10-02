<!DOCTYPE html>
<%@ page import="java.sql.*" %>
<html>
  <head>
    <title>VolunteerBoard</title>
    <link href = "VolunteerBoardLogin.css" rel = "stylesheet">
  </head>
  <body>
    <div class = "header">
      <p class = "logo-text">VolunteerBoard</p>
      
    </div>
    <div class = "login-box">
      <p class = "login-text">Login</p>
      <form action = " " method = "post">
        <input class = "username-box" type = "text" name="username" placeholder="Username">
        <input class = "password-box" type = "password" name="password" placeholder="Password">
        <input class = "login-submit" type = "submit" name="login" value = "Sign In">
      </form>
      <%
        try {
          String username = request.getParameter("username");
          String password = request.getParameter("password"); 
                
          Class.forName("oracle.jdbc.driver.OracleDriver");
          Connection c = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "system", "orcl");
          Statement stmt = c.createStatement();
          ResultSet accounts = stmt.executeQuery("select * from VolunteerBoardLoginInformation");
         
          while (accounts.next()) {
            String usernameToTest = accounts.getString("Username");
            if (usernameToTest.equals(username)) {
              String passwordToTest = accounts.getString("Password");
              if (passwordToTest.equals(password)) {
                response.sendRedirect("http://localhost:8080/volunteer-board/VolunteerBoardDashboard.jsp?value=" + username);
              }
            }
          }
          c.close();
          stmt.close();
          accounts.close();

          } catch (Exception e) {
                
          }
        %>
    </div>
  </body>
</html>