<?php

include_once("../config.php");

class address_gateway {

    private $db = null;

    public function __construct() {
        $this->db = new PDO("mysql:host=".DB_SERVER.";dbname=".DB_NAME."", DB_USER, DB_PASS);
    }

    // Insert a Address into the database
    public function insert(Array $data) {
        $duplicate = $this->retrieve_by_properties($data);
        if ($duplicate) {
            return $duplicate['ID'];
        }

        $stmt = "
            INSERT INTO addresses 
                (street, nr, postalcode, region, country, latitude, longitude)
            VALUES
                (:street, :nr, :postalcode, :region, :country, :latitude, :longitude);
        ";

        try {
            $stmt = $this->db->prepare($stmt);
            $stmt->execute(array(
                'street' => $data['street'],
                'nr' => $data['nr'],
                'postalcode' => $data['postalcode'],
                'region' => $data['region'],
                'country' => $data['country'],
                'latitude' => $data['latitude'],
                'longitude' => $data['longitude'],
            ));

            return $this->db->lastInsertId();
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }
    }

    // Retrieve all Addresses from the database
    public function retrieve_all() {
        $stmt = "
            SELECT
                ID, street, nr, postalcode, region, country, latitude, longitude
            FROM
                addresses;
        ";

        try {
            $stmt = $this->db->query($stmt);

            return $stmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }
    }

    // Retrieve specific Address from database
    public function retrieve($id) {
        $stmt = "
            SELECT
                ID, street, nr, postalcode, region, country, latitude, longitude
            FROM
                addresses
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
    
    // Retrieve Addresses by a column from database
    public function retrieve_by($column, $id) {
        // Not implemented for Address
        http_response_code(404);
        exit();
    }

    // Retrieve a Address from the database by properties
    public function retrieve_by_properties(Array $data) {
        $stmt = "
            SELECT
                ID, street, nr, postalcode, region, country, latitude, longitude
            FROM
                addresses
            WHERE 
                street = :street AND 
                nr = :nr AND 
                postalcode = :postalcode AND
                region = :region;
        ";
        
        try {
            $stmt = $this->db->prepare($stmt);
            $stmt->execute(array(
                'street' => $data['street'],
                'nr' => $data['nr'],
                'postalcode' => $data['postalcode'],
                'region' => $data['region'],
            ));

            return $stmt->fetch(PDO::FETCH_ASSOC);
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }
    }

    // Update a Address in the database
    public function update($id, Array $data) {
        $stmt = "
            UPDATE addresses
            SET
                street = :street,
                nr = :nr,
                postalcode = :postalcode,
                region = :region,
                country = :country,
                latitude = :latitude,
                longitude = :longitude
            WHERE
                ID = :ID;
        ";

        try {
            $stmt = $this->db->prepare($stmt);
            $stmt->execute(array(
                'ID' => (int)$id,
                'street' => $data['street'],
                'nr' => $data['nr'],
                'postalcode' => $data['postalcode'],
                'region' => $data['region'],
                'country' => $data['country'],
                'latitude' => $data['latitude'],
                'longitude' => $data['longitude'],
            ));

            return $stmt->rowCount();
        } catch (PDOException $e) {
            http_response_code(500);
            exit($e->getMessage());
        }
    }

    // Delete a Address from the database
    public function delete($id) {
        $stmt = "
            DELETE FROM addresses WHERE ID = ?;
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

