#!/usr/bin/python
import requests
import unittest

class TestRootApi(unittest.TestCase):
    def setUp(self):
        self.test_url = 'http://localhost:8000'

    def test_get_root_succeeds(self):
        url = self.test_url
        response = requests.get(url)
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.content, '<html><body>Hello, new world</body></html>')
