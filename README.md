# tcpsocketapp

# 📡 Flutter to Python TCP Image Uploader

This project demonstrates a simple yet powerful system where a **Flutter app uploads an image to a Python server via raw TCP sockets**, and the image is then accessible via a **browser-friendly HTTP server**.

---

## 🔧 Features

- 📤 Upload image from Flutter app using TCP
- 🐍 Python TCP server receives and stores the image
- 🌐 HTTP interface to view or download uploaded images
- 🖼️ Images are saved in `received/` and accessible at `http://<server-ip>:8000/images/<filename>`

---

## 📱 Flutter Client

### 🔹 What it does
The Flutter client selects an image and sends:
- Filename
- File size
- Raw image data (in bytes)

### 🔹 How to run

1. Clone this repo
2. Open the Flutter project
3. Add required permissions (especially for file picker and internet access)
4. Call the `connect()` function in your `SocketHelper` with your server's IP and port (e.g., `192.168.1.50`, `9999`)
5. Select an image and send it

> 🔐 Tip: Use local IPs (like `192.168.x.x`) and ensure you're on the **same Wi-Fi** as the server.

---

## 🐍 Python Server

### 🔹 What it does

- Listens for TCP connections
- Receives image metadata and binary data
- Saves image to `received/` directory
- Simultaneously runs a Flask HTTP server to browse/download the image

### 🔹 How to run

```bash
pip install flask
python server.py
