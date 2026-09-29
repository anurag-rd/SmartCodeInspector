
	package com.inspector.util;

	import java.sql.Connection;
	import java.sql.DriverManager;

	public class DBConnection {
	    private static Connection conn = null;

	    public static Connection getConnection() {
	        if (conn == null) {
	            try {
	                Class.forName("com.mysql.cj.jdbc.Driver");
	                conn = DriverManager.getConnection(
	                    "jdbc:mysql://localhost:3306/code_inspector_db",
	                    "root", 
	                    "Anu@9568" // Replace with your MySQL password
	                );
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        }
	        return conn;
	    }
	}


