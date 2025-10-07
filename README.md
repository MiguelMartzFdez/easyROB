---

<p align="center">
  <img src="Logos/easyROB_logo.png" alt="easyROB logo" width="250"/>
</p>

<h2 align="center">easyROB — Standalone GUI Launcher</h2>

---

### 📦 Downloads

Pre-packaged versions of **easyROB** (with bundled Python environments) are available in the [Releases](../../releases) page.  
👉 Just download the ZIP corresponding to your operating system.

---

### 🖥️ Windows instructions
1. Download and unzip **easyROB_win.zip** from [Releases](../../releases).
2. Inside the folder you will find:
   - `launcher.vbs` → main launcher (starts the app without console window).  
   - `create_shortcut.vbs` → optional, creates a desktop shortcut with the official icon.  
   - `tools/run_easyrob.bat` → internal script with logging and environment setup.  
   - `easyROB/` → contains the GUI code and program icon.  
   - `robert_env_unpacked/` → prebuilt Python environment.
3. Run `launcher.vbs` to start the program.
4. (Optional) Run `create_shortcut.vbs` once to place an **easyROB** icon on your desktop for easier access.

The log file will be stored in `easyrob_process.log` at the root of the folder.

---

### 🐧 Linux instructions
1. Download and unzip **easyROB_linux.zip** from [Releases](../../releases).  
2. Inside the folder you will find:  
   - `run_easyrob.sh` → main launcher (starts the app using the bundled Python).  
   - `create_desktop_shortcut.sh` → optional, creates a desktop shortcut with the official icon.  
   - `robert_env_unpacked/` → prebuilt portable Python environment.  
   - `easyROB/` → contains the GUI code and program icon.  
   > ⚠️ If after extracting you get a nested folder (e.g. `easyROB_linux/easyROB_linux/...`),  
   > move everything so that there is only **one** `easyROB_linux/` directory.

3. **Give execution permissions** (first time only):  
   Open a terminal in the folder and run:
   ```bash
   chmod +x run_easyrob.sh
   chmod +x create_desktop_shortcut.sh
   ```
   > Alternatively, you can also right-click each file → **Properties → Permissions → Allow executing file as program**.

4. **Launch easyROB manually**:  
   You can either right-click `run_easyrob.sh` and choose **“Run as a program”**,  
   or run it from a terminal:
   ```bash
   ./run_easyrob.sh
   ```
   You will see an info popup saying *“easyROB is starting…”*.  
   The first run may take longer because it configures the environment.

5. **(Optional) Create a desktop shortcut**:
   You can either right-click `run_easyrob.sh` and choose **“Run as a program”**,
   or run it from a terminal:
   ```bash
   ./create_desktop_shortcut.sh
   ```
   This will create:
   ```
   ~/Desktop/easyROB.desktop
   ```
   - If Ubuntu opens it as text, right-click → **Properties → Permissions → Allow executing file as program**.  
   - To add it to the application menu:
     ```bash
     mkdir -p ~/.local/share/applications
     cp ~/Desktop/easyROB.desktop ~/.local/share/applications/
     ```
---

### 🍏 macOS instructions (coming soon)
- .

---

### ⚠️ Antivirus / SmartScreen
Since the app is **not code-signed**, it is **normal** that Windows Defender, SmartScreen or other AV software show a warning.  
- Please select **“Run anyway” / “Allow”** if prompted.  
- What matters is whether the file actually runs or if the antivirus blocks/quarantines it.  
- If you encounter issues, report your OS, AV product/version and the exact message.

---

### 📝 Developers and contact
Main developer and contact:  
- [ ] [Miguel Martínez Fernández](https://orcid.org/0009-0002-8538-7250) — [miguel.martinez@csic.es](mailto:miguel.martinez@csic.es)

For feedback, issues and improvements, please use the **Issues** and **Pull requests** tabs on GitHub.  

---

### 📜 License
easyROB standalone launcher is available under an [MIT](https://opensource.org/licenses/MIT) License.  

---
