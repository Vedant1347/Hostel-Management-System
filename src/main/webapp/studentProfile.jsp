<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String studentID = request.getParameter("id");

    String name="", email="", city="", blood="", room="";
    int age = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/hostel", "root", "1234"
        );

        PreparedStatement ps = con.prepareStatement(
            "SELECT * FROM students WHERE id = ?"
        );
        ps.setString(1, studentID);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            email = rs.getString("email");
            city = rs.getString("city");
            blood = rs.getString("bloodgroup");
            age = rs.getInt("age");
            room = rs.getString("room_number");
        }

        con.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Student Profile</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        * {
            margin: 0; padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            background: linear-gradient(135deg, #4158D0, #C850C0, #FFCC70);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .id-card {
            width: 370px;
            background: rgba(255, 255, 255, 0.25);
            padding: 25px;
            border-radius: 20px;
            text-align: center;
            box-shadow: 0px 8px 25px rgba(0,0,0,0.3);
            backdrop-filter: blur(12px);
            color: white;
            animation: fadeIn 1s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.9); }
            to { opacity: 1; transform: scale(1); }
        }

        h2 {
            font-size: 24px;
            margin-bottom: 8px;
            font-weight: 600;
        }

        .details {
            text-align: left;
            margin-top: 15px;
            padding-left: 20px;
            font-size: 16px;
        }

        .details p {
            margin-bottom: 8px;
            font-size: 15px;
            font-weight: 500;
        }

        .back-btn {
            margin-top: 18px;
            width: 90%;
            padding: 12px;
            background: linear-gradient(45deg, #ff5f6d, #ffc371);
            border: none;
            color: white;
            font-size: 16px;
            font-weight: bold;
            border-radius: 10px;
            cursor: pointer;
            box-shadow: 0 5px 12px rgba(255, 96, 77, 0.5);
            transition: 0.3s;
        }

        .back-btn:hover {
            transform: scale(1.08);
        }
    </style>
</head>

<body>

<div class="id-card">
    <!-- Photo removed -->

    <h2><%= name %></h2>
    <p style="opacity: 0.8;">Student Identity Card</p>

    <div class="details">
        <p><b>Email:</b> <%= email %></p>
        <p><b>Age:</b> <%= age %></p>
        <p><b>City:</b> <%= city %></p>
        <p><b>Blood Group:</b> <%= blood %></p>
        <p><b>Room Assigned:</b> <%= room %></p>
        <p><b>Student ID:</b> <%= studentID %></p>
    </div>

    <button class="back-btn" onclick="confirmLogout()">Logout</button>
</div>

<script>
    function confirmLogout() {
        Swal.fire({
            title: "Logout?",
            text: "Are you sure you want to logout?",
            icon: "warning",
            showCancelButton: true,
            confirmButtonColor: "#ff4b5c",
            cancelButtonColor: "#3085d6",
            confirmButtonText: "Yes, Logout"
        }).then((result) => {
            if (result.isConfirmed) {
                window.location.href = "index.jsp";
            }
        });
    }
</script>

</body>
</html>
