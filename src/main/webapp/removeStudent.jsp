<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Remove Student</title>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background-image: url('remove-student.jpg');
            background-size: cover;
            padding: 40px;
        }

        .container {
            background: rgba(255,255,255,0.15);
            backdrop-filter: blur(10px);
            padding: 20px;
            border-radius: 10px;
            width: 90%;
            margin: auto;
        }

        h1 {
            color: white;
            text-align: center;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            background: rgba(255,255,255,0.8);
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            border: 1px solid black;
            text-align: center;
        }

        th {
            background: #333;
            color: white;
        }

        .btn-delete {
            background: #dc3545;
            padding: 8px 12px;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .btn-back {
            width: 100%;
            padding: 10px;
            background: darkgreen;
            color: white;
            margin-top: 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
    </style>
</head>

<body>

<div class="container">
    <h1>Remove Student</h1>

    <%
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/hostel", "root", "1234");

            ps = con.prepareStatement("SELECT * FROM students");
            rs = ps.executeQuery();
    %>

    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Age</th>
            <th>City</th>
            <th>Blood Group</th>
            <th>Room No</th>
            <th>Action</th>
        </tr>

        <%
            while (rs.next()) {
                int id = rs.getInt("id");
                String name = rs.getString("name");
                int age = rs.getInt("age");
                String city = rs.getString("city");
                String blood = rs.getString("bloodgroup");
                int room = rs.getInt("room_number");
        %>

        <tr>
            <td><%= id %></td>
            <td><%= name %></td>
            <td><%= age %></td>
            <td><%= city %></td>
            <td><%= blood %></td>
            <td><%= room %></td>

            <td>
                <button class="btn-delete" onclick="confirmDelete(<%= id %>)">
                    Delete
                </button>
            </td>
        </tr>

        <% } %>

    </table>

    <%
        } catch (Exception e) {
            out.println("<p style='color:white;'>Error loading students</p>");
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (con != null) con.close();
        }
    %>

    <button class="btn-back" onclick="window.location.href='homepage.jsp'">Go Back</button>

</div>

<!-- ✅ SweetAlert confirmation popup -->
<script>
    function confirmDelete(id) {
        Swal.fire({
            title: 'Are you sure?',
            text: "This student will be deleted!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#dc3545',
            cancelButtonColor: '#6c757d',
            confirmButtonText: 'Yes, delete it!'
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = "removeStudent.jsp?delete_id=" + id;
            }
        });
    }
</script>

<%
    // ==============================
    // DELETE LOGIC
    // ==============================
    if (request.getParameter("delete_id") != null) {

        int studentId = Integer.parseInt(request.getParameter("delete_id"));

        Connection con2 = null;
        PreparedStatement psCheck = null, psDelete = null, psUpdate = null;
        ResultSet rs2 = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/hostel", "root", "1234");

            psCheck = con2.prepareStatement("SELECT room_number FROM students WHERE id=?");
            psCheck.setInt(1, studentId);
            rs2 = psCheck.executeQuery();

            if (rs2.next()) {
                int roomNo = rs2.getInt("room_number");

                psDelete = con2.prepareStatement("DELETE FROM students WHERE id=?");
                psDelete.setInt(1, studentId);
                int deleted = psDelete.executeUpdate();

                if (deleted > 0) {
                    psUpdate = con2.prepareStatement(
                        "UPDATE rooms SET current_occupancy = GREATEST(current_occupancy - 1, 0) WHERE room_number=?"
                    );
                    psUpdate.setInt(1, roomNo);
                    psUpdate.executeUpdate();
    %>

<script>
    Swal.fire("Deleted!", "Student removed successfully!", "success")
        .then(() => window.location.href = "removeStudent.jsp");
</script>

    <%
                }
            }

        } catch (Exception e) {
    %>

<script>
    Swal.fire("Error!", "<%= e.getMessage() %>", "error");
</script>

    <%
        } finally {
            if (rs2 != null) rs2.close();
            if (psCheck != null) psCheck.close();
            if (psDelete != null) psDelete.close();
            if (psUpdate != null) psUpdate.close();
            if (con2 != null) con2.close();
        }
    }
%>

</body>
</html>
