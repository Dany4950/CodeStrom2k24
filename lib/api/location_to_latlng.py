import requests
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

API_KEY = 'AIzaSyDmfRpmTcMs5C-yNzD066ZJn7MmksnpxuM'

def get_coordinates(address, api_key):
    endpoint = "https://maps.googleapis.com/maps/api/geocode/json"
    params = {
        'address': address,
        'key': api_key
    }
    
    response = requests.get(endpoint, params=params)
    
    if response.status_code == 200:
        data = response.json()
        
        if data['status'] == 'OK':
            location = data['results'][0]['geometry']['location']
            return location['lat'], location['lng']
        else:
            return {"error": data['status']}
    else:
        return {"error": "Request failed with status code: {}".format(response.status_code)}

@app.route("/get_coordinates", methods=["GET"])
def coordinates():
    address = request.args.get('address')
    if not address:
        return jsonify({"error": "Address parameter is required."}), 400
    
    # Use the API key defined at the top of the file
    coordinates = get_coordinates(address, API_KEY)
    
    if isinstance(coordinates, tuple):
        return jsonify({"address": address, "coordinates": {"lat": coordinates[0], "lng": coordinates[1]}})
    else:
        return jsonify(coordinates), 400

if __name__ == "__main__":
    app.run(port=(5001),debug=True)