<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Hostel Management System</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background: url('file:///C:/Users/YourUsername/Desktop/Project/images/hostel-bg.jpg') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            flex-direction: column;
        }

        .container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
            text-align: center;
            width: 350px;
        }

        h1 {
            color: white;
            margin-bottom: 20px;
        }

        .btn {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            color: white;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn:hover {
            transform: scale(1.05);
        }

        .btn-add {
            background: #28a745;
        }

        .btn-remove {
            background: #dc3545;
        }

        .btn-view {
            background: #007bff;
        }
        .btn-viewroom {
            background: orange;
        }
        .btn-room {
            background: pink;
            color: black;
        }
        .btn-logout {
            background: red;
            color: white;
        }
    </style>
</head>
<body>
        <h2>Hostel Management System</h2><br>
    <div class="container">
        <button class="btn btn-add" onclick="window.location.href='addStudent.jsp'">Add Student</button>
        <button class="btn btn-remove" onclick="window.location.href='removeStudent.jsp'">Remove Student</button>
        <button class="btn btn-view" onclick="window.location.href='viewStudents.jsp'">View Students List</button>
        <button class="btn btn-viewroom" onclick="window.location.href='viewRooms.jsp'">View Rooms</button>
        <button class="btn btn-room" onclick="window.location.href='addRoom.jsp'">Add New Room</button>
        <button class="btn btn-logout" onclick="window.location.href='index.jsp'">Logout</button>
    </div>

</body>
</html>
