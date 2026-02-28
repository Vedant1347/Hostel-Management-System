<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, org.json.*" %>

<%
response.setContentType("application/json; charset=UTF-8");

String roomType = request.getParameter("room_type") != null ? request.getParameter("room_type") : "";
JSONArray arr = new JSONArray();

if(roomType != null && !roomType.trim().equals("")){
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/hostel","root","1234");

        // Ensure only rooms that are not full
        String sql = "SELECT room_number FROM rooms WHERE room_type=? AND current_occupancy < capacity ORDER BY room_number";
        ps = con.prepareStatement(sql);
        ps.setString(1, roomType);
        rs = ps.executeQuery();

        while(rs.next()){
            JSONObject obj = new JSONObject();
            obj.put("room_number", rs.getString("room_number")); // use getString to avoid type issues
            arr.put(obj);
        }

    } catch(Exception e){
        // Optional: log the error
        System.out.println("Error in getRooms.jsp: "+e.getMessage());
    } finally {
        try{if(rs!=null) rs.close();}catch(Exception e){}
        try{if(ps!=null) ps.close();}catch(Exception e){}
        try{if(con!=null) con.close();}catch(Exception e){}
    }
}

out.print(arr.toString());
%>
