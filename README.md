# Home Assistant Add-on: TP-Link Omada Controller

This repository provides a minimal Home Assistant add-on that runs the TP-Link Omada Software Controller (v6 beta) using the community image `mbentley/omada-controller:beta-6.0` as its base.

This README documents how the add-on is packaged in this repository, what is persisted, which ports are used, and some troubleshooting tips for common issues (for example: port conflicts such as the 8843 error).

## What this add-on does

- Runs the Omada Controller inside a container using the `mbentley/omada-controller` image
- Integrates with Home Assistant add-on supervisor for configuration and persistent storage
- Forwards the Omada Controller logs into the Home Assistant add-on logs

## Important implementation details

- Base image: `mbentley/omada-controller:beta-6.0`
- The container expects persistent controller data to be provided by Home Assistant (see `omada_data_dir` below).
- By default this add-on uses `host_network: true` in `config.yaml` so the controller can discover devices on the LAN reliably. That means port mappings are not required in the add-on UI.
- A small wrapper script is used to read Home Assistant add-on options and set environment variables before starting the original image entrypoint.

## Configuration options (add-on options)

Configure these in the add-on UI under "Configuration":

- `omada_data_dir` (string, default `/data/omada`) — directory inside the add-on where controller data is stored. This path is created and owned by the Omada user at container start. Keep this set to the default unless you have a reason to change it.
- `log_level` (string, default `info`) — controls how verbose the log forwarding is (debug/info/warning/error).

Example (default):

```
omada_data_dir: "/data/omada"
log_level: "info"
```

## Persistence

Persistent storage is important — the controller maintains databases, certs, and configuration under the `omada_data_dir`. This add-on declares:

- `map: - share:rw` in `config.yaml` so the add-on gets a place to persist data provided by Home Assistant (`/share/<addon-slug>/` or `/data` inside the add-on runtime).

The add-on will create these folders inside your configured `omada_data_dir`:

- `data/` — main controller database and configuration
- `work/` — working files
- `logs/` — controller log files
- `cert/` — SSL certificates

Keep backups of this directory if you plan to migrate or restore the controller.

## Network / Ports

When `host_network: true` is enabled (recommended for discovery), the controller uses host network interfaces directly. The Omada Controller uses these ports by default:

- 8088/tcp — HTTP (controller portal)
- 8043/tcp — HTTPS (controller portal and management)
- 27001/udp — Device discovery
- 27002/tcp — App discovery
- 29810/udp — Device management
- 29811/tcp — Device upgrade
- 29812/tcp — Controller management
- 29813/tcp — Controller logging

Note: In earlier attempts the controller tried to bind to port `8843` and failed (error: "Port 8843 is already in use"). That can happen if a previous instance or another service already occupies that port. This add-on's wrapper script sets the portal HTTPS port to `8043` to avoid the typical 8843 conflict when possible. If you still see a conflict, identify the process using that port on the host and free it (or change the port mapping on the host).

## Troubleshooting — Port 8843 error

If you see errors like:

```
Port 8843 is already in use in system.
Port 8843 is already in use. Release the port and try again.
Environment is not ok for controller running
```

Try the following:

1. If you are running another Omada instance (or any service using 8843) on the same host, stop it or change its listening port.
2. Verify host processes using the port (on the Home Assistant host):

```bash
# show what is listening on 8843 (run on your HA host)
sudo ss -ltnp | grep 8843
```

3. If port is free on the host but container still fails, confirm the add-on is started with `host_network: true` (this add-on does that by default). If you prefer to run in bridge mode, you'll need to expose ports in the add-on UI and make sure no external service claims 8043/8088/8843 on the host.

4. As a last resort, stop Home Assistant services that might be occupying the port and retry, or configure Omada to use alternate portal ports via the wrapper (advanced).

## Logs

The add-on forwards Omada Controller output to the Home Assistant add-on log view. Use the Supervisor -> Add-on -> Logs page to inspect startup and runtime messages. Set `log_level` to `debug` to see more verbose logs.

## Upgrading

This repository uses the `mbentley/omada-controller:beta-6.0` image. To move to other tags or newer Omada versions you can edit the `Dockerfile` to reference another tag (for example a stable v6 tag). Be careful to verify compatibility with the wrapper and environment variable names.

## Support

If you need help, open an issue on the repository and include:

- The add-on logs (Supervisor -> Add-on -> Logs)
- The contents of `config.yaml` (as used by the add-on)
- Any host-level processes that might be using relevant ports

---

This README was generated to match the current add-on implementation: it uses `mbentley/omada-controller:beta-6.0`, host networking for discovery, persistent data under the configured `omada_data_dir`, and a small start wrapper that applies Home Assistant options before launching the original image entrypoint.
