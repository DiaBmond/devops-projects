from django.test import Client
import json

def test_hello_endpoint_status():
    client = Client()
    response = client.get('/')
    assert response.status_code == 200
    
# def test_hello_endpoint_content():
#     client = Client()
#     response = client.get('/')
#     data = json.loads(response.content)
#     assert 'message' in data
#     assert data['message'] == 'Hello World from Dockerized App!'