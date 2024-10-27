import pandas as pd
import numpy as np
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import StandardScaler
from flask import Flask, request, jsonify

# Load the dataset
file_path = 'synthetic_ride_data.csv'
ride_data = pd.read_csv(file_path)

# Preprocessing
X = ride_data[['trip_distance', 'trip_duration']]
y = ride_data['fare_amount']

# Scale the features
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Train the model
model = LinearRegression()
model.fit(X_scaled, y)

# Create a Flask app
app = Flask(__name__)


@app.route('/predict_fare', methods=['POST'])
def predict_fare():
    data = request.get_json()

    try:
        # Extract distance and duration from the request
        distance = data['trip_distance']
        duration = data['trip_duration']

        # Scale the input
        input_data = np.array([[distance, duration]])
        input_scaled = scaler.transform(input_data)

        # Make prediction
        predicted_fare = model.predict(input_scaled)

        # Return the result
        return jsonify({'fare_amount': predicted_fare[0]})

    except KeyError:
        return jsonify({'error': 'Please provide both trip_distance and trip_duration'}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500


if __name__ == '__main__':
    app.run(port=(5003),debug=True)