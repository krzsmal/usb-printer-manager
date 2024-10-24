
# USB Printer Manager

This project includes a Bash script that monitors the connection status of a specific USB printer and automatically manages print jobs using CUPS (Common Unix Printing System). The script makes sure that when the printer is connected and turned on, CUPS will enable it and accept print jobs. If the printer is disconnected or turned off, the script cancels all jobs in the queue and rejects any new ones. This helps avoid unnecessary duplicate prints if the user forgets to turn on the printer before sending a job.

## Features
- Automatically enables the printer in CUPS when it is connected.
- Cancels all jobs and disables the printer when it is disconnected.
- Regularly monitors the printer connection via USB bus.

## Requirements
- Linux-based system
- CUPS installed
- Access to the `lpstat`, `cupsaccept`, `cupsenable`, and `cancel` commands
- `lsusb` installed

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/krzsmal/usb-printer-manager.git
   cd usb-printer-manager
   ```

2. Make the script executable:
   ```bash
   chmod +x printer-monitor.sh
   ```

3. Edit the script to configure your printer's name and USB bus ID:
   - Replace `PRINTER_NAME="Deskjet-1510-series"` with the name of your printer as shown by CUPS.
   - Replace `BUS="03f0"` with the correct USB bus ID of your printer. You can find the bus ID by running `lsusb`.

4. Test the script:
   ```bash
   ./printer-monitor.sh
   ```

## Running as a Systemd Service

To ensure the script runs automatically in the background and starts on boot, you can set it up as a systemd service.

1. Create a systemd service file:

   ```bash
   sudo nano /etc/systemd/system/printer-monitor.service
   ```

2. Add the following content:

   ```ini
   [Unit]
   Description=USB Printer Monitor Service
   After=network.target

   [Service]
   ExecStart=/path/to/printer-monitor.sh
   Restart=always
   User=root

   [Install]
   WantedBy=multi-user.target
   ```

   Replace `/path/to/printer-monitor.sh` with the full path to the `printer-monitor.sh` file.

3. Reload systemd to apply the new service:
   ```bash
   sudo systemctl daemon-reload
   ```

4. Enable and start the service:
   ```bash
   sudo systemctl enable printer-monitor
   sudo systemctl start printer-monitor
   ```

5. Check the service status:
   ```bash
   sudo systemctl status printer-monitor
   ```

## Customization

- **Printer Name**: Edit the `PRINTER_NAME` variable in the script to match your printer's name.
- **USB Bus**: Change the `BUS` variable to reflect the USB bus ID of your printer.
- **Check Interval**: Adjust `CHECK_INTERVAL` (in seconds) to change how frequently the script checks the printer's status.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
