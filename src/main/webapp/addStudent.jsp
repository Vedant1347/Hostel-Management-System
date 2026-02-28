<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // Preserve form values
    String NameVal = request.getParameter("name") != null ? request.getParameter("name") : "";
    String EmailVal = request.getParameter("email") != null ? request.getParameter("email") : "";
    String AgeVal = request.getParameter("age") != null ? request.getParameter("age") : "";
    String CityVal = request.getParameter("city") != null ? request.getParameter("city") : "";
    String BloodVal = request.getParameter("bloodgroup") != null ? request.getParameter("bloodgroup") : "";
    String RoomTypeVal = request.getParameter("room_type") != null ? request.getParameter("room_type") : "";
    String RoomNoVal = request.getParameter("room_number") != null ? request.getParameter("room_number") : "";
    String action = request.getParameter("action") != null ? request.getParameter("action") : "";
%>

<!DOCTYPE html>
<html>
<head>
    <title>Add Student</title>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: Arial, sans-serif; }

        body {
            background-image: url('add-student.jpg');
            background-size: cover;
            display: flex; justify-content: center; align-items: center;
            height: 100vh;
        }

        .container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(20px);
            padding: 40px;
            border-radius: 10px;
            text-align: center;
            width: 350px;
        }

        h1 { color: white; margin-bottom: 20px; }

        input, select {
            width: 100%; padding: 10px; margin: 10px 0;
            border: 1px solid white; background: pink; color: black;
            border-radius: 5px; outline: none;
        }

        button {
            width: 100%; padding: 10px; margin-top: 15px;
            background: #28a745; color: white; border: none;
            border-radius: 5px; font-size: 16px; cursor: pointer;
        }

        button:hover { background: #218838; }

        .btn-logout { background: #c82333; }
    </style>
</head>

<body>

<div class="container">
    <h1>Add Student</h1>

    <form method="post">

        <!-- action hidden input -->
        <input type="hidden" name="action" value="">

        <input type="text" name="name" placeholder="Enter Name" required value="<%= NameVal %>">
        <input type="email" name="email" placeholder="Enter Email" required value="<%= EmailVal %>">
        <input type="number" name="age" placeholder="Enter Age" required value="<%= AgeVal %>">
        <input type="text" name="city" placeholder="Enter City" required value="<%= CityVal %>">
        <input type="text" name="bloodgroup" placeholder="Enter Blood Group" required value="<%= BloodVal %>">

        <!-- ROOM TYPE -->
        <select name="room_type" required onchange="
            document.querySelector('input[name=action]').value = 'loadRooms';
            this.form.submit();
        ">
            <option value="">Select Room Type</option>
            <option value="A/C" <%= ("A/C".equals(RoomTypeVal) ? "selected" : "") %>>A/C</option>
            <option value="Non-A/C" <%= ("Non-A/C".equals(RoomTypeVal) ? "selected" : "") %>>Non-A/C</option>
        </select>

        <!-- AVAILABLE ROOMS -->
        <select name="room_number" required>
            <option value="">Select Available Room</option>

            <%
                if (!RoomTypeVal.equals("")) {
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/hostel", "root", "1234");

                        PreparedStatement ps = con.prepareStatement(
                            "SELECT room_number FROM rooms WHERE room_type = ? AND current_occupancy < capacity"
                        );
                        ps.setString(1, RoomTypeVal);
                        ResultSet rs = ps.executeQuery();

                        boolean hasRoom = false;

                        while (rs.next()) {
                            hasRoom = true;
                            int rno = rs.getInt("room_number");
            %>
                            <option value="<%= rno %>" <%= (String.valueOf(rno).equals(RoomNoVal) ? "selected" : "") %>>
                                Room <%= rno %>
                            </option>
            <%
                        }

                        if (!hasRoom) {
            %>
                            <option>No Rooms Available</option>
            <%
                        }

                        con.close();

                    } catch (Exception e) {
                        out.println("<option>Error Loading Rooms</option>");
                    }
                }
            %>

        </select>

        <!-- CONFIRMATION ADD BUTTON -->
        <button type="button" onclick="confirmAdd()">Add Student</button>

        <script>
            function confirmAdd() {
                Swal.fire({
                    title: "Confirm Add Student?",
                    text: "Are you sure you want to add this student?",
                    icon: "question",
                    showCancelButton: true,
                    confirmButtonText: "Yes, Add",
                    cancelButtonText: "No"
                }).then((result) => {
                    if (result.isConfirmed) {
                        document.querySelector('input[name=action]').value = 'addStudent';
                        document.forms[0].submit();
                    }
                });
            }
        </script>

    </form>

    <button class="btn-logout" onclick="window.location.href='homepage.jsp'">Go Back</button>
</div>

<%
    // =====================================
    // INSERT STUDENT ONLY WHEN action = addStudent
    // =====================================

    if ("addStudent".equals(action)) {

        if (RoomNoVal == null || RoomNoVal.equals("")) {
%>
<script>
    Swal.fire("Select Room", "Please select a valid room.", "warning");
</script>
<%
        } else {

            String Name = NameVal;
            String Email = EmailVal;
            int Age = Integer.parseInt(AgeVal);
            String City = CityVal;
            String Blood = BloodVal;
            int roomNo = Integer.parseInt(RoomNoVal);

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/hostel", "root", "1234");

                // Email Exists?
                PreparedStatement checkEmail = con.prepareStatement("SELECT id FROM students WHERE email = ?");
                checkEmail.setString(1, Email);
                ResultSet er = checkEmail.executeQuery();

                if (er.next()) {
%>
<script>
    Swal.fire("Student Exists", "Email already registered!", "error");
</script>
<%
                } else {

                    PreparedStatement check = con.prepareStatement(
                        "SELECT capacity, current_occupancy FROM rooms WHERE room_number = ?"
                    );
                    check.setInt(1, roomNo);
                    ResultSet rs = check.executeQuery();

                    if (rs.next()) {
                        int cap = rs.getInt("capacity");
                        int occ = rs.getInt("current_occupancy");

                        if (occ >= cap) {
%>
<script>
    Swal.fire("Room Full", "Cannot add student, room is full!", "error");
</script>
<%
                        } else {

                            PreparedStatement insert = con.prepareStatement(
                                "INSERT INTO students (name, email, age, city, bloodgroup, room_number) VALUES (?, ?, ?, ?, ?, ?)"
                            );
                            insert.setString(1, Name);
                            insert.setString(2, Email);
                            insert.setInt(3, Age);
                            insert.setString(4, City);
                            insert.setString(5, Blood);
                            insert.setInt(6, roomNo);
                            insert.executeUpdate();

                            PreparedStatement update = con.prepareStatement(
                                "UPDATE rooms SET current_occupancy = current_occupancy + 1 WHERE room_number = ?"
                            );
                            update.setInt(1, roomNo);
                            update.executeUpdate();
%>
<script>
    Swal.fire("Success", "Student Added Successfully!", "success");
</script>
<%
                        }
                    }
                }

                con.close();

            } catch (Exception e) {
%>
<script>
    Swal.fire("Error", "<%= e.getMessage() %>", "error");
</script>
<%
            }
        }
    }
%>

</body>
</html>