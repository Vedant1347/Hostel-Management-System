<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String message = ""; // Shows success or error message

    // If delete is requested
    if (request.getParameter("delete") != null) {
        String roomNumber = request.getParameter("delete");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hostel", "root", "1234"
            );

            // Step 1: Check if any students are assigned to this room
            PreparedStatement psCheck = con.prepareStatement(
                "SELECT COUNT(*) FROM students WHERE room_number = ?"
            );
            psCheck.setString(1, roomNumber);
            ResultSet rsCheck = psCheck.executeQuery();
            rsCheck.next();
            int studentCount = rsCheck.getInt(1);

            if (studentCount > 0) {
                message = "<script>Swal.fire('Error!', 'Cannot delete room! Students are still assigned to this room.', 'error');</script>";
            } else {
                // Step 2: Delete room if no students assigned
                PreparedStatement psDelete = con.prepareStatement(
                    "DELETE FROM rooms WHERE room_number = ?"
                );
                psDelete.setString(1, roomNumber);
                int deleted = psDelete.executeUpdate();

                if (deleted > 0) {
                    message = "<script>Swal.fire('Deleted!', 'Room deleted successfully!', 'success').then(() => window.location='deleteRoom.jsp');</script>";
                } else {
                    message = "<script>Swal.fire('Error!', 'Room deletion failed!', 'error');</script>";
                }
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            message = "<script>Swal.fire('Error!', '" + e.getMessage() + "', 'error');</script>";
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Delete Room</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('delete-room.jpg');
            background-size: cover;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            flex-direction: column;
        }
        .container {
            backdrop-filter: blur(50px);
            background: lightblue;
            padding: 20px;
            border-radius: 10px;
            width: 80%;
            max-width: 600px;
            text-align: center;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            border: solid black 1.5px;
            text-align: center;
        }
        th {
            background-color: #28a745;
            color: white;
        }
        .btn-delete {
            background-color: #dc3545;
            padding: 6px 10px;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-delete:hover {
            background-color: #c82333;
        }
        .btn-back {
            background-color: purple;
            color: white;
            padding: 10px 14px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 15px;
        }
        .btn-back:hover {
            background-color: blue;
        }
    </style>

    <!-- JS Confirmation Delete -->
    <script>
        function confirmDelete(roomNumber) {
            Swal.fire({
                title: "Are you sure?",
                text: "This will permanently delete Room " + roomNumber + "!",
                icon: "warning",
                showCancelButton: true,
                confirmButtonColor: "#d33",
                cancelButtonColor: "#3085d6",
                confirmButtonText: "Yes, delete it!"
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location = "deleteRoom.jsp?delete=" + roomNumber;
                }
            });
        }
    </script>

</head>
<body>

<div class="container">
    <h1>Delete Room</h1>

    <!-- Display SweetAlert messages -->
    <%= message %>

    <table>
        <tr>
            <th>Room Number</th>
            <th>Room Type</th>
            <th>Capacity</th>
            <th>Occupancy</th>
            <th>Action</th>
        </tr>

        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/hostel", "root", "1234"
                );

                ResultSet rs = con.createStatement().executeQuery("SELECT * FROM rooms");

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("room_number") %></td>
            <td><%= rs.getString("room_type") %></td>
            <td><%= rs.getInt("capacity") %></td>
            <td><%= rs.getInt("current_occupancy") %></td>

            <td>
                <button class="btn-delete" onclick="confirmDelete(<%= rs.getInt("room_number") %>)">
                    Delete
                </button>
            </td>
        </tr>
        <%
                }
                con.close();
            } catch (Exception e) {
                out.println("<p>Error loading rooms.</p>");
            }
        %>
    </table>

    <button class="btn-back" onclick="window.location.href='Room_Management.jsp'">Go Back</button>

</div>

</body>
</html>
