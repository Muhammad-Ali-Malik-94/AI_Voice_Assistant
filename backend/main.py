import os
import json
from flask import Flask, request, jsonify
import functions_framework
import vertexai
from vertexai.preview.generative_models import GenerativeModel

app = Flask(__name__)

# Load credentials and initialize
credentials_path = os.environ.get('GOOGLE_APPLICATION_CREDENTIALS', 'key.json')
with open(credentials_path) as f:
    project_info = json.load(f)
    project_id = project_info["project_id"]

# Initialize Vertex AI
vertexai.init(project=project_id, location="us-central1")

@functions_framework.http
def chat(request):
    if request.method == 'OPTIONS':
        headers = {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'POST',
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Max-Age': '3600'
        }
        return ('', 204, headers)

    headers = {'Access-Control-Allow-Origin': '*'}

    try:
        request_json = request.get_json()
        if not request_json or 'message' not in request_json:
            return jsonify({'error': 'No message provided'}), 400, headers

        # Initialize the model - using gemini-2.0-flash-lite which is the latest stable model
        model = GenerativeModel("gemini-2.0-flash")
        chat = model.start_chat()

        # Send message and get response
        response = chat.send_message(request_json['message'])

        return jsonify({
            'response': response.text
        }), 200, headers

    except Exception as e:
        return jsonify({'error': str(e)}), 500, headers

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    app.run(host='0.0.0.0', port=port)