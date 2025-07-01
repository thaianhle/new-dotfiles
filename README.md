
# 💻 Zero-Trust Dev Environment (AWS + Tailscale + Dotfiles)

Thiết lập môi trường dev Zero-Trust hoàn chỉnh trên GCP CentOS Stream 8. Tự động hoá toàn bộ: cài AWS CLI proxy qua Tailscale, Docker, Zsh, kubectl và đồng bộ dotfiles cá nhân.

---

## 📁 Cấu trúc thư mục

```
new-dotfiles/
├── boot_instance.sh         # Script tạo VM CentOS Stream 8 (GCP)
├── install.sh               # Script cài đặt toàn bộ (local & server)
├── aws_proxy.py             # Flask server: cung cấp temporary AWS credentials
├── home/
│   ├── .zshrc               # Zsh config
│   └── .windsurf            # Tùy chỉnh cho môi trường code (ex: Windsurf IDE)
├── .aws/
│   └── config               # AWS profile sử dụng `credential_process` với proxy
```

---

## 🧠 Chức năng chính

| Tính năng | Mô tả |
|----------|------|
| ✅ `install.sh local_setup` | Thiết lập từ laptop: tạo SSH key, tạo GCP VM, đồng bộ dotfiles, khởi chạy Tailscale và proxy |
| ✅ `install.sh setup_server` | Cài đặt server từ dotfiles: AWS CLI, Docker, kubectl, Zsh, Tailscale |
| ✅ `aws_proxy.py` | Flask server cung cấp AWS credentials để AWS CLI hoạt động bảo mật qua Tailscale |
| ✅ Tailscale tunnel | Tunnel giữa local ↔️ server không cần mở port |

---

## 🚀 Cách sử dụng

### 1. Clone repo và khởi chạy setup

```bash
git clone https://github.com/<your-user>/new-dotfiles.git
cd new-dotfiles
chmod +x install.sh
./install.sh local_setup
```

> Script sẽ:
> - Tạo SSH key nếu chưa có
> - Tạo Spot VM CentOS trên GCP
> - Khởi chạy Tailscale và lấy IP
> - Cập nhật `.aws/config` với Tailscale IP
> - Rsync dotfiles lên server
> - SSH vào server và chạy `setup_server`

---

### 2. Kiểm tra kết nối & công cụ

**Trên máy local:**

```bash
curl http://localhost:8080/aws-credentials
tailscale status
```

**Trên VM:**

```bash
aws sts get-caller-identity --profile sre-proxy
docker ps
kubectl version
tailscale status
```

---

## 🧩 Thành phần chi tiết

| Script | Mô tả |
|--------|------|
| `boot_instance.sh` | Dùng `gcloud compute` để tạo VM CentOS 8 |
| `aws_proxy.py` | Flask server giả lập `credential_process` để cung cấp AWS session credentials |
| `bootstrap.sh` | Tự động hóa cả local và remote setup |
| `.aws/config` | AWS profile trỏ về Tailscale IP, ví dụ: `http://100.x.y.z:8080/aws-credentials` |

---

## ⚠️ Lưu ý bảo mật

- **SSH Key**: Không commit file `~/.ssh/gcp_key` vào Git. Set `chmod 600`.
- **Tailscale IP**: Nếu thay đổi, cần chạy lại:  
  ```bash
  ./bootstrap.sh local_setup
  ```
- **Proxy port 8080**: Đảm bảo mở trên laptop nếu dùng từ xa.
- **Spot VM**: Có thể bị GCP xóa bất kỳ lúc nào. Kiểm tra bằng:
  ```bash
  gcloud compute instances list
  ```

---

## 🔄 Tái chạy hoặc sửa cấu hình

Nếu bạn cần cài lại server thủ công:

```bash
gcloud compute ssh $USER@centos-vm --zone=asia-southeast1-b
cd ~/new-dotfiles
chmod +x install.sh
./install.sh setup_server
```

---

✍️ *Built for DevOps – bảo mật, đơn giản, không port public.*
