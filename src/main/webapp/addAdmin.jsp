<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Admin</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        body {
            background: #f4f4f4;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            flex-direction: column;
        }

        .form-container {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
            text-align: center;
        }

        input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .btn {
            background: #28a745;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
    </style>
</head>
<body>

    <div class="form-container">
        <h2>Add New Admin</h2>
        <form method="POST">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <button class="btn" type="submit">Add Admin</button>
        </form>
    </div>

    <%
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username != null && password != null) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/hostel", "root", "1234");

                PreparedStatement ps = con.prepareStatement("INSERT INTO admin (username, password) VALUES (?, ?)");
                ps.setString(1, username);
                ps.setString(2, password);

                int result = ps.executeUpdate();
                ps.close();
                con.close();

                if (result > 0) {
    %>
                    <script>
                        Swal.fire("Success", "Admin added successfully!", "success").then(() => {
                            window.location.href = "manageAdmins.jsp";
                        });
                    </script>
    <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    %>

</body>
</html>
