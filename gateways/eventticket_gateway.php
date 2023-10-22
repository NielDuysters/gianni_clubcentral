<?php

include_once("../config.php");

class eventticket_gateway {

    private $db = null;

    public function __construct() {
        $this->db = new PDO("mysql:host=".DB_SERVER.";dbname=".DB_NAME."", DB_USER, DB_PASS);
    }

    // Insert a EventTicket into the database
    public function insert(Array $data) {
        $stmt = "
            INSERT INTO event_tickets 
                (event, title, price)
            VALUES
                (:event, :title, :price);
        ";

        try {
            $stmt = $this->db->prepare($stmt);
            $stmt->execute(array(
                'event' => (int)$data['event'],
                'title' => $data['title'],
                'price' => (double)$data['price'],
            ));

            return $this->db->lastInsertId();
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }
    }

    // Retrieve all EventTickets from the database
    public function retrieve_all() {
        $stmt = "
            SELECT
                ID, event, title, price
            FROM
                event_tickets;
        ";

        try {
            $stmt = $this->db->query($stmt);

            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }
    }

    // Retrieve specific EventTicket from database
    public function retrieve($id) {
        $stmt = "
            SELECT
                ID, event, title, price
            FROM
                event_tickets
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
    
    // Retrieve EventTickets by column from database
    public function retrieve_by($column, $id) {
        // $column must be a allowed column
        if (!in_array($column, array(
            "event",
        ))) {
            http_response_code(500);
            exit("Invalid foreign key");
        }

        $stmt = "
            SELECT
                ID, event, title, price
            FROM
                event_tickets
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

    // Update a EventTicket in the database
    public function update($id, Array $data) {
        $stmt = "
            UPDATE event_tickets
            SET
                event = :event,
                title = :title,
                price = :price
            WHERE
                ID = :ID;
        ";

        try {
            $stmt = $this->db->prepare($stmt);
            $stmt->execute(array(
                'ID' => (int)$id,
                'event' => (int)$data['event'],
                'title' => $data['title'],
                'price' => (double)$data['price'],
            ));

            return $stmt->rowCount();
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }
    }

    // Delete a EventTicket from the database
    public function delete($id) {
        $stmt = "
            DELETE FROM event_tickets WHERE ID = ?;
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

