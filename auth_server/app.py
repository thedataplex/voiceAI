from flask import Flask, request, jsonify
import psycopg2
from flask_cors import CORS
from datetime import datetime

app = Flask(__name__)
CORS(app)

# Database connection
conn = psycopg2.connect(
    dbname='postgres',
    user='postgres',
    password='Stocker@365',
    host='localhost'
)
cursor = conn.cursor()

@app.route('/register', methods=['POST'])
def register():
    data = request.json
    username = data['username']
    password = data['password']
    try:
        cursor.execute("INSERT INTO login (username, password) VALUES (%s, %s)", (username, password))
        conn.commit()
        return jsonify({'message': 'User registered successfully'}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/login', methods=['POST'])
def login():
    data = request.json
    username = data['username']
    password = data['password']
    cursor.execute("SELECT * FROM login WHERE username = %s AND password = %s", (username, password))
    user = cursor.fetchone()
    if user:
        return jsonify({'message': 'Login successful'}), 200
    else:
        return jsonify({'message': 'Invalid username or password'}), 401


# Add a new route to handle saving records
@app.route('/save_record', methods=['POST'])
def save_record():
    data = request.json
    print("Received data:", data)
    first_name = data['first_name']
    last_name = data['last_name']
    dob = datetime.strptime(data['dob'], '%Y-%m-%d').date()  # Convert string to datetime object
    ssn = data['ssn']
    zip_code = data['zip_code']
    
    try:
        cursor.execute("INSERT INTO records (first_name, last_name, dob, ssn, zip_code) VALUES (%s, %s, %s, %s, %s) RETURNING id",
                       (first_name, last_name, dob, ssn, zip_code))
        record_id = cursor.fetchone()[0]
        conn.commit()
        # return jsonify({'message': 'Record saved successfully'}), 201
        return jsonify({'message': 'Record saved successfully', 'id': record_id}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
