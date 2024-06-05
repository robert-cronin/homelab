# Talos Installation

Most of the information you will need to install the OS on Rasberry PI 4 can be found [here](https://www.talos.dev/v1.3/talos-guides/install/single-board-computers/rpi_4/).

The initial setup should be run with the following talosctl:

```bash
# Install Talos
curl -L https://github.com/siderolabs/talos/releases/download/v1.2.7/talosctl-linux-amd64 -o talosctl
sudo mv talosctl /usr/local/bin/talosctl
sudo chmod +x /usr/local/bin/talosctl
```

Once you have installed talosctl, modify `bootstrap.sh` to match your node IPs and run the script from project root directory with the following command:

```bash
./talos/bootstrap.sh
```