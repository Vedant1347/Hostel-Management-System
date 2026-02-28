<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login Page</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap');

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #1e1e2f, #32324d);
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            color: #fff;
        }

        .login-container {
            background: rgba(30, 30, 47, 0.85);
            backdrop-filter: blur(10px);
            padding: 40px;
            border-radius: 15px;
            width: 350px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.5);
            text-align: center;
            animation: fadeIn 0.8s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .login-container h2 {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 25px;
            color: #fff;
        }

        .login-container input {
            width: 100%;
            padding: 12px 15px;
            margin: 12px 0;
            border-radius: 8px;
            border: 1px solid rgba(255,255,255,0.3);
            background: rgba(255,255,255,0.1);
            color: #fff;
            font-size: 14px;
            transition: 0.25s;
        }

        .login-container input:focus {
            border-color: #6a11cb;
            box-shadow: 0 0 8px rgba(106,17,203,0.4);
            outline: none;
            background: rgba(255,255,255,0.15);
        }

        .login-container button {
            width: 100%;
            padding: 12px;
            margin-top: 15px;
            font-size: 16px;
            font-weight: 600;
            color: #fff;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            background: linear-gradient(135deg, #6a11cb, #2575fc);
            box-shadow: 0 6px 15px rgba(0,0,0,0.4);
            transition: all 0.3s ease;
        }

        .login-container button:hover {
            transform: translateY(-3px);
            opacity: 0.9;
        }

        .login-container p {
            margin-top: 15px;
            font-size: 13px;
            color: rgba(255,255,255,0.7);
        }

        @media(max-width: 400px) {
            .login-container {
                width: 95%;
                padding: 30px;
            }
        }
    </style>
</head>
<body>

<div class="login-container">
    <h2>Login</h2>
    <form method="POST">
        <input type="text" name="username" placeholder="Enter ID / Username" required>
        <input type="text" name="password" placeholder="Enter Password (Email for Students)" required>
        <button type="submit">Login</button>
    </form>
    <p>Enter your credentials to access the dashboard.</p>
</div>

<script>
    function loginSuccessAdmin() {
        Swal.fire({
            title: "Admin Login Successful!",
            text: "Redirecting to Admin Dashboard...",
            icon: "success",
            showConfirmButton: false,
            timer: 1800
        }).then(() => window.location.href = "homepage.jsp");
    }

    function loginSuccessStudent(id) {
        Swal.fire({
            title: "Student Login Successful!",
            text: "Redirecting to Profile...",
            icon: "success",
            showConfirmButton: false,
            timer: 1800
        }).then(() => window.location.href = "studentProfile.jsp?id=" + id);
    }

    function loginFailed() {
        Swal.fire({
            title: "Login Failed!",
            text: "Invalid Credentials!",
            icon: "error",
            confirmButtonText: "Try Again"
        });
    }
</script>

<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    if (username != null && password != null) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/hostel", "root", "1234"
            );

            // Check Admin Login
            ps = con.prepareStatement("SELECT * FROM admin WHERE username=? AND password=?");
            ps.setString(1, username);
            ps.setString(2, password);
            rs = ps.executeQuery();

            if (rs.next()) {
%>
                <script> loginSuccessAdmin(); </script>
<%
            } else {
                // Check Student Login
                ps = con.prepareStatement("SELECT * FROM students WHERE id=? AND email=?");
                ps.setString(1, username);
                ps.setString(2, password);
                rs = ps.executeQuery();

                if (rs.next()) {
                    String studentId = rs.getString("id");
%>
                    <script> loginSuccessStudent('<%= studentId %>'); </script>
<%
                } else {
%>
                    <script> loginFailed(); </script>
<%
                }
            }

            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

</body>
</html>
