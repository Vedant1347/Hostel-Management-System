<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Student List</title>
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
            align-items: flex-start;
            padding: 40px 0;
            color: #f0f0f0;
        }

        .container {
            width: 95%;
            max-width: 900px;
            background: rgba(30, 30, 47, 0.8);
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.4);
            backdrop-filter: blur(10px);
        }

        h1 {
            text-align: center;
            margin-bottom: 25px;
            font-size: 28px;
            color: #ffffff;
            letter-spacing: 1px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            border-radius: 10px;
            overflow: hidden;
            background: rgba(0,0,0,0.2);
        }

        th, td {
            padding: 14px;
            text-align: center;
        }

        th {
            background: #0f0f1f;
            color: #ffffff;
            font-weight: 600;
        }

        td {
            background: rgba(255,255,255,0.05);
            color: #e0e0e0;
        }

        tr:nth-child(even) td {
            background: rgba(255,255,255,0.02);
        }

        tr:hover td {
            background: rgba(255,255,255,0.15);
            transition: 0.3s;
        }

        button {
            display: block;
            margin: 25px auto 0 auto;
            padding: 12px 25px;
            font-size: 16px;
            font-weight: 500;
            color: #fff;
            background: linear-gradient(135deg,#6a11cb,#2575fc);
            border: none;
            border-radius: 8px;
            cursor: pointer;
            box-shadow: 0 6px 15px rgba(0,0,0,0.4);
            transition: all 0.3s ease;
        }

        button:hover {
            transform: translateY(-3px);
            opacity: 0.9;
        }

        @media(max-width: 768px) {
            table, th, td {
                font-size: 12px;
                padding: 10px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <h1>List of Students</h1>
    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Age</th>
            <th>City</th>
            <th>Blood Group</th>
            <th>Room No</th>
        </tr>

<%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/hostel", "root", "1234");
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM students");

        while (rs.next()) {
            int id = rs.getInt("id");
%>
        <tr>
            <td><%= id %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getInt("age") %></td>
            <td><%= rs.getString("city") %></td>
            <td><%= rs.getString("bloodgroup") %></td>
            <td><%= rs.getInt("room_number") %></td>
        </tr>
<%
        }
        rs.close();
        stmt.close();
        con.close();
    } catch (Exception e) {
        out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
    }
%>
    </table>
    <button onclick="window.location.href='homepage.jsp'">Go Back</button>
</div>

</body>
</html>
