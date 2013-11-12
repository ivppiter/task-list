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

        readTaskResp = requests.get(self.base_url + taskResp.headers['Location'])
        self.assertEqual(readTaskResp.status_code, 200)

    def test_update_task_updates(self):
        createListResp = requests.post(self.list_url, data = json.dumps({"title": "Test Edit Task List"}), headers=self.json_headers)
        self.assertEqual(createListResp.status_code, 201)
        url = self.base_url + createListResp.headers['Location']
        resp2 = requests.get(url)
        self.assertEqual(resp2.status_code, 200)

        taskResp = requests.post(url + '/tasks', data = json.dumps({"title": "test create task", "is_complete":False}), headers=self.json_headers)
        self.assertEqual(taskResp.status_code, 201)

        taskUrl = self.base_url + taskResp.headers['Location']
        upResp = requests.put(taskUrl, data = json.dumps({"title": "test update", "is_complete": True}), headers=self.json_headers)
        self.assertEqual(upResp.status_code, 200)

    def test_delete_task_deletes(self):
        createListResp = requests.post(self.list_url, data = json.dumps({"title" : "Test Delete Task List"}), headers=self.json_headers)
        createTaskUrl = self.base_url + createListResp.headers['Location'] + '/tasks'
        taskResp = requests.post(createTaskUrl, data = json.dumps({"title" : "Test Delete Task", "is_complete" : False}), headers=self.json_headers)
        taskUrl = self.base_url + taskResp.headers['Location']

        deleteResp = requests.delete(taskUrl)
        self.assertEqual(deleteResp.status_code, 204)
        resp = requests.get(taskUrl)
        self.assertEqual(resp.status_code, 404)
