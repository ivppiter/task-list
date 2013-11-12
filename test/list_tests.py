#!/usr/bin/python
import requests
import unittest
import json

class TestListApi(unittest.TestCase):
    def setUp(self):
        self.base_url = 'http://localhost:8000'
        self.test_url = self.base_url + '/list'
        self.json_headers = {"Content-Type" : "application/json", "Accept" : "application/json"}

    def test_get_list_succeeds(self):
        response = requests.get(self.test_url)
        self.assertEqual(response.status_code, 200)

    def test_get_list_not_found(self):
        response = requests.get(self.test_url + '/10')
        self.assertEqual(response.status_code, 404)

    def test_post_list_created(self):
        response = requests.post(self.test_url, data = json.dumps({"title": "Test One"}), headers=self.json_headers)
        self.assertEqual(response.status_code, 201)

        resp2 = requests.get(self.base_url + response.headers['Location'])
        self.assertEqual(resp2.status_code, 200)

    def test_put_list_updates(self):
        create_resp = requests.post(self.test_url, data = json.dumps({"title" : "Test Created"}), headers=self.json_headers)
        self.assertEqual(create_resp.status_code, 201)

        get_resp = requests.get(self.base_url + create_resp.headers['Location'])
        self.assertEqual(get_resp.status_code, 200)

        update_resp = requests.put(self.base_url + create_resp.headers['Location'], data = json.dumps({"title" : "Updated field"}), headers=self.json_headers)
        self.assertEqual(update_resp.status_code, 200)
