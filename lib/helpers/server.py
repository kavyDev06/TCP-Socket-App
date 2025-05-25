import socket
import os
from flask import Flask, send_from_directory, jsonify
import threading

# TCP Server Configuration
TCP_HOST = '0.0.0.0'
TCP_PORT = 9999
BUFFER_SIZE = 4096

# Create folder for received files
os.makedirs("received", exist_ok=True)

# Flask app for browsing images
app = Flask(__name__)

@app.route('/')
def index():
    files = os.listdir('received')
    return jsonify({"images": files})

@app.route('/images/<filename>')
def get_image(filename):
    return send_from_directory('received', filename)

def start_http_server():
    app.run(host='0.0.0.0', port=8000)  # HTTP server on port 8000

def start_tcp_server():
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind((TCP_HOST, TCP_PORT))
        s.listen(5)
        print(f"📡 TCP Server listening on {TCP_HOST}:{TCP_PORT}")

        while True:
            conn, addr = s.accept()
            print(f"📥 Connection from {addr}")
            handle_client(conn)

def handle_client(conn):
    try:
        name_len = int.from_bytes(conn.recv(4), byteorder='big')
        filename = conn.recv(name_len).decode()
        file_size = int.from_bytes(conn.recv(8), byteorder='big')

        print(f"Receiving {filename} ({file_size} bytes)")
        received = 0
        with open(f"received/{filename}", 'wb') as f:
            while received < file_size:
                data = conn.recv(min(BUFFER_SIZE, file_size - received))
                if not data:
                    break
                f.write(data)
                received += len(data)
        print(f"✅ Saved to received/{filename}")
    except Exception as e:
        print(f"❌ Error: {e}")
    finally:
        conn.close()

if __name__ == "__main__":
    threading.Thread(target=start_http_server, daemon=True).start()
    start_tcp_server()
