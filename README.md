# Sensitive Files List

This repository contains an extensive list of filenames and extensions commonly associated with sensitive information, such as passwords, API tokens, configuration details, or network-related data. This list can be used for security audits, penetration testing, or file-hunting purposes.

## 🚨 Disclaimer

This repository is intended **only for educational purposes and ethical use** in improving security. Unauthorized use of this list to search for sensitive files on systems you do not own or have explicit permission to test is strictly prohibited. The author does not assume any liability for misuse.

## 📂 Contents

The repository includes the following categories of files:

### 1. General Sensitive Files
- Passwords (e.g., `password.txt`, `pass.json`, `login.csv`)
- API keys and tokens (e.g., `api_keys.env`, `secrets.yaml`)
- Backup files (e.g., `.bak`, `.old`, `.tmp`)

### 2. Operating Systems
- **Windows**: Registry backups, RDP shortcuts, system logs, etc.
- **Linux**: Config files (e.g., `/etc/passwd`, `/etc/shadow`), SSH keys, etc.
- **macOS**: Keychains, `.plist` files, etc.

### 3. Application-Specific Files
- Web applications (e.g., `wp-config.php`, `.env`)
- Database dumps (e.g., `.sql`, `.db`)
- Developer tools (e.g., `.git-credentials`, `.npmrc`)

### 4. Network and Device Configurations
- Router/switch configurations (e.g., `startup-config`, `running-config`)
- VPN files (e.g., `.ovpn`, `ipsec.conf`)
- Wi-Fi credentials (e.g., `wpa_supplicant.conf`)

### 5. Mobile Platforms
- **Android**: Keystores, backups, `.db` files
- **iOS**: Plist files, app-specific data

### 6. Dumps and Logs
- Database dumps (e.g., `.dump`, `.sql.bak`)
- Log files (e.g., `.log`, `debug.log`)
- Capture files (e.g., `.pcap`, `.cap`)

## 📜 File List Example

The full list is included in this repository, categorized by operating system and file type. Below is a small example:

```plaintext
# Password and credential files
password.txt
credentials.json
login.csv
api_keys.env

# Configuration files
config.yaml
wp-config.php
startup-config

# Backup and temporary files
*.bak
*.old
*.tmp
```

## 🛠️ How to Use

1. Clone the repository:
   ```bash
   git clone https://github.com/admaccount/sensitives-files.git
   ```

2. Integrate the file list into your auditing tools or scripts to search for potential sensitive files.

3. Run file searches on systems or environments **you own** or have explicit permission to test.

## ⚙️ Tools for File Discovery

Here are some tools that can help in conjunction with this file list:

- **Linux/Unix Tools**:
  ```bash
  find / -type f \( -name "*.bak" -o -name "password.txt" \) 2>/dev/null
  ```

- **PowerShell (Windows)**:
  ```powershell
  Get-ChildItem -Recurse -Include *.bak,*.old,password*.txt
  ```

- **Third-Party Tools**:
  - [grep](https://www.gnu.org/software/grep/)
  - [ripgrep](https://github.com/BurntSushi/ripgrep)
  - [RecuperaTools](https://github.com/some-tool)

## 📖 References

- [OWASP Security Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

## 🖊️ Contributing

Contributions are welcome! If you find any filenames or extensions not included in the list, feel free to open a pull request or issue.

1. Fork the repository.
2. Add your changes to the relevant file.
3. Submit a pull request.

## 📜 License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and distribute this list, provided proper attribution is given.

---

### Author

Created by **[TrustMe](https://github.com/admaccount)**. Feel free to reach out for questions or feedback!
