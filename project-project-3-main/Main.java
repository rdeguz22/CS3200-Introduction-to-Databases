package org.example;
import java.sql.*;
import java.util.Random;
import java.util.Scanner;

public class Main {
    static Integer user_id = null;
    static Integer employee_id = null;
    public static void main(String[] args) {
        //String url = "jdbc:mysql://localhost:3307/tree";
        String user = "tree.manager";
        String password = "tree-password";
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter database URL ");
        String url = scanner.nextLine();

        try {
            // Load the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Connecting to the database...");

            // Establish connection
            Connection connection = DriverManager.getConnection(url, user, password);

            if (connection != null) {
                System.out.println("Successfully connected to the database!");
                runMenu(connection, scanner);
                connection.close();
            }
        } catch (ClassNotFoundException e) {
            System.err.println("Error: MySQL JDBC Driver not found.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Error: Could not connect to the database.");
            e.printStackTrace();
        }
    }

    private static void logInUser(Connection conn, Scanner scanner) throws SQLException {
        System.out.print("Enter user_id: ");
        int userID = scanner.nextInt();
        String sql = "SELECT COUNT(*) FROM User WHERE user_id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, userID);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            int count = rs.getInt(1);
            if(count > 0) {
                user_id = userID;
            }
            System.out.println("Your are now logged in.");
            return;
        }
        System.out.println("Your ID is not in the database.");
    }

    private static void logInEmployee(Connection conn, Scanner scanner) throws SQLException {
        System.out.print("Enter employee_id: ");
        int employeeID = scanner.nextInt();
        String sql = "SELECT COUNT(*) FROM employee WHERE employee_id = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setInt(1, employeeID);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            int count = rs.getInt(1);
            if(count > 0) {
                employee_id = employeeID;
                System.out.println("Your are now logged in.");
                return;
            }
        }
        System.out.println("Your ID is not in the database.");
    }

    private static void addUser(Connection conn, Scanner scanner) throws SQLException {
        Random random = new Random();
        int userID =  random.nextInt(0, 100000);
        System.out.print("Enter fist name: ");
        String firstName = scanner.nextLine();

        System.out.print("Enter last name: ");
        String lastName = scanner.nextLine();

        System.out.print("Enter email: ");
        String email = scanner.nextLine();

        System.out.print("Enter neighborhood: ");
        String neighborhood = scanner.nextLine();

        System.out.print("Enter zipCode: ");
        int zipCode = Integer.parseInt(scanner.nextLine());

        String sql = "INSERT INTO User (user_id, firstName, lastName, email, neighborhood, zipCode) VALUES" +
                "(?,?,?,?,?,?)";
        PreparedStatement stmt = conn.prepareStatement(sql);

        stmt.setInt(1, userID);
        stmt.setString(2, firstName);
        stmt.setString(3, lastName);
        stmt.setString(4, email);
        stmt.setString(5, neighborhood);
        stmt.setInt(6, zipCode);

        stmt.executeUpdate();

        System.out.println("User added successfully!");
        System.out.println("Your ID number is " + userID);
    }

    private static void acceptTreeRequest(Connection conn, Scanner scanner) throws SQLException {
        if (!isEmployee(conn, scanner)) {
            return;
        }

        System.out.print("Enter address: ");
        String address = scanner.nextLine();

        String checkIDAddress = "SELECT COUNT(*) FROM requests WHERE address = ?";
        PreparedStatement checkStmt = conn.prepareStatement(checkIDAddress);
        checkStmt.setString(1, address);
        ResultSet rs = checkStmt.executeQuery();

        if (rs.next()) {
            int count = rs.getInt(1);
            if(count == 0) {
                System.out.println("Your address is not in the database.");
                return;
            }
        }

        String sql = "UPDATE requests SET status = 'Approved' WHERE address = ?";
        PreparedStatement stmt1 = conn.prepareStatement(sql);
        stmt1.setString(1, address);
        stmt1.executeUpdate();

        System.out.println("Tree request accepted!");
    }

    private static void scheduleAVisit(Connection conn, Scanner scanner) throws SQLException {
        if (!isEmployee(conn, scanner)) {
            return;
        }
        System.out.println("Enter Address:");
        String address = scanner.nextLine();

        System.out.print("Enter Scheduled Date:\n Please format as: yyyy-mm-dd\n");
        String conductedDate = scanner.nextLine();
        String sql = "INSERT INTO visits(scheduledDate, conductedDate, photoURL, employee_id, jobsite_address) VALUES (?, NULL, NULL, ?, ?)";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, conductedDate);
        stmt.setInt(2, employee_id);
        stmt.setString(3, address);
        stmt.executeUpdate();
        System.out.println("Visit scheduled");
    }

    private static void recordVisit(Connection conn, Scanner scanner) throws SQLException {
        isEmployee(conn, scanner);

        System.out.println("Enter Address: ");
        String address = scanner.nextLine();

        System.out.print("Enter conducted date:\n Please format as: yyyy-mm-dd\n");
        String conductedDateString = scanner.nextLine();
        java.sql.Date conductedDate = java.sql.Date.valueOf(conductedDateString);

        System.out.print("Enter Photo URL: ");
        String photoURL = scanner.nextLine();

        String sql = " UPDATE visits SET conductedDate = ?, photoURL = ? WHERE employee_id = ? AND jobsite_address = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setDate(1, conductedDate);
        stmt.setString(2, photoURL);
        stmt.setInt(3, employee_id);
        stmt.setString(4, address);
        stmt.executeUpdate();
        System.out.println("Visit Recorded");
    }

    private static void scheduleTreePlanting(Connection conn, Scanner scanner) throws SQLException {
        if (!isEmployee(conn, scanner)) {
            return;
        }

        System.out.print("Enter address of job site: ");
        String address = scanner.nextLine();

        System.out.print("Enter planting date (format yyyy-mm-dd): ");
        String date = scanner.nextLine();

        String updateDateSQL = "UPDATE JobSite SET date_of_job = ? WHERE jobsite_address = ?";
        PreparedStatement updateStmt = conn.prepareStatement(updateDateSQL);
        updateStmt.setString(1, date);
        updateStmt.setString(2, address);
        int rowsUpdated = updateStmt.executeUpdate();

        if (rowsUpdated == 0) {
            System.out.println("No job site found with that address.");
            return;
        }

        System.out.println("Planting date scheduled!");

        System.out.println("Enter volunteer user IDs to assign to this site (comma-separated): ");
        String userInput = scanner.nextLine();
        String[] userIds = userInput.split(",");

        String insertVolunteerSQL = "INSERT INTO volunteer (user_id, jobsite_address) VALUES (?, ?)";
        PreparedStatement insertStmt = conn.prepareStatement(insertVolunteerSQL);

        for (String idStr : userIds) {
            int userId;
            try {
                userId = Integer.parseInt(idStr.trim());
            } catch (NumberFormatException e) {
                System.out.println("Invalid user ID skipped: " + idStr);
                continue;
            }

            insertStmt.setInt(1, userId);
            insertStmt.setString(2, address);
            insertStmt.addBatch();
        }

        insertStmt.executeBatch();
        System.out.println("Volunteers successfully assigned!");
    }

    private static void addJobSiteNotes(Connection conn, Scanner scanner) throws SQLException {
        if (!isEmployee(conn, scanner)) {
            return;
        }
        System.out.print("Enter jobsite address: ");
        String address = scanner.nextLine();

        System.out.println("Enter jobsite notes");
        String notes = scanner.nextLine();

        System.out.println("Enter photo URl: ");
        String photoURL = scanner.nextLine();

        String sql = "UPDATE JobSite SET completed_data = ? ,  after_photos_URL = ?,  WHERE jobsite_address = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, notes);
        stmt.setString(2, photoURL);
        stmt.setString(3, address);
        try {
            stmt.executeUpdate();
            System.out.println("JobSite notes and photo updated.");
        } catch (SQLException e) {
            System.err.println("Error updating jobsite notes. Please check the SQL syntax or data.");
            e.printStackTrace();
        }
    }

    private static void removeTree(Connection conn, Scanner scanner) throws SQLException {
        if (!isEmployee(conn, scanner)) {
            return;
        }
        System.out.print("Enter tree name for deletion:");
        String treeName = scanner.nextLine();
        String sql = "DELETE FROM TreeSpecies WHERE scientificName = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, treeName);
        stmt.executeUpdate();
        System.out.println("Tree deleted");
    }

    private static void updateTreeSpecies(Connection conn, Scanner scanner) throws SQLException {
        if (!isEmployee(conn, scanner)) {
            return;
        }
        System.out.println("Enter tree species details to add a new species:");
        System.out.print("Tree species name: ");
        String treeSpeciesName = scanner.nextLine();
        System.out.print("Minimum basin width: ");
        double minimumBasinWidth = scanner.nextDouble();
        scanner.nextLine();
        System.out.print("Common name: ");
        String commonName = scanner.nextLine();
        System.out.print("Scientific name: ");
        String scientificName = scanner.nextLine();
        System.out.print("Height range (e.g., 40-70 ft): ");
        String heightRange = scanner.nextLine();
        System.out.print("Acceptable under power lines (TRUE/FALSE): ");
        boolean acceptableUnderPowerLine = Boolean.parseBoolean(scanner.nextLine());
        System.out.print("Drought tolerance (e.g., Low, Medium, High): ");
        String droughtTolerance = scanner.nextLine();
        System.out.print("Foliage (e.g., Deciduous, Evergreen): ");
        String foliage = scanner.nextLine();
        System.out.print("Root damage potential (e.g., Low, Medium, High): ");
        String rootDamagePotential = scanner.nextLine();
        System.out.print("Number of trees planted: ");
        int numberPlanted = scanner.nextInt();
        System.out.print("Years since first tree: ");
        int yearsSinceFirstTree = scanner.nextInt();
        System.out.print("Years since most recent tree: ");
        int yearsSinceMostRecent = scanner.nextInt();
        System.out.print("Year with most trees planted: ");
        int yearWithMostPlanted = scanner.nextInt();
        scanner.nextLine();
        String sql = "INSERT INTO TreeSpecies (treeSpecies_name, minimumBasinWidth, commonName, scientificName, heightRange, acceptableUnderPowerLine, droughtTolerance, foliage, rootDamagePotential, numberPlanted, yearsSinceFirstTree, yearsSinceMostRecent, yearWithMostPlanted) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, treeSpeciesName);
        stmt.setDouble(2, minimumBasinWidth);
        stmt.setString(3, commonName);
        stmt.setString(4, scientificName);
        stmt.setString(5, heightRange);
        stmt.setBoolean(6, acceptableUnderPowerLine);
        stmt.setString(7, droughtTolerance);
        stmt.setString(8, foliage);
        stmt.setString(9, rootDamagePotential);
        stmt.setInt(10, numberPlanted);
        stmt.setInt(11, yearsSinceFirstTree);
        stmt.setInt(12, yearsSinceMostRecent);
        stmt.setInt(13, yearWithMostPlanted);
        stmt.executeUpdate();
        System.out.println("New tree species added successfully!");
    }

    private static void viewPendingRequests(Connection conn, Scanner scanner) throws SQLException {
        if (!isEmployee(conn, scanner)) {
            return;
        }
        String sql = "SELECT r.status, DATEDIFF(CURDATE(), r.date_requested) AS daysSinceSubmitted FROM requests r WHERE r.status != 'Completed'";
        PreparedStatement stmt = conn.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();
        System.out.println("Pending Tree Planting Requests:");
        while (rs.next()) {
            String status = rs.getString("status");
            int daysSinceSubmitted = rs.getInt("daysSinceSubmitted");
            System.out.println("Status: " + status + ", Days since submitted: " + daysSinceSubmitted);
        }
    }

    private static void findTreesByLocation(Connection conn, Scanner scanner) throws SQLException {
        System.out.println("Would you like to search by zip code or neighborhood?");
        System.out.println("1: Zip Code");
        System.out.println("2: Neighborhood");
        int choice = scanner.nextInt();
        scanner.nextLine();
        String query;
        PreparedStatement stmt = null;
        if (choice == 1) {
            System.out.print("Enter Zip Code: ");
            String zipCode = scanner.nextLine();
            query = "SELECT ts.commonName, COUNT(jb.tree_name) AS tree_count " +
                    "FROM JobSite jb " +
                    "INNER JOIN tree.TreeSpecies ts ON jb.tree_name = ts.scientificName " +
                    "WHERE jb.zipCode = ? " +
                    "GROUP BY ts.commonName";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, zipCode);
        } else if (choice == 2) {
            System.out.print("Enter Neighborhood: ");
            String neighborhood = scanner.nextLine();
            query = "SELECT ts.commonName, COUNT(jb.tree_name) AS tree_count " +
                    "FROM JobSite jb " +
                    "INNER JOIN tree.TreeSpecies ts ON jb.tree_name = ts.scientificName " +
                    "WHERE jb.neighborhood = ? " +
                    "GROUP BY ts.commonName";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, neighborhood);
        } else {
            System.out.println("Invalid choice. Returning to the main menu.");
            return;
        }
        ResultSet rs = stmt.executeQuery();
        System.out.println("Tree species count for the selected location:");
        while (rs.next()) {
            String commonName = rs.getString("commonName");
            int treeCount = rs.getInt("tree_count");
            System.out.println("Tree: " + commonName + " - Count: " + treeCount);
        }
    }

    private static void getTreeStatistics(Connection conn) throws SQLException {
        String sql =
                "SELECT " +
                        "    ts.commonName AS TreeSpecies, " +
                        "    SUM(ts.numberPlanted) AS TotalTreesPlanted, " +
                        "    MAX(YEAR(CURDATE()) - ts.yearsSinceFirstTree) AS YearsSinceFirstPlanted, " +
                        "    MAX(YEAR(CURDATE()) - ts.yearsSinceMostRecent) AS YearsSinceMostRecentPlanted, " +
                        "    ts.yearWithMostPlanted AS YearWithMostPlanted, " +
                        "    ts.numberPlanted AS MostPlantedYearCount " +
                        "FROM " +
                        "    TreeSpecies ts " +
                        "GROUP BY " +
                        "    ts.scientificName " +
                        "ORDER BY " +
                        "    TotalTreesPlanted DESC";

        PreparedStatement stmt = conn.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            String treeSpecies = rs.getString("TreeSpecies");
            int totalTreesPlanted = rs.getInt("TotalTreesPlanted");
            int yearsSinceFirstPlanted = rs.getInt("YearsSinceFirstPlanted");
            int yearsSinceMostRecentPlanted = rs.getInt("YearsSinceMostRecentPlanted");
            int yearWithMostPlanted = rs.getInt("YearWithMostPlanted");
            int mostPlantedYearCount = rs.getInt("MostPlantedYearCount");

            System.out.println("Tree Species: " + treeSpecies);
            System.out.println("Total Trees Planted: " + totalTreesPlanted);
            System.out.println("Years Since First Planted: " + yearsSinceFirstPlanted);
            System.out.println("Years Since Most Recent Planted: " + yearsSinceMostRecentPlanted);
            System.out.println("Year with Most Planted: " + yearWithMostPlanted);
            System.out.println("Most Planted Year Count: " + mostPlantedYearCount);
            System.out.println("------------");
        }
    }

    private static void getNeighborhoodStatistics(Connection conn) throws SQLException {
        String sql =
                "SELECT " +
                        "    n.name AS Neighborhood, " +
                        "    COUNT(r.address) AS TotalRequests, " +
                        "    SUM(CASE WHEN r.status = 'Pending' THEN 1 ELSE 0 END) AS PendingRequests, " +
                        "    SUM(CASE WHEN r.status = 'In-Process' THEN 1 ELSE 0 END) AS InProcessRequests, " +
                        "    SUM(CASE WHEN r.status = 'Completed' THEN 1 ELSE 0 END) AS CompletedRequests, " +
                        "    SUM(CASE WHEN r.status = 'Approved' THEN 1 ELSE 0 END) AS ApprovedRequests, " +
                        "    SUM(ts.numberPlanted) AS TotalTreesPlanted, " +
                        "    GROUP_CONCAT(DISTINCT ts.commonName) AS TreesPlanted " +
                        "FROM " +
                        "    Neighborhood n " +
                        "INNER JOIN JobSite js ON n.name = js.neighborhood " +
                        "LEFT JOIN requests r ON js.jobsite_address = r.address " +
                        "LEFT JOIN TreeSpecies ts ON js.tree_name = ts.scientificName " +
                        "GROUP BY " +
                        "    n.name " +
                        "ORDER BY " +
                        "    n.name";

        PreparedStatement stmt = conn.prepareStatement(sql);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            String neighborhood = rs.getString("Neighborhood");
            int totalRequests = rs.getInt("TotalRequests");
            int pendingRequests = rs.getInt("PendingRequests");
            int inProcessRequests = rs.getInt("InProcessRequests");
            int completedRequests = rs.getInt("CompletedRequests");
            int approvedRequests = rs.getInt("ApprovedRequests");
            int totalTreesPlanted = rs.getInt("TotalTreesPlanted");
            String treesPlanted = rs.getString("TreesPlanted");

            System.out.println("Neighborhood: " + neighborhood);
            System.out.println("Total Requests: " + totalRequests);
            System.out.println("Pending Requests: " + pendingRequests);
            System.out.println("In-Process Requests: " + inProcessRequests);
            System.out.println("Completed Requests: " + completedRequests);
            System.out.println("Approved Requests: " + approvedRequests);
            System.out.println("Total Trees Planted: " + totalTreesPlanted);
            System.out.println("Trees Planted: " + treesPlanted);
            System.out.println("------------");
        }
    }

    private static boolean isUser(Connection conn, Scanner scanner) throws SQLException {
        if (user_id != null){
            return true;
        }
        System.out.println("Please log in as a User");
        return false;
    }

    private static boolean isEmployee(Connection conn, Scanner scanner) throws SQLException {
        if (employee_id != null){
            return true;
        }
        System.out.println("Please log in as a Employee");
        return false;
    }
    public static void runMenu(Connection connection, Scanner scanner) throws SQLException {
        boolean shouldExit = false;
        while (!shouldExit) {
            System.out.println("Please choose from the following options:" +
                    "\n1: Log in as a user" +
                    "\n2: Log in as a employee" +
                    "\n3: Sign up as a user" +
                    "\n4: Accept a tree request" +
                    "\n5: Schedule a visit" +
                    "\n6: Record a visit" +
                    "\n7: Schedule a tree planting" +
                    "\n8: Record a planting event" +
                    "\n9: Remove a tree" +
                    "\n10: Add a tree" +
                    "\n11: View pending requests" +
                    "\n12: Find tree locations" +
                    "\n13: Get tree statistics" +
                    "\n14: Get neighborhood statistics" +
                    "\n15: Exit");
            int input = scanner.nextInt();
            scanner.nextLine();
            switch (input) {
                case 1:
                    logInUser(connection, scanner);
                    break;
                case 2:
                    logInEmployee(connection, scanner);
                    break;
                case 3:
                    addUser(connection, scanner);
                    break;
                case 4:
                    acceptTreeRequest(connection, scanner);
                    break;
                case 5:
                    scheduleAVisit(connection, scanner);
                    break;
                case 6:
                    recordVisit(connection, scanner);
                    break;
                case 7:
                    scheduleTreePlanting(connection, scanner);
                    break;
                case 8:
                    addJobSiteNotes(connection, scanner);
                    break;
                case 9:
                    removeTree(connection, scanner);
                    break;
                case 10:
                    updateTreeSpecies(connection, scanner);
                    break;
                case 11:
                    viewPendingRequests(connection, scanner);
                    break;
                case 12:
                    findTreesByLocation(connection, scanner);
                    break;
                case 13:
                    getTreeStatistics(connection);
                    break;
                case 14:
                    getNeighborhoodStatistics(connection);
                    break;
                case 15:
                    shouldExit = true;
                    break;
                default:
                    System.out.println("Invalid option! Pleas try again.");
            }
        }
    }
}