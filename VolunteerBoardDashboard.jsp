<!DOCTYPE html>
<%String username = request.getParameter("value");%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.format.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.time.*" %>
<%
  int numberOfRecommendations = 6;
  ArrayList displayedEvents = new ArrayList();
  ArrayList displayedDates = new ArrayList();
  ArrayList displayedOwner = new ArrayList();
  ArrayList displayedMax = new ArrayList();
  ArrayList displayedParticipants = new ArrayList();
  ArrayList displayedImageData = new ArrayList();
  ArrayList displayedDescription = new ArrayList();
  ArrayList displayedRecommendedEvents = new ArrayList();
  ArrayList displayedRecommendedDates = new ArrayList();
  ArrayList displayedRecommendedOwner = new ArrayList();
  ArrayList displayedRecommendedMax = new ArrayList();
  ArrayList displayedRecommendedParticipants = new ArrayList();
  ArrayList displayedRecommendedImageData = new ArrayList();
  ArrayList displayedRecommendedDescription = new ArrayList();
  String signedUpEvents = "";
  PreparedStatement pstmt = null;
  PreparedStatement pstmt2 = null;
  
  try {
    Class.forName("oracle.jdbc.driver.OracleDriver");
    Connection c = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "system", "orcl");

    Statement stmt = c.createStatement();
    Statement stmt2 = c.createStatement();
    Statement stmt3 = c.createStatement();
    
    pstmt = c.prepareStatement("update VolunteerBoardEventInformation set EventParticipants = ? where EventName = ?");
    pstmt2 = c.prepareStatement("update VolunteerBoardLoginInformation set Events = ? where Username = ?");
    ResultSet events = stmt.executeQuery("select * from VolunteerBoardEventInformation");
    ResultSet loginInformation = stmt2.executeQuery("select * from VolunteerBoardLoginInformation");
    ResultSet userEventInformation = stmt3.executeQuery("select * from VolunteerBoardLoginInformation");

    

    int i = 0;
    while (events.next()) {
      if (numberOfRecommendations == i) {
        break;
      }
      displayedEvents.add(events.getString("EventName"));
      
      i++;
    }
    
    while (userEventInformation.next()) {
      if (userEventInformation.getString("Username").equals(username)) {
        if (userEventInformation.getString("Events") != null) {
          String[] s1 = userEventInformation.getString("Events").split("/");
          for (String s2:s1) {
            System.out.println(s2 + "hi");
            displayedRecommendedEvents.add(s2);
          }
        }
        
        
      }
    }
    System.out.println(displayedRecommendedEvents);
    while (loginInformation.next()) {
      if (loginInformation.getString("Events")!=null) {
        signedUpEvents += loginInformation.getString("Events");
      }
      
    }
    
    for (Object eventsName:displayedEvents) {
      ResultSet events1 = stmt.executeQuery("select * from VolunteerBoardEventInformation");
      
      while (events1.next()) {
        
        if (events1.getString("EventName").equals(eventsName.toString())) {
          displayedDates.add(events1.getString("EventDate"));
          displayedOwner.add(events1.getString("EventOwner"));
          displayedMax.add(events1.getString("EventMax"));
          displayedParticipants.add(events1.getString("EventParticipants"));
          displayedImageData.add(events1.getBytes("EventImage"));
          displayedDescription.add(events1.getString("EventInformation"));
          displayedDates.add(events1.getString("EventDate"));
        }
      }
    }
    
    for (Object eventsName:displayedRecommendedEvents) {
      ResultSet events3 = stmt.executeQuery("select * from VolunteerBoardEventInformation");
      
      while (events3.next()) {
        
        if (events3.getString("EventName").equals(eventsName)) {
          displayedRecommendedDates.add(events3.getString("EventDate"));
          displayedRecommendedOwner.add(events3.getString("EventOwner"));
          displayedRecommendedMax.add(events3.getString("EventMax"));
          displayedRecommendedParticipants.add(events3.getString("EventParticipants"));
          displayedRecommendedImageData.add(events3.getBytes("EventImage"));
          displayedRecommendedDescription.add(events3.getString("EventInformation"));
          displayedRecommendedDates.add(events3.getString("EventDate"));
        }
      }
    }
    DateTimeFormatter datetimeformatter = DateTimeFormatter.ofPattern("MM-dd-yyyy HH:mm");
    for (int j =0; j < displayedDates.size(); j++) {
      
      String date = String.valueOf(displayedDates.get(j));
      LocalDateTime ldt = LocalDateTime.parse(date,DateTimeFormatter.ISO_LOCAL_DATE_TIME);
      displayedDates.set(j, ldt.format(datetimeformatter));
    }
    for (int j =0; j < displayedRecommendedDates.size(); j++) {
      
      String date = String.valueOf(displayedRecommendedDates.get(j));
      LocalDateTime ldt = LocalDateTime.parse(date,DateTimeFormatter.ISO_LOCAL_DATE_TIME);
      displayedRecommendedDates.set(j, ldt.format(datetimeformatter));
    }
    
    
    events.close();
    loginInformation.close();
    
    } catch (Exception e) {
      e.printStackTrace();
    }
%>
<html>

  <head>
    <title></title>
    <link href = "VolunteerBoardDashboard.css" rel = "stylesheet">
    
  </head>
  <body>
    <div class = "header">
      <p class = "logo-text">VolunteerBoard</p>
      <a href = "VolunteerBoardDashboard.jsp?value=<%=username%>"class = "dashboard-text">Dashboard</a> 
      <a href = "VolunteerBoardCreateEvent.jsp?value=<%=username%>" class = "create-text">Create</a> 
      <a class = "donate-text">Donate</a> 
    </div>
    <div class = "upcoming-events">
      <span class = "upcoming-events-text">Your upcoming events</span>
      <% if (displayedRecommendedEvents.size()>0) { %>
      <div class = "upcoming-events-flex">
        <div class = "upcoming-event-box">
          <% if (displayedRecommendedEvents.size()>0) { %>
            <div class = "recommendations-event-box-time">
              <div class = "recommendations-event-box-time-text"><%=displayedRecommendedDates.get(0)%></div>
            </div>
            <div class = "recommendations-event-box-image">
              <img src = "data:image/png;base64,<%=new String(java.util.Base64.getEncoder().encode((byte[])displayedRecommendedImageData.get(0))) %>" class = "recommendations-event-box-image2">
            </div>
            <div class = "recommendations-event-box-info">
              <div class = "recommendations-event-box-name">
                <div class = "recommendations-event-box-name-text"><%=displayedRecommendedEvents.get(0)%></div>
              </div>
              <div class = "recommendations-event-box-host">
                <div class = "recommendations-event-box-host-text"><%=displayedRecommendedOwner.get(0)%></div>
              </div>
            </div>
            <div class = "recommendations-event-box-description">
              <div class = "recommendations-event-box-description-text"><%=displayedRecommendedDescription.get(0)%></div>
            </div>
            <div class = "recommendations-event-box-participants">
              <div class = "recommendations-event-box-participants-text"><%=displayedParticipants.get(0)+"/"+displayedMax.get(0) + " participants"%></div>
            </div>
            <div class = "recommendations-event-box-options">

            </div>
          
          <%}%>
        </div>
        <div class = "upcoming-event-box">
          <% if (displayedRecommendedEvents.size()>1) { %>
            <div class = "recommendations-event-box-time">
              <div class = "recommendations-event-box-time-text"><%=displayedRecommendedDates.get(1)%></div>
            </div>
            <div class = "recommendations-event-box-image">
              <img src = "data:image/png;base64,<%=new String(java.util.Base64.getEncoder().encode((byte[])displayedRecommendedImageData.get(1))) %>" class = "recommendations-event-box-image2">
            </div>
            <div class = "recommendations-event-box-info">
              <div class = "recommendations-event-box-name">
                <div class = "recommendations-event-box-name-text"><%=displayedRecommendedEvents.get(1)%></div>
              </div>
              <div class = "recommendations-event-box-host">
                <div class = "recommendations-event-box-host-text"><%=displayedRecommendedOwner.get(1)%></div>
              </div>
            </div>
            <div class = "recommendations-event-box-description">
              <div class = "recommendations-event-box-description-text"><%=displayedRecommendedDescription.get(1)%></div>
            </div>
            <div class = "recommendations-event-box-participants">
              <div class = "recommendations-event-box-participants-text"><%=displayedParticipants.get(1)+"/"+displayedMax.get(1) + " participants"%></div>
            </div>
            <div class = "recommendations-event-box-options">

            </div>
        
          <%}%>
        </div> 
        <div class = "upcoming-event-box">
          <% if (displayedRecommendedEvents.size()>2) { %>
            <div class = "recommendations-event-box-time">
              <div class = "recommendations-event-box-time-text"><%=displayedRecommendedDates.get(2)%></div>
            </div>
            <div class = "recommendations-event-box-image">
              <img src = "data:image/png;base64,<%=new String(java.util.Base64.getEncoder().encode((byte[])displayedRecommendedImageData.get(2))) %>" class = "recommendations-event-box-image2">
            </div>
            <div class = "recommendations-event-box-info">
              <div class = "recommendations-event-box-name">
                <div class = "recommendations-event-box-name-text"><%=displayedRecommendedEvents.get(2)%></div>
              </div>
              <div class = "recommendations-event-box-host">
                <div class = "recommendations-event-box-host-text"><%=displayedRecommendedOwner.get(2)%></div>
              </div>
            </div>
            <div class = "recommendations-event-box-description">
              <div class = "recommendations-event-box-description-text"><%=displayedRecommendedDescription.get(2)%></div>
            </div>
            <div class = "recommendations-event-box-participants">
              <div class = "recommendations-event-box-participants-text"><%=displayedParticipants.get(2)+"/"+displayedMax.get(2) + " participants"%></div>
            </div>
            <div class = "recommendations-event-box-options">

            </div>
          
          <%}%>
        </div>  
      </div>
      <%}%>
    </div>
    <div class = "recommendations-section">
      <span class = "recommendations-text">Recommendations for you</span>
      <div class = "recommendations-events-flex">
        <div class = "recommendations-event-box">
          <div class = "recommendations-event-box-time">
            <div class = "recommendations-event-box-time-text"><%=displayedDates.get(0)%></div>
          </div>
          <div class = "recommendations-event-box-image">
            <img src = "data:image/png;base64,<%=new String(java.util.Base64.getEncoder().encode((byte[])displayedImageData.get(0))) %>" class = "recommendations-event-box-image2">
          </div>
          <div class = "recommendations-event-box-info">
            <div class = "recommendations-event-box-name">
              <div class = "recommendations-event-box-name-text"><%=displayedEvents.get(0)%></div>
            </div>
            <div class = "recommendations-event-box-host">
              <div class = "recommendations-event-box-host-text"><%=displayedOwner.get(0)%></div>
            </div>
          </div>
          <div class = "recommendations-event-box-description">
            <div class = "recommendations-event-box-description-text"><%=displayedDescription.get(0)%></div>
          </div>
          <div class = "recommendations-event-box-participants">
            <div class = "recommendations-event-box-participants-text"><%=displayedParticipants.get(0)+"/"+displayedMax.get(0) + " participants"%></div>
          </div>
          <div class = "recommendations-event-box-options">
            <form action = "http://localhost:8080/volunteer-board/VolunteerBoardDashboard.jsp?value=jotishk"  method = "post" >
              <input type="hidden" name="formIdentifier" value="1">
              <input type = "submit" value = "Join" name = "Join" class = "recommendations-event-box-join-button">
             
            </form>
          </div>
        </div>
      <div class = "recommendations-event-box">
        <div class = "recommendations-event-box-time">
          <div class = "recommendations-event-box-time-text"><%=displayedDates.get(1)%></div>
        </div>
        <div class = "recommendations-event-box-image">
          <img src = "data:image/jpeg;base64,<%=new String(java.util.Base64.getEncoder().encode((byte[])displayedImageData.get(1))) %>" class = "recommendations-event-box-image2">
        </div>
        <div class = "recommendations-event-box-info">
          <div class = "recommendations-event-box-name">
            <div class = "recommendations-event-box-name-text"><%=displayedEvents.get(1)%></div>
          </div>
          <div class = "recommendations-event-box-host">
            <div class = "recommendations-event-box-host-text"><%=displayedOwner.get(1)%></div>
          </div>
        </div>
        <div class = "recommendations-event-box-description">
          <div class = "recommendations-event-box-description-text"><%=displayedDescription.get(1)%></div>
        </div>
        <div class = "recommendations-event-box-participants">
          <div class = "recommendations-event-box-participants-text"><%=displayedParticipants.get(1)+"/"+displayedMax.get(1) + " participants"%></div>
        </div>
        <div class = "recommendations-event-box-options">
           <form action = "http://localhost:8080/volunteer-board/VolunteerBoardDashboard.jsp?value=jotishk"  method = "post" >
            <input type="hidden" name="formIdentifier" value="2">
            <input type = "submit" value = "Join" name = "Join2" class = "recommendations-event-box-join-button">
              
          </form>
        </div>
      </div>
      <div class = "recommendations-event-box">
        <div class = "recommendations-event-box-time">
          <div class = "recommendations-event-box-time-text"><%=displayedDates.get(2)%></div>
        </div>
        <div class = "recommendations-event-box-image">
          <img src = "data:image/jpeg;base64,<%=new String(java.util.Base64.getEncoder().encode((byte[])displayedImageData.get(2))) %>" class = "recommendations-event-box-image2">
        </div>
        <div class = "recommendations-event-box-info">
          <div class = "recommendations-event-box-name">
            <div class = "recommendations-event-box-name-text"><%=displayedEvents.get(2)%></div>
          </div>
          <div class = "recommendations-event-box-host">
            <div class = "recommendations-event-box-host-text"><%=displayedOwner.get(2)%></div>
          </div>
        </div>
        <div class = "recommendations-event-box-description">
          <div class = "recommendations-event-box-description-text"><%=displayedDescription.get(2)%></div>
        </div>
        <div class = "recommendations-event-box-participants">
          <div class = "recommendations-event-box-participants-text"><%=displayedParticipants.get(2)+"/"+displayedMax.get(2)  + " participants"%></div>
        </div>
        <div class = "recommendations-event-box-options">
          <form action = "http://localhost:8080/volunteer-board/VolunteerBoardDashboard.jsp?value=jotishk"  method = "post" >
            <input type="hidden" name="formIdentifier" value="3">
            <input type = "submit" value = "Join" name = "Join3" class = "recommendations-event-box-join-button">
          </form>
        </div>
      </div>
        
      </div>
      <div class = "recommendations-events-flex2">
        <div class = "recommendations-event-box">
          <div class = "recommendations-event-box-time">
            <div class = "recommendations-event-box-time-text"><%=displayedDates.get(3)%></div>
          </div>
          <div class = "recommendations-event-box-image">
            <img src = "data:image/png;base64,<%=new String(java.util.Base64.getEncoder().encode((byte[])displayedImageData.get(3))) %>" class = "recommendations-event-box-image2">
          </div>
          <div class = "recommendations-event-box-info">
            <div class = "recommendations-event-box-name">
              <div class = "recommendations-event-box-name-text"><%=displayedEvents.get(3)%></div>
            </div>
            <div class = "recommendations-event-box-host">
              <div class = "recommendations-event-box-host-text"><%=displayedOwner.get(3)%></div>
            </div>
          </div>
          <div class = "recommendations-event-box-description">
            <div class = "recommendations-event-box-description-text"><%=displayedDescription.get(3)%></div>
          </div>
          <div class = "recommendations-event-box-participants">
            <div class = "recommendations-event-box-participants-text"><%=displayedParticipants.get(3)+"/"+displayedMax.get(3) + " participants"%></div>
          </div>
          <div class = "recommendations-event-box-options">
            <form action = "http://localhost:8080/volunteer-board/VolunteerBoardDashboard.jsp?value=jotishk"  method = "post" >
              <input type="hidden" name="formIdentifier" value="4">
              <input type = "submit" value = "Join" name = "Join4" class = "recommendations-event-box-join-button">
             
            </form>
          </div>
        </div>
      <div class = "recommendations-event-box">
        <div class = "recommendations-event-box-time">
          <div class = "recommendations-event-box-time-text"><%=displayedDates.get(4)%></div>
        </div>
        <div class = "recommendations-event-box-image">
          <img src = "data:image/jpeg;base64,<%=new String(java.util.Base64.getEncoder().encode((byte[])displayedImageData.get(4))) %>" class = "recommendations-event-box-image2">
        </div>
        <div class = "recommendations-event-box-info">
          <div class = "recommendations-event-box-name">
            <div class = "recommendations-event-box-name-text"><%=displayedEvents.get(4)%></div>
          </div>
          <div class = "recommendations-event-box-host">
            <div class = "recommendations-event-box-host-text"><%=displayedOwner.get(4)%></div>
          </div>
        </div>
        <div class = "recommendations-event-box-description">
          <div class = "recommendations-event-box-description-text"><%=displayedDescription.get(4)%></div>
        </div>
        <div class = "recommendations-event-box-participants">
          <div class = "recommendations-event-box-participants-text"><%=displayedParticipants.get(4)+"/"+displayedMax.get(4) + " participants"%></div>
        </div>
        <div class = "recommendations-event-box-options">
           <form action = "http://localhost:8080/volunteer-board/VolunteerBoardDashboard.jsp?value=jotishk"  method = "post" >
            <input type="hidden" name="formIdentifier" value="5">
            <input type = "submit" value = "Join" name = "Join5" class = "recommendations-event-box-join-button">
              
          </form>
        </div>
      </div>
      <div class = "recommendations-event-box">
        <div class = "recommendations-event-box-time">
          <div class = "recommendations-event-box-time-text"><%=displayedDates.get(5)%></div>
        </div>
        <div class = "recommendations-event-box-image">
          <img src = "data:image/jpeg;base64,<%=new String(java.util.Base64.getEncoder().encode((byte[])displayedImageData.get(5))) %>" class = "recommendations-event-box-image2">
        </div>
        <div class = "recommendations-event-box-info">
          <div class = "recommendations-event-box-name">
            <div class = "recommendations-event-box-name-text"><%=displayedEvents.get(5)%></div>
          </div>
          <div class = "recommendations-event-box-host">
            <div class = "recommendations-event-box-host-text"><%=displayedOwner.get(5)%></div>
          </div>
        </div>
        <div class = "recommendations-event-box-description">
          <div class = "recommendations-event-box-description-text"><%=displayedDescription.get(5)%></div>
        </div>
        <div class = "recommendations-event-box-participants">
          <div class = "recommendations-event-box-participants-text"><%=displayedParticipants.get(5)+"/"+displayedMax.get(5)  + " participants"%></div>
        </div>
        <div class = "recommendations-event-box-options">
          <form action = "http://localhost:8080/volunteer-board/VolunteerBoardDashboard.jsp?value=jotishk"  method = "post" >
            <input type="hidden" name="formIdentifier" value="6">
            <input type = "submit" value = "Join" name = "Join6" class = "recommendations-event-box-join-button">
          </form>
        </div>
      </div>   
      </div>
        <%
          try {
            String formIdentifier = request.getParameter("formIdentifier");
              
            if (formIdentifier != null) {
              if (formIdentifier.equals("1")) {
                pstmt.setString(1, String.valueOf(Integer.parseInt(displayedParticipants.get(0).toString())+1));
                pstmt.setString(2,displayedEvents.get(0).toString());
                if (signedUpEvents == null ) {
                  pstmt2.setString(1,displayedEvents.get(0).toString());
                } else {
                  pstmt2.setString(1,signedUpEvents + displayedEvents.get(0).toString() + "/");
                }
                pstmt2.setString(2,username);
                pstmt2.execute();
                pstmt.execute();
              }
              if (formIdentifier.equals("2")) {
                pstmt.setString(1, String.valueOf(Integer.parseInt(displayedParticipants.get(1).toString())+1));
                pstmt.setString(2,displayedEvents.get(1).toString());
                if (signedUpEvents == null ) {
                  pstmt2.setString(1,displayedEvents.get(1).toString());
                } else {
                  pstmt2.setString(1,signedUpEvents + displayedEvents.get(1).toString() + "/");
                }
                pstmt2.setString(2,username);
                pstmt2.execute();
                pstmt.execute();
              }
              if (formIdentifier.equals("3")) {
                pstmt.setString(1, String.valueOf(Integer.parseInt(displayedParticipants.get(2).toString())+1));
                pstmt.setString(2,displayedEvents.get(2).toString());
                if (signedUpEvents == null) {
                  pstmt2.setString(1,displayedEvents.get(2).toString());
                } else {
                  pstmt2.setString(1,signedUpEvents + displayedEvents.get(2).toString() + "/");
                }
                
                pstmt2.setString(2,username);
                pstmt2.execute();
                pstmt.execute();
              }
              if (formIdentifier.equals("4")) {
                pstmt.setString(1, String.valueOf(Integer.parseInt(displayedParticipants.get(3).toString())+1));
                pstmt.setString(2,displayedEvents.get(3).toString());
                if (signedUpEvents == null ) {
                  pstmt2.setString(1,displayedEvents.get(3).toString());
                } else {
                  pstmt2.setString(1,signedUpEvents + displayedEvents.get(3).toString() + "/");
                }
                pstmt2.setString(2,username);
                pstmt2.execute();
                pstmt.execute();
              }
              if (formIdentifier.equals("5")) {
                pstmt.setString(1, String.valueOf(Integer.parseInt(displayedParticipants.get(4).toString())+1));
                pstmt.setString(2,displayedEvents.get(4).toString());
                if (signedUpEvents == null ) {
                  pstmt2.setString(1,displayedEvents.get(4).toString());
                } else {
                  pstmt2.setString(1,signedUpEvents + displayedEvents.get(4).toString() + "/");
                }
                pstmt2.setString(2,username);
                pstmt2.execute();
                pstmt.execute();
              }
              if (formIdentifier.equals("6")) {
                pstmt.setString(1, String.valueOf(Integer.parseInt(displayedParticipants.get(5).toString())+1));
                pstmt.setString(2,displayedEvents.get(5).toString());
                if (signedUpEvents == null ) {
                  pstmt2.setString(1,displayedEvents.get(5).toString());
                } else {
                  pstmt2.setString(1,signedUpEvents + displayedEvents.get(5).toString() + "/");
                }
                pstmt2.setString(2,username);
                pstmt2.execute();
                pstmt.execute();
              }
            }
          } catch(Exception e) {
            e.printStackTrace();
          }
        %>
    </div>
    
  
    
  </body>
</html>