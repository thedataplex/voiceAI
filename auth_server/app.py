from flask import Flask, request, jsonify
import psycopg2
from flask_cors import CORS
from datetime import datetime
from dotenv import load_dotenv
import os
from dateutil import parser

load_dotenv()

app = Flask(__name__)
CORS(app)

# Get DATABASE_URL from environment variables
DATABASE_URL = os.getenv("DATABASE_URL")

# Determine if connection is to a local database
is_local_db = "localhost" in DATABASE_URL or "127.0.0.1" in DATABASE_URL

# Connect with or without SSL mode based on the database location
if is_local_db:
    conn = psycopg2.connect(DATABASE_URL)
else:
    conn = psycopg2.connect(DATABASE_URL, sslmode='require')
    
cursor = conn.cursor()

@app.route('/register', methods=['POST'])
def register():
    data = request.json
    username = data['username']
    password = data['password']
    
    if not username or not password:
        return jsonify({'error': 'Username and password are required'}), 400
    
    try:
        cursor.execute("INSERT INTO login (username, password) VALUES (%s, %s)", (username, password))
        conn.commit()
        return jsonify({'message': 'User registered successfully'}), 201
    except psycopg2.IntegrityError:
        conn.rollback()  # Rollback the failed transaction to reset the DB state
        return jsonify({'error': 'Username already exists'}), 409
    except Exception as e:
        conn.rollback()
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
    dob_input = data['dob']
    try:
        dob = parser.parse(dob_input).date()
        formatted_dob = dob.strftime('%Y-%m-%d')
    except ValueError as e:
        return jsonify({'error': 'Invalid date format. Please use a recognizable date format.'}), 400

    raw_ssn = data['ssn']
    digits_only_ssn = ''.join(filter(str.isdigit, raw_ssn))
    formatted_ssn = f"{digits_only_ssn[:3]}-{digits_only_ssn[3:5]}-{digits_only_ssn[5:9]}"

    zip_code = data['zip_code']

    # Check if record already exists
    cursor.execute("""
        SELECT * FROM records WHERE 
        first_name = %s AND last_name = %s AND dob = %s AND ssn = %s AND zip_code = %s
        """, (first_name, last_name, formatted_dob, formatted_ssn, zip_code))

    if cursor.fetchone():
        return jsonify({'message': 'Record already exists'}), 409  # 409 Conflict
    
    # Insert the record if it doesn't exist
    try:
        cursor.execute("INSERT INTO records (first_name, last_name, dob, ssn, zip_code) VALUES (%s, %s, %s, %s, %s) RETURNING id",
                       (first_name, last_name, formatted_dob, formatted_ssn, zip_code))
        record_id = cursor.fetchone()[0]
        conn.commit()
        return jsonify({'message': 'Record saved successfully', 'id': record_id}), 201
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
