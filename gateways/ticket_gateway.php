<?php

include_once("../config.php");

class ticket_gateway {

    private $db = null;

    public function __construct() {
        $this->db = new PDO("mysql:host=".DB_SERVER.";dbname=".DB_NAME."", DB_USER, DB_PASS);
    }

    // Insert a Ticket into the database
    public function insert(Array $data) {
        $stmt = "
            INSERT INTO tickets
                (user, event_ticket, payment_id, payment_status, is_scanned, code)
            VALUES
                (:user, :event_ticket, :payment_id, LOWER(COALESCE(:payment_status, DEFAULT(payment_status))), :is_scanned, :code);
        ";

        try {
            $stmt = $this->db->prepare($stmt);
            $stmt->execute(array(
                'user' => (int)$data['user'],
                'event_ticket' => (int)$data['event_ticket'],
                'payment_id' => $data['payment_id'] ?? null,
                'payment_status' => $data['payment_status'] ?? null,
                'is_scanned' => (int)$data['is_scanned'] ?? null,
                'code' => $data['code'],
            ));

            return $this->db->lastInsertId();
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }
    }

    // Retrieve all Tickets from the database
    public function retrieve_all() {
        $stmt = "
            SELECT
                ID, user, event_ticket, payment_id, payment_status, is_scanned, code
            FROM
                tickets;
        ";

        try {
            $stmt = $this->db->query($stmt);

            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }
    }

    // Retrieve specific Ticket from database
    public function retrieve($id) {
        $stmt = "
            SELECT
                ID, user, event_ticket, payment_id, payment_status, is_scanned, code
            FROM
                tickets
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
    
    // Retrieve Tickets by a column from database
    public function retrieve_by($column, $id) {
        // $column must be allowed column
        if (!in_array($column, array(
            "user",
            "event_ticket"
        ))) {
            http_response_code(500);
            exit("Invalid foreign key");
        }

        $stmt = "
            SELECT
                ID, user, event_ticket, payment_id, payment_status, is_scanned, code
            FROM
                tickets
            WHERE " . $column . " = ?;
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

    // Update a Ticket in the database
    public function update($id, Array $data) {
        $stmt = "
            UPDATE tickets
            SET
                user = :user,
                event_ticket = :event_ticket,
                payment_id = :payment_id,
                payment_status = LOWER(COALESCE(:payment_status, DEFAULT(payment_status))),
                is_scanned = :is_scanned,
                code = :code
            WHERE
                ID = :ID;
        ";

        try {
            $stmt = $this->db->prepare($stmt);
            $stmt->execute(array(
                'ID' => (int)$id,
                'user' => (int)$data['user'],
                'event_ticket' => (int)$data['event_ticket'],
                'payment_id' => $data['payment_id'] ?? null,
                'payment_status' => $data['payment_status'] ?? null,
                'is_scanned' => (int)$data['is_scanned'] ?? null,
                'code' => $data['code'],
            ));

            return $stmt->rowCount();
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }
    }

    // Delete a Ticket from the database
    public function delete($id) {
        $stmt = "
            DELETE FROM tickets WHERE ID = ?;
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

