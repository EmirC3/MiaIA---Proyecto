import pymysql
import pymysql.cursors
from flask import Flask, request, jsonify
import bcrypt

api = Flask(__name__)

db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '1234',
    'database': 'MIAIA',
    'cursorclass': pymysql.cursors.DictCursor
}

def get_db_connection():
    try:
        connection = pymysql.connect(**db_config)
        return connection
    except pymysql.MySQLError as e:
        print(f"Error connecting to Database: {e}")
        return None


# -----------------------------------------------------------
#                      ENDPOINT DE USUARIOS
# -----------------------------------------------------------

@api.route('/api/register/user', methods=['POST'])
def register_user():
    data = request.json
    nombre = data.get('nombre')
    apellido = data.get('apellido')
    nombre_user = data.get('nombreuser')
    genero = data.get('genero')
    password = data.get('contraseña')
    
    if not all([nombre, apellido, nombre_user, genero, password]):
        return jsonify({"message": "Faltan campos obligatorios"}), 400

    salt = bcrypt.gensalt()
    hashed_password = bcrypt.hashpw(password.encode('utf-8'), salt)
    
    conn = get_db_connection()
    if not conn: return jsonify({"message": "Fallo DB"}), 500

    try:
        with conn.cursor() as cur:
            cur.execute("INSERT INTO USUARIOS (NOMBRE, APELLIDO, NOMBREUSER, GENERO, CONTRASEÑA) VALUES (%s, %s, %s, %s, %s)", (nombre, apellido, nombre_user, genero, hashed_password))
        conn.commit()
        return jsonify({"message": "Cliente registrado exitosamente"}), 201
    except Exception as e:
        return jsonify({"message": f"Registro fallido: {str(e)}"}), 409
    finally:
        conn.close()

@api.route('/api/login/user', methods=['POST'])
def login_user():
    data = request.json
    nombre_user = data.get('nombreuser')
    password = data.get('contraseña')

    if not all([nombre_user, password]):
        return jsonify({"message": "Falta usuario o contraseña"}), 400
        
    conn = get_db_connection()
    if not conn: return jsonify({"message": "Fallo DB"}), 500

    try:
        with conn.cursor() as cur:
            cur.execute("SELECT NOMBRE, CONTRASEÑA FROM USUARIOS WHERE NOMBREUSER = %s", [nombre_user])
            user_record = cur.fetchone()
        
        if user_record:
            stored_hash = user_record['CONTRASEÑA']
            if isinstance(stored_hash, str): stored_hash = stored_hash.encode('utf-8')

            if bcrypt.checkpw(password.encode('utf-8'), stored_hash):
                return jsonify({
                    "message": "Login exitoso", 
                    "user_type": "user",
                    "nombre": user_record['NOMBRE']
                }), 200
            else:
                return jsonify({"message": "Credenciales inválidas"}), 401
        else:
            return jsonify({"message": "Usuario no encontrado"}), 401
    finally:
        conn.close()

if __name__ == '__main__':
    api.run(host='0.0.0.0', port=5000, debug=True)