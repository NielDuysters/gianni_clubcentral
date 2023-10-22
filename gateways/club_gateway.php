<?php

include_once("../config.php");

class club_gateway {

    private $db = null;

    public function __construct() {
        $this->db = new PDO("mysql:host=".DB_SERVER.";dbname=".DB_NAME."", DB_USER, DB_PASS);
    }

    // Insert a Club into the database
    public function insert(Array $data) {
        $stmt = "
            INSERT INTO clubs 
                (name, info, address)
            VALUES
                (:name, :info, :address);
        ";

        try {
            $stmt = $this->db->prepare($stmt);
            $stmt->execute(array(
                'name' => $data['name'],
                'info' => $data['info'],
                'address' => (int)$data['address'],
            ));

            return $this->db->lastInsertId();
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }
    }

    // Retrieve all Clubs from the database
    public function retrieve_all() {
        $stmt = "
            SELECT
                ID, name, info, address
            FROM
                clubs;
        ";

        try {
            $stmt = $this->db->query($stmt);

            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }
    }

    // Retrieve specific Club from database
    public function retrieve($id) {
        $stmt = "
            SELECT
                ID, name, info, address
            FROM
                clubs
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
    
    // Retrieve Clubs by column from database
    public function retrieve_by($column, $id) {
        // Not implemented for Club
        http_response_code(404);
        exit();
    }

    // Update a Club in the database
    public function update($id, Array $data) {
        $stmt = "
            UPDATE clubs
            SET
                name = :name,
                info = :info,
                address = :address
            WHERE
                ID = :ID;
        ";

        try {
            $stmt = $this->db->prepare($stmt);
            $stmt->execute(array(
                'ID' => (int)$id,
                'name' => $data['name'],
                'info' => $data['info'],
                'address' => (int)$data['address'],
            ));

            return $stmt->rowCount();
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }
    }

    // Delete a Club from the database
    public function delete($id) {
        $stmt = "
            DELETE FROM clubs WHERE ID = ?;
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

