<?php

include_once("../config.php");

class event_gateway {

    private $db = null;

    public function __construct() {
        $this->db = new PDO("mysql:host=".DB_SERVER.";dbname=".DB_NAME."", DB_USER, DB_PASS);
    }

    // Insert a Event into the database
    public function insert(Array $data) {
        $stmt = "
            INSERT INTO events
                (name, info, club)
            VALUES
                (:name, :info, :club);
        ";

        try {
            $stmt = $this->db->prepare($stmt);
            $stmt->execute(array(
                'name' => $data['name'],
                'info' => $data['info'],
                'club' => (int)$data['club'],
            ));

            return $this->db->lastInsertId();
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }
    }

    // Retrieve all Events from the database
    public function retrieve_all() {
        $stmt = "
            SELECT
                ID, name, info, club
            FROM
                events;
        ";

        try {
            $stmt = $this->db->query($stmt);

            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }
    }

    // Retrieve specific Event from database
    public function retrieve($id) {
        $stmt = "
            SELECT
                ID, name, info, club
            FROM
                events
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
    
    // Retrieve Events by column from database
    public function retrieve_by($column, $id) {
        // $column must be a allowed column
        if (!in_array($column, array(
            "club",
        ))) {
            http_response_code("500");
            exit("Invalid foreign key");
        }

        $stmt = "
            SELECT
                ID, name, info, club
            FROM
                events
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

    // Update a Event in the database
    public function update($id, Array $data) {
        $stmt = "
            UPDATE events
            SET
                name = :name,
                info = :info,
                club = :club
            WHERE
                ID = :ID;
        ";

        try {
            $stmt = $this->db->prepare($stmt);
            $stmt->execute(array(
                'ID' => (int)$id,
                'name' => $data['name'],
                'info' => $data['info'],
                'club' => (int)$data['club'],
            ));

            return $stmt->rowCount();
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }
    }

    // Delete a Event from the database
    public function delete($id) {
        $stmt = "
            DELETE FROM events WHERE ID = ?;
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

