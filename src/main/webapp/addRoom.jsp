<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // DB Connection
    String jdbcURL = "jdbc:mysql://localhost:3306/hostel";
    String dbUser = "root";
    String dbPassword = "1234";

    String message = null;

    // Handle POST request
    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String roomNumber = request.getParameter("room_number");
        String roomType = request.getParameter("room_type");
        String capacity = request.getParameter("capacity");
        String price = request.getParameter("price");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            // Correct query (NO room_id)
            String sql = "INSERT INTO rooms (room_number, room_type, capacity, current_occupancy, price) " +
                         "VALUES (?, ?, ?, 0, ?)";

            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, Integer.parseInt(roomNumber));
            stmt.setString(2, roomType);
            stmt.setInt(3, Integer.parseInt(capacity));
            stmt.setDouble(4, Double.parseDouble(price));

            int result = stmt.executeUpdate();
            message = (result > 0) ? "Room Added Successfully!" : "Failed to Add Room.";

        } catch (SQLIntegrityConstraintViolationException e) {
            message = "Room number already exists!";
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Room</title>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-image: url('add-room1.jpg');
            background-size: cover;
            background-position: center;
        }

        .container {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(12px);
            padding: 25px;
            border-radius: 15px;
            width: 420px;
            text-align: center;
        }

        h1 { color: white; font-weight: 600; }

        .form-group { margin: 15px 0; }

        input, select {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.6);
            background: rgba(255, 255, 255, 0.2);
            color: black;
        }

        input::placeholder {
            color: rgba(255,255,255,0.6);
        }

        .btn, .back {
            width: 100%;
            padding: 12px;
            border-radius: 8px;
            color: white;
            border: none;
            margin-top: 10px;
            cursor: pointer;
        }

        .btn {
            background: linear-gradient(135deg, #28a745, #34d058);
        }

        .back {
            background: linear-gradient(135deg, #d9534f, #ff6b6b);
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Add New Room</h1>

    <% if (message != null) { %>
        <script>
            Swal.fire({
                icon: "info",
                title: "Message",
                text: "<%= message %>"
            });
        </script>
    <% } %>

    <form action="addRoom.jsp" method="POST">

        <div class="form-group">
            <input type="number" name="room_number" placeholder="Enter Room Number" required>
        </div>

        <div class="form-group">
            <select name="room_type" required>
                <option value="">Select Room Type</option>
                <option value="A/C">A/C</option>
                <option value="Non-A/C">Non-A/C</option>
            </select>
        </div>

        <div class="form-group">
            <input type="number" name="capacity" placeholder="Enter Capacity" required>
        </div>

        <div class="form-group">
            <input type="number" name="price" placeholder="Enter Price" step="0.01" required>
        </div>

        <button type="submit" class="btn">Add Room</button>
    </form>

    <button class="back" onclick="window.location.href='Room_Management.jsp'">Go Back</button>
</div>

</body>
</html>
