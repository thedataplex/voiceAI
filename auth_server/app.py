from flask import Flask, request, jsonify
import psycopg2

app = Flask(__name__)

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

if __name__ == '__main__':
    app.run(debug=True)
