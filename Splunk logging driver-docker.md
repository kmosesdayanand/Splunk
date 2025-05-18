
# 🐳 Docker Splunk Log Driver – Notes

## 🔧 Purpose
The Splunk log driver enables Docker containers to send logs directly to a Splunk Enterprise or Splunk Cloud instance over HTTP Event Collector (HEC).

---

## 🛠️ Configuration Requirements

### 1. Enable HEC on Splunk
- Go to **Settings → Data Inputs → HTTP Event Collector**.
- Create a new token (e.g., `docker-logs-token`).
- Enable HEC and **set index, source type**, etc.
- Ensure Splunk is listening on port **8088** (or a custom port).
- Don't forget to enable the HEC in Global Settings.

### 2. Test HEC Token (Optional but Useful)
Use `curl` to validate:
```bash
curl -k https://<splunk-host>:8088/services/collector \
  -H "Authorization: Splunk <token>" \
  -d '{"event": "hello world"}'
```

---

## 🐋 Using the Splunk Log Driver in Docker

### 🔹 Option 1: Per-Container Logging
```bash
docker run -d \
  --log-driver=splunk \
  --log-opt splunk-token=<token> \
  --log-opt splunk-url=https://<splunk-host>:8088 \
  --log-opt splunk-insecureskipverify=true \
  --log-opt splunk-index=<index> \
  --log-opt tag="{{.Name}}" \
  --name test-container \
  alpine echo "hello from docker"
```

### 🔹 Option 2: Set Default Log Driver (Optional)
Edit or create `/etc/docker/daemon.json`:
```json
{
  "log-driver": "splunk",
  "log-opts": {
    "splunk-token": "<token>",
    "splunk-url": "https://<splunk-host>:8088",
    "splunk-insecureskipverify": "true",
    "splunk-index": "<index>"
  }
}
```

Restart Docker:
```bash
sudo systemctl restart docker
```

---

## 🧩 Optional Log Options

| Option                      | Description                                      |
|----------------------------|--------------------------------------------------|
| `splunk-token`             | Required HEC token                               |
| `splunk-url`               | Splunk HEC endpoint                              |
| `splunk-index`             | Index to store logs                              |
| `splunk-sourcetype`        | Sourcetype of logs (e.g., `docker:json`)         |
| `splunk-insecureskipverify`| Bypass TLS verification (not for production!)    |
| `tag`                      | Log tag format (e.g., `{{.Name}}`)               |

[Official Docker Splunk Log Driver Docs](https://docs.docker.com/engine/logging/drivers/splunk/)

---
