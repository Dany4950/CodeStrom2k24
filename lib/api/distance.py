from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

# Replace with your actual Google Maps API key
GOOGLE_MAPS_API_KEY = "AIzaSyC9umgoAPl5MvYznmZpmKX3Lv5Lvg9a3Rg"

@app.route('/distance', methods=['GET'])
def get_distance():
    # Get coordinates from query parameters
    origin = request.args.get('origin')
    destination = request.args.get('destination')
    
    if not origin or not destination:
        return jsonify({'error': 'Please provide both origin and destination coordinates.'}), 400
    
    # Make a request to the Google Distance Matrix API
    url = f'https://maps.googleapis.com/maps/api/distancematrix/json?origins={origin}&destinations={destination}&key={GOOGLE_MAPS_API_KEY}'
    response = requests.get(url)
    data = response.json()

    if data['status'] != 'OK':
        return jsonify({'error': data.get('error_message', 'Error fetching distance.')}), 500
    
    # Extract distance and duration
    try:
        distance = data['rows'][0]['elements'][0]['distance']['text']
        duration = data['rows'][0]['elements'][0]['duration']['text']
    except (IndexError, KeyError):
        return jsonify({'error': 'Could not find distance or duration.'}), 500
    
    return jsonify({
        'origin': origin,
        'destination': destination,
        'distance': distance,
        'duration': duration
    })

if __name__ == '__main__':
    app.run(port=(5002),debug=True)
