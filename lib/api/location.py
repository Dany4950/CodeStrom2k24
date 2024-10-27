from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///locations.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)


class UserLocation(db.Model):
    __tablename__ = 'user_locations'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, nullable=False)  # Assuming user ID is provided
    current_latitude = db.Column(db.Float, nullable=False)
    current_longitude = db.Column(db.Float, nullable=False)
    destination_latitude = db.Column(db.Float, nullable=False)
    destination_longitude = db.Column(db.Float, nullable=False)
    timestamp = db.Column(db.DateTime, default=datetime.utcnow)


@app.route('/api/location', methods=['POST'])
def store_location():
    data = request.json
    required_fields = ['user_id', 'current_latitude', 'current_longitude', 'destination_latitude',
                       'destination_longitude']

    if not all(field in data for field in required_fields):
        return jsonify({"error": "Missing required fields"}), 400

    user_location = UserLocation(
        user_id=data['user_id'],
        current_latitude=data['current_latitude'],
        current_longitude=data['current_longitude'],
        destination_latitude=data['destination_latitude'],
        destination_longitude=data['destination_longitude']
    )

    db.session.add(user_location)
    db.session.commit()
    return jsonify({"message": "Location stored successfully"}), 201


@app.route('/api/location/<int:user_id>', methods=['GET'])
def get_user_location(user_id):
    # Retrieve the latest location for the user
    location = UserLocation.query.filter_by(user_id=user_id).order_by(UserLocation.timestamp.desc()).first()

    if location is None:
        return jsonify({"error": "Location not found"}), 404

    location_data = {
        "user_id": location.user_id,
        "current_latitude": location.current_latitude,
        "current_longitude": location.current_longitude,
        "destination_latitude": location.destination_latitude,
        "destination_longitude": location.destination_longitude,
        "timestamp": location.timestamp
    }
    return jsonify(location_data), 200


if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)