<?php

class controller {
    
    private $reqMethod;
    private $id;
    private $column;

    private $gateway;

    public function __construct($reqMethod, $gateway, $id, $column) {
        $this->reqMethod = $reqMethod;
        $this->id = $id;
        $this->column = $column;
    
        $this->gateway = $gateway;
    }

    public function process_request() {
        switch ($this->reqMethod) {
            case 'GET':
                if ($this->column) {
                    $res = $this->get_by($this->column, $this->id);
                } else if ($this->id) {
                    $res = $this->get($this->id);
                } else {
                    $res = $this->get_all();
                }
                break;
            case 'POST':
                $res = $this->create();
                break;
            case 'PUT':
                $res = $this->update($this->id);
                break;
            case 'DELETE':
                $res = $this->delete($this->id);
                break;
            default:
                $res = $this->not_found();
                break;
        }

        header($res['status_code_header']);
        if ($res['body']) {
            echo $res['body'];
        }
    }

    private function not_found() {
        $res['status_code_header'] = 'HTTP/1.1 404 Not Found';
        $res['body'] = null;
        return $res;
    }

    private function create() {
        $data = (array)json_decode(file_get_contents('php://input'), TRUE);
        $id = $this->gateway->insert($data);
        
        $res['status_code_header'] = 'HTTP/1.1 201 Created';
        $res['body'] = $id;
        return $res;
    }

    private function get_all() {
        $result = $this->gateway->retrieve_all();
        $res['status_code_header'] = 'HTTP/1.1 200 OK';
        $res['body'] = json_encode($result);
        return $res;
    }

    private function get($id) {
        $result = $this->gateway->retrieve($id);
        if (!$result) {
            return $this->not_found();
        }

        $res['status_code_header'] = 'HTTP/1.1 200 OK';
        $res['body'] = json_encode($result);
        return $res;
    }
    
    private function get_by($column, $id) {
        $result = $this->gateway->retrieve_by($column, $id);
        if (!$result) {
            return $this->not_found();
        }

        $res['status_code_header'] = 'HTTP/1.1 200 OK';
        $res['body'] = json_encode($result);
        return $res;
    }

    private function update($id) {
        $result = $this->gateway->retrieve($id);
        if (!$result) {
            return $this->not_found();
        }

        $data = (array)json_decode(file_get_contents('php://input'), TRUE);
        $this->gateway->update($id, $data);

        $res['status_code_header'] = 'HTTP/1.1 200 OK';
        $res['body'] = null;
        return $res;
    }

    private function delete($id) {
        $result = $this->gateway->retrieve($id);
        if (!$result) {
            return $this->not_found();
        }

        $this->gateway->delete($id);

        $res['status_code_header'] = 'HTTP/1.1 200 OK';
        $res['body'] = null;
        return $res;
    }

}
