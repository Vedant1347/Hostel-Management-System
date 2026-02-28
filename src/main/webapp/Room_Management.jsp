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
            background-image: url('manage.png') ;
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            flex-direction: column;
        }

        .container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(20px);
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
            text-align: center;
            width: 350px;
        }

        h1 {
            color: white;
            margin-bottom: 20px;
            font-size: 46px;
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
            transform: scale(1.15);
        }

        .btn-add {
            background: #28a745;
        }
        .btn-viewroom {
            background: orange;
        }
        .btn-edit {
            background: pink;
            color: black;
        }
         .btn-delete {
               background: red;
               color: white;
         }
         .btn-back {
               background: purple;
               color: white;
         }
    </style>
</head>
<body>
        <h1>Manage Rooms</h1><br>
    <div class="container">
        <button class="btn btn-add" onclick="window.location.href='addRoom.jsp'">Add new Room</button>
        <button class="btn btn-viewroom" onclick="window.location.href='viewRooms.jsp'">View All Rooms</button>
        <button class="btn btn-edit" onclick="window.location.href='editRoom.jsp'">Update Rooms</button>
        <button class="btn btn-delete" onclick="window.location.href='deleteRoom.jsp'">Delete Room</button>
        <button class="btn btn-back" onclick="window.location.href='homepage.jsp'"><< Back</button>
    </div>

</body>
</html>
