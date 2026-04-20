from flask import Flask, request, jsonify
import mysql.connector

app = Flask(__name__)

# MySQL connection details
def get_db_connection():
    return mysql.connector.connect(
        host="localhost",  # Change to your host
        user="root",       # Change to your MySQL username
        password="priyadharshini",  # Change to your MySQL password
        database="elderhaven"
    )

@app.route('/doctor_login', methods=['POST'])
def doctor_login():
    # Get the email and password from the request
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    # Connect to the database
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Query to check if the email exists in the doctors table
    cursor.execute("SELECT * FROM doctors WHERE email = %s", (email,))
    doctor = cursor.fetchone()

    if doctor:
        # Check if the password matches
        if doctor['password'] == password:  # Assuming plain text password
            return jsonify({'message': 'Login successful', 'status': 'success'}), 200
        else:
            return jsonify({'message': 'Invalid password', 'status': 'error'}), 400
    else:
        return jsonify({'message': 'Doctor not found', 'status': 'error'}), 400


@app.route('/doctor_signup', methods=['POST'])
def doctor_signup():
    # Get the data from the request
    data = request.get_json()
    name = data.get('name')
    email = data.get('email')
    password = data.get('password')
    specialization = data.get('specialization')
    contact_number = data.get('contact_number')
    location = data.get('location')

    # Connect to the database
    conn = get_db_connection()
    cursor = conn.cursor()

    # Check if the email already exists in the doctors table
    cursor.execute("SELECT * FROM doctors WHERE email = %s", (email,))
    existing_doctor = cursor.fetchone()
    if existing_doctor:
        return jsonify({'message': 'Doctor with this email already exists', 'status': 'error'}), 400

    # Insert the new doctor's details into the database
    cursor.execute("""
        INSERT INTO doctors (name, email, password, specialization, contact_number, location)
        VALUES (%s, %s, %s, %s, %s, %s)
    """, (name, email, password, specialization, contact_number, location))

    conn.commit()

    # Return success message
    return jsonify({'message': 'Doctor registered successfully', 'status': 'success'}), 200


if __name__ == '__main__':
    app.run(debug=True)
