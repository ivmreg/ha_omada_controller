# Home Assistant Add-on: TP-Link Omada Controller

Run the TP-Link Omada Software Controller in your Home Assistant instance.

## About

This add-on allows you to run the TP-Link Omada Software Controller on your Home Assistant instance. The Omada Controller provides a centralized management platform for TP-Link EAP devices (Access Points), OC200/OC300 Hardware Controllers, and various other TP-Link devices.

## Installation

1. Add this repository to your Home Assistant instance by clicking this button:
   [![Open your Home Assistant instance and show the add add-on repository dialog with this repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fivmreg%2Fha_omada_controller)

2. Find the "TP-Link Omada Controller" add-on in the add-on store
3. Click install

## Configuration

The add-on can be configured via the Home Assistant UI. The following options are available:

| Option | Required | Description |
|--------|----------|-------------|
| `omada_data_dir` | No | The directory where Omada Controller data will be stored. Defaults to `/data/omada`. |

## Network Ports

The following ports are used by the Omada Controller:

- 8088/tcp: HTTP Web Portal
- 8043/tcp: HTTPS Web Portal
- 27001/udp: Controller Discovery
- 27002/tcp: App Discovery
- 29810/udp: Device Management
- 29811/tcp: Device Upgrade
- 29812/tcp: Controller Management
- 29813/tcp: Controller Logging

## First Run

1. After starting the add-on, wait a few minutes for the Omada Controller to initialize
2. Access the Omada Controller web interface at:
   - HTTP: `http://your-ha-ip:8088`
   - HTTPS: `https://your-ha-ip:8043`
3. Follow the initial setup wizard to configure your controller

## Support

If you have any issues or suggestions, please open an issue on GitHub.
