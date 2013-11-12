#!/usr/bin/python
import requests
import unittest

class TestListApi(unittest.TestCase):
    def setUp(self):
        self.test_url = 'http://localhost:8000/list'

    def test_get_list_succeeds(self):
        response = requests.get(self.test_url)
        self.assertEqual(response.status_code, 200)
