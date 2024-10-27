from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///users.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)


class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(120), nullable=False)
    institution = db.Column(db.String(120), nullable=False)
    phone = db.Column(db.String(20), nullable=False)
    is_rider = db.Column(db.Boolean, default=True)  # True for Rider, False for Pooler


@app.route('/api/signup', methods=['POST'])
def signup():
    data = request.json
    required_fields = ['username', 'email', 'password', 'institution', 'phone', 'is_rider']
    if not all(field in data for field in required_fields):
        return jsonify({"error": "Missing required fields"}), 400
    
    
    existing_user = User.query.filter_by(email=data['email']).first()
    if existing_user:
        return jsonify({"error": "Email already registered"}), 400

    new_user = User(
        username=data['username'],
        email=data['email'],
        password=data['password'],
        institution=data['institution'],
        phone=data['phone'],
        is_rider=data['is_rider']
    )
    db.session.add(new_user)
    db.session.commit()
    return jsonify({"message": "User created successfully"}), 201

@app.route('/api/user/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    user = User.query.get(user_id)
    if not user:
        return jsonify({"error": "User not found"}), 404
    db.session.delete(user)
    db.session.commit()
    return jsonify({"message": "User deleted successfully"}), 200

@app.route('/api/user/<int:user_id>', methods=['GET'])
def get_user(user_id):
    user = User.query.get(user_id)
    if user is None:
        return jsonify({"error": "User not found"}), 404
    
    user_data = {
        "id": user.id,
        "username": user.username,
        "email": user.email,
        "institution": user.institution,
        "phone": user.phone,
        "is_rider": user.is_rider
    }
    return jsonify(user_data), 200
@app.route('/api/login', methods=['POST'])
def login():
    data = request.json
    required_fields = ['email', 'password']
    if not all(field in data for field in required_fields):
        return jsonify({"error": "Missing required fields"}), 400

    user = User.query.filter_by(email=data['email']).first()
    if user is None or user.password != data['password']:
        return jsonify({"error": "Invalid credentials"}), 401

    user_data = {
        "id": user.id,
        "username": user.username,
        "email": user.email,
        "institution": user.institution,
        "phone": user.phone,
        "is_rider": user.is_rider
    }
    return jsonify(user_data), 200



if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True)