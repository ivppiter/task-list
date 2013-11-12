#!/usr/bin/python
import requests
import unittest
import json

class TestTaskApi(unittest.TestCase):
    def setUp(self):
        self.base_url = 'http://localhost:8000'
        self.list_url = self.base_url + '/list'
        self.json_headers = {"Content-Type" : "application/json", "Accept" : "application/json"}

    def test_create_task_creates(self):
        createListResp = requests.post(self.list_url, data = json.dumps({"title": "Test Create List"}), headers=self.json_headers)
        self.assertEqual(createListResp.status_code, 201)
        url = self.base_url + createListResp.headers['Location']
        resp2 = requests.get(url)
        self.assertEqual(resp2.status_code, 200)

        taskResp = requests.post(url + '/tasks', data = json.dumps({"title": "test create task", "is_complete":False}), headers=self.json_headers)
        self.assertEqual(taskResp.status_code, 201)

