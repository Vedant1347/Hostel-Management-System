<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    String roomNumberInput = request.getParameter("room_number");
    boolean roomFound = false;
    boolean updateSuccess = false;
    boolean updateError = false;

    String roomType = "";
    int capacity = 0;
    double price = 0.0;

    // DB Credentials
    String dbURL = "jdbc:mysql://localhost:3306/hostel";
    String dbUser = "root";
    String dbPass = "1234";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(dbURL, dbUser, dbPass);

        //----------------------------------------
        // FETCH ROOM DETAILS (GET Request)
        //----------------------------------------
        if (roomNumberInput != null && request.getParameter("update") == null) {

            String selectQuery = "SELECT room_type, capacity, price FROM rooms WHERE room_number = ?";
            ps = con.prepareStatement(selectQuery);
            ps.setString(1, roomNumberInput);

            rs = ps.executeQuery();

            if (rs.next()) {
                roomType = rs.getString("room_type");
                capacity = rs.getInt("capacity");
                price = rs.getDouble("price");
                roomFound = true;
            }

            rs.close();
            ps.close();
        }

        //----------------------------------------
        // UPDATE ROOM DETAILS (POST Request)
        //----------------------------------------
        if ("true".equals(request.getParameter("update"))) {

            String newRoomType = request.getParameter("room_type");
            int newCapacity = Integer.parseInt(request.getParameter("capacity"));
            double newPrice = Double.parseDouble(request.getParameter("price"));

            String updateQuery =
                "UPDATE rooms SET room_type = ?, capacity = ?, price = ? WHERE room_number = ?";

            ps = con.prepareStatement(updateQuery);
            ps.setString(1, newRoomType);
            ps.setInt(2, newCapacity);
            ps.setDouble(3, newPrice);
            ps.setString(4, roomNumberInput);

            int rows = ps.executeUpdate();
            updateSuccess = (rows > 0);
            updateError = !updateSuccess;

            ps.close();
        }

        con.close();
    } catch (Exception e) {
        updateError = true;
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Room</title>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

<style>
* {
    margin: 0; padding: 0; box-sizing: border-box;
    font-family: Arial, sans-serif;
}
body {
    display: flex; flex-direction: column;
    justify-content: center; align-items: center;
    height: 100vh;
    background: linear-gradient(135deg,#74ebd5,#acb6e5);
}
.form-container {
    width: 380px; padding: 20px;
    background: rgba(255,255,255,0.2);
    backdrop-filter: blur(10px);
    border-radius: 15px;
    margin-bottom: 20px;
    text-align: center;
}
input, select {
    width: 100%; padding: 12px;
    margin: 10px 0; border: none;
    border-radius: 10px;
    background: rgba(255,255,255,0.5);
}
button {
    width: 100%; padding: 12px;
    border: none; font-size: 18px;
    border-radius: 8px; cursor: pointer;
}
.update-btn { background: #28a745; color: white; }
.cancel-btn { background: #dc3545; color: white; margin-top: 10px; }
.btn-back   { background: purple; color: white; margin-top: 10px; }
</style>
</head>

<body>

<!-- Success Message -->
<% if (updateSuccess) { %>
<script>
Swal.fire({
    icon: 'success',
    title: 'Room Updated Successfully!',
    timer: 2000,
    showConfirmButton: false
}).then(() => window.location.href = "editRoom.jsp");
</script>
<% } %>

<!-- Error Message -->
<% if (updateError) { %>
<script>
Swal.fire({
    icon: 'error',
    title: 'Update Failed!',
    text: 'Something went wrong.'
});
</script>
<% } %>

<!-- Room Not Found -->
<% if (roomNumberInput != null && !roomFound && request.getParameter("update") == null) { %>
<script>
Swal.fire({
    icon: 'warning',
    title: 'Room Not Found!',
    text: 'Please check the room number.'
});
</script>
<% } %>


<!-- STEP 1: ENTER ROOM NUMBER -->
<div class="form-container">
    <h2>Enter Room Number</h2>

    <form method="get" action="editRoom.jsp">
        <input type="text" name="room_number" placeholder="Enter Room Number" required>

        <button type="submit" class="update-btn">Fetch Room</button>
    </form>

    <button class="btn-back" onclick="window.location.href='Room_Management.jsp'"><< Back</button>
</div>


<!-- STEP 2: SHOW EDIT FORM ONLY IF ROOM FOUND -->
<% if (roomFound) { %>
<div class="form-container">
    <h2>Edit Room</h2>

    <form method="post" action="editRoom.jsp">

        <input type="hidden" name="update" value="true">
        <input type="hidden" name="room_number" value="<%= roomNumberInput %>">

        <label>Room Type:</label>
        <select name="room_type" required>
            <option value="A/C" <%= roomType.equals("A/C") ? "selected" : "" %>>A/C</option>
            <option value="Non-A/C" <%= roomType.equals("Non-A/C") ? "selected" : "" %>>Non-A/C</option>
        </select>

        <label>Capacity:</label>
        <input type="number" name="capacity" value="<%= capacity %>" min="1" required>

        <label>Price:</label>
        <input type="text" name="price" value="<%= price %>" required>

        <button type="submit" class="update-btn">Save Changes</button>
        <button type="button" class="cancel-btn" onclick="window.location.href='editRoom.jsp'">Cancel</button>
    </form>
</div>
<% } %>

</body>
</html>
