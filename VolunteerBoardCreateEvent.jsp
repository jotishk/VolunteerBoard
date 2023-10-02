<!DOCTYPE html>
<%String username = request.getParameter("value");%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<html>
  <head>
    <title>VolunteerBoard</title>
    <link href = "VolunteerBoardDashboard.css" rel = "stylesheet">
    <link href = "VolunteerBoardCreate.css" rel = "stylesheet">
  </head>
  <body style = "padding-bottom: 0;">
    <div class = "header">
      <p class = "logo-text">VolunteerBoard</p>
      <a href = "VolunteerBoardDashboard.jsp?value=<%=username%>" class = "dashboard-text">Dashboard</a> 
      <a href = "VolunteerBoardCreateEvent.jsp?value=<%=username%>" class = "create-text">Create</a> 
      <a class = "donate-text">Donate</a> 
    </div>
    <div class = "event-creation">
      <span class = "create-event-text">Create Event</span>
      <form enctype="multipart/form-data" action = "VolunteerBoardCreateEvent.jsp?value=<%=username%>" method = "post">
        <div class = "main-form-div">
          <div class = "form-div">
            <span style = "margin-top: 40px;"class = "create-event-form-text">Event Name:</span>
            <input class = "name-input" type = "text" name = "eventname" placeholder="Name" maxlength="50">
            <span style = "margin-top: 40px;"class = "create-event-form-text">Insert Image:</span>
            <input style = "margin-top: 20px;" class = "image-input" type ="file" name = "eventimage" >
            <span style = "margin-top: 40px;"class = "create-event-form-text">Add date</span>
            <input style = "margin-top: 20px;" type ="datetime-local" name = "eventdate">
            <span style = "margin-top: 40px;"class = "create-event-form-text">Max # of volunteers</span>
            <input style = "margin-top: 20px;" class = "participant-input" type ="text" name = "eventparticipants" maxlength="4">
            <br>
            <input style = "margin-top: 40px;" class = "create-button" value = "Create Event" type ="submit" name = "createbutton">
          </div>
          <div>
            <span style = "margin-left: 100px; margin-top: 40px;" class = "create-event-form-text">Event Description:</span>
            <textarea style = "margin-left: 100px;" class = "description-input" name = "eventdescription"></textarea>
          </div>
        </div>
      </form>
      <%
        try {
          String eventName = request.getParameter("eventname");
          Part eventImage = request.getPart("eventimage");
          InputStream fin = eventImage.getInputStream();
          String eventDate = request.getParameter("eventdate");
          String eventParticipants = request.getParameter("eventparticipants");
          String eventInformation = request.getParameter("eventdescription");
          String eventOwner = request.getParameter("value");

          Class.forName("oracle.jdbc.driver.OracleDriver");
          Connection c = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "system", "orcl");
          PreparedStatement pstmt = c.prepareStatement("insert into VolunteerBoardEventInformation(EventName, EventDate, EventMax,EventInformation,EventOwner,EventParticipants, EventImage) values (?,?,?,?,?,?,?)");
          pstmt.setString(1,eventName);
          
          pstmt.setString(2,eventDate);
          pstmt.setString(3,eventParticipants);
          pstmt.setString(4,eventInformation);
          pstmt.setString(5,eventOwner);
          pstmt.setString(6, "0");
          pstmt.setBlob(7,fin);
          pstmt.executeUpdate();
          c.commit();
          fin.close();
          c.close();
          
        } catch(Exception e) {
          System.out.println(e);
        }
      %>
    </div>
    
  </body>
</html>