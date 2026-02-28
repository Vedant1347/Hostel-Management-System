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
            background-image: url('home1.jpg');
            background-size: cover;
            background-position: center;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            flex-direction: column;
        }

        .container {
            backdrop-filter: blur(100px);
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.2);
            text-align: center;
            width: 350px;
        }

        h1 {
            color: white;
            margin-top: -80px;
            margin-bottom: 40px;
            font-size: 52px;
            backdrop-filter: blur(50px);
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
            position: relative;
            overflow: hidden;
        }

        .btn:hover {
            transform: scale(1.12);
        }

        /* Button Styles */
        .btn-add { background: #28a745; }
        .btn-remove { background: #dc3545; }
        .btn-view { background: #007bff; }
        .btn-manageroom { background: purple; color: white; }

        /* Logout Button Styling */
        .btn-logout {
            background: red;
            color: white;
            position: relative;
        }

        .btn-logout::after {
            content: '⚠️';
            position: absolute;
            right: 15px;
            font-size: 18px;
            transition: 0.3s ease;
        }

        .btn-logout:hover::after {
            transform: rotate(360deg);
        }
    </style>
</head>
<body>

    <h1>HOSTEL MANAGEMENT SYSTEM</h1><br>

    <div class="container">
        <button class="btn btn-add" onclick="window.location.href='addStudent.jsp'">Add Student</button>
        <button class="btn btn-remove" onclick="window.location.href='removeStudent.jsp'">Remove Student</button>
        <button class="btn btn-view" onclick="window.location.href='viewStudents.jsp'">View Students List</button>
        <button class="btn btn-manageroom" onclick="window.location.href='Room_Management.jsp'">Manage Rooms</button>
        <button class="btn btn-logout" onclick="confirmLogout()">Logout</button>
    </div>

    <script>
        function confirmLogout() {
            Swal.fire({
                title: "Are you sure?",
                text: "Do you really want to logout?",
                icon: "warning",
                showCancelButton: true,
                confirmButtonColor: "#d33",
                cancelButtonColor: "#3085d6",
                confirmButtonText: "Yes, Logout!",
                cancelButtonText: "Cancel",
                background: "#f8f9fa",
                color: "#333",
                iconHtml: "⚠️",
                customClass: {
                    confirmButton: "btn btn-danger",
                    cancelButton: "btn btn-secondary"
                }
            }).then((result) => {
                if (result.isConfirmed) {
                    window.location.href = "index.jsp";
                }
            });
        }
    </script>

</body>
</html>
