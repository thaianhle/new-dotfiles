from flask import Flask, jsonify
import os
import json
import pathlib

app = Flask(__name__)

@app.route('/aws-credentials')
def serve_credentials():
    # Tìm credential cache của AWS SSO
    cache_dir = os.path.expanduser("~/.aws/cli/cache")
    latest_file = sorted(
        pathlib.Path(cache_dir).glob("*.json"),
        key=lambda p: p.stat().st_mtime,
        reverse=True
    )[0]
    with open(latest_file) as f:
        creds = json.load(f)["Credentials"]

    return jsonify({
        "Version": 1,
        "AccessKeyId": creds["AccessKeyId"],
        "SecretAccessKey": creds["SecretAccessKey"],
        "SessionToken": creds["SessionToken"],
        "Expiration": creds["Expiration"]
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
