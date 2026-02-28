<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Rooms</title>
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
            background: linear-gradient(135deg, #74ebd5, #9face6);
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            height: 100vh;
            padding: 20px;
        }
        h1 {
            color: white;
            font-weight: 600;
            font-size: 44px;
            margin-bottom: 20px;
            text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
        }
        .table-container {
            width: 90%;
            max-width: 1000px;
            overflow-x: auto;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }
        table {
            width: 100%;
            border-collapse: collapse;
            text-align: center;
        }
        th, td {
            padding: 12px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.3);
        }
        th {
            background: rgba(0, 0, 0, 0.7);
            color: white;
            font-weight: bold;
            border: solid black 1px;
        }
        td {
            color: black;
            background: rgba(255, 255, 255, 0.2);
            border: solid black 1px;
        }
        tr:hover {
            background: rgba(255, 255, 255, 0.4);
            transition: 0.3s;
        }
        .buttons {
            margin-top: 20px;
            display: flex;
            gap: 15px;
        }
        .btn {
            padding: 12px 20px;
            font-size: 16px;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
        }
        .btn-home {
            background: #dc3545;
            color: white;
        }
        .btn-home:hover {
            background: #c82333;
            transform: scale(1.05);
        }
        .btn-back {
            background: green;
            color: white;
        }
        .btn-back:hover {
            background: darkgreen;
            transform: scale(1.05);
        }
    </style>
</head>
<body>

    <h1>Available Rooms</h1>

    <div class="table-container">
        <table>
            <tr>
                <th>Room Number</th>
                <th>Room Type</th>
                <th>Capacity</th>
                <th>Current Occupancy</th>
                <th>Price</th>
            </tr>

            <%
                // Database Connection
                String jdbcURL = "jdbc:mysql://localhost:3306/hostel";
                String dbUser = "root";
                String dbPassword = "1234";

                Connection con = null;
                Statement stmt = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    con = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                    stmt = con.createStatement();

                    // UPDATED QUERY: removed room_id
                    rs = stmt.executeQuery("SELECT room_number, room_type, capacity, current_occupancy, price FROM rooms");

                    boolean hasRooms = false;
                    while (rs.next()) {
                        hasRooms = true;
            %>
                        <tr>
                            <td><%= rs.getInt("room_number") %></td>
                            <td><%= rs.getString("room_type") %></td>
                            <td><%= rs.getInt("capacity") %></td>
                            <td><%= rs.getInt("current_occupancy") %></td>
                            <td><%= rs.getDouble("price") %></td>
                        </tr>
            <%
                    }
                    if (!hasRooms) {
            %>
                        <tr>
                            <td colspan="5" style="color: red; font-weight: bold;">No Rooms Available</td>
                        </tr>
            <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
            %>
                <tr>
                    <td colspan="5" style="color: red; font-weight: bold;">Error Fetching Data: <%= e.getMessage() %></td>
                </tr>
            <%
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                    if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                    if (con != null) try { con.close(); } catch (SQLException ignore) {}
                }
            %>
        </table>
    </div>

    <div class="buttons">
        <button class="btn btn-home" onclick="window.location.href='homepage.jsp'">Go To Homepage</button>
        <button class="btn btn-back" onclick="window.location.href='Room_Management.jsp'">Back</button>
    </div>

</body>
</html>
