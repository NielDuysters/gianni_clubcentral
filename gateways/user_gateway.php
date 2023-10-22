<?php

include_once("../config.php");

class user_gateway {

    private $db = null;

    public function __construct() {
        $this->db = new PDO("mysql:host=".DB_SERVER.";dbname=".DB_NAME."", DB_USER, DB_PASS);
    }

    // Insert a User into the database
    public function insert(Array $data) {
        $stmt = "
            INSERT INTO users 
                (name, telnr, email, password)
            VALUES
                (:name, :telnr, :email, :password);
        ";

        try {
            $stmt = $this->db->prepare($stmt);
            $stmt->execute(array(
                'name' => $data['name'],
                'telnr' => $data['telnr'],
                'email' => $data['email'],
                'password' => $data['password'],
            ));

            return $this->db->lastInsertId();
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }
    }

    // Retrieve all Users from the database
    public function retrieve_all() {
        $stmt = "
            SELECT
                ID, name, telnr, email, password
            FROM
                users;
        ";

        try {
            $stmt = $this->db->query($stmt);

            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }
    }

    // Retrieve specific User from database
    public function retrieve($id) {
        $stmt = "
            SELECT
                ID, name, telnr, email, password
            FROM
                users
            WHERE ID = ?;
        ";

        try {
            $stmt = $this->db->prepare($stmt);
            $stmt->execute(array($id));

            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }

    }
    
    // Retrieve Users by column from database
    public function retrieve_by($column, $id) {
        // $column must be a allowed column
        if (!in_array($column, array(
            "email",
        ))) {
            http_response_code(500);
            exit("Invalid foreign key");
        }

        $stmt = "
            SELECT
                ID, name, telnr, email, password
            FROM
                users
            WHERE ". $column ." = ?;
        ";

        try {
            $stmt = $this->db->prepare($stmt);
            $stmt->execute(array($id));

            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }

    }

    // Update a User in the database
    public function update($id, Array $data) {
        $stmt = "
            UPDATE users
            SET
                name = :name,
                telnr = :telnr,
                email = :email,
                password = IFNULL(:password, password)
            WHERE
                ID = :ID;
        ";

        try {
            $stmt = $this->db->prepare($stmt);
            $stmt->execute(array(
                'ID' => (int)$id,
                'name' => $data['name'],
                'telnr' => $data['telnr'],
                'email' => $data['email'],
                'password' => $data['password'] ?? null,
            ));

            return $stmt->rowCount();
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }
    }

    // Delete a User from the database
    public function delete($id) {
        $stmt = "
            DELETE FROM users WHERE ID = ?;
        ";

        try {
            $stmt = $this->db->prepare($stmt);
            $stmt->execute(array($id));

            return $stmt->rowCount();
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }
    }
}

