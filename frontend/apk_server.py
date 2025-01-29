from flask import Flask, send_file
import qrcode
import os

app = Flask(__name__)

@app.route("/")
def serve_qr():
    url = f"http://{os.environ.get('HOST_IP', 'localhost')}:{os.environ.get('PORT', '8765')}/download"
    img = qrcode.make(url)
    img.save("qr.png")
    return send_file("qr.png")

@app.route("/download")
def download():
    return send_file("android/app/build/outputs/apk/debug/app-debug.apk")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 8765)))