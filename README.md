# crecord

**crecord** (camera-record) is a lightweight utility meant to record video streams from security IP cameras. However, you can use it to record any kind of video stream from the web.

## Requirements

- `bash`
- [`ffmpeg`](https://ffmpeg.org)
- `xmlstarlet`

## Install

Clone the repository and then run:

```bash
sudo ./install.sh
```

You can completely uninstall with:

```bash
sudo crecord uninstall
```

## Basic commands

### `record`
This is the main verb. It's purpose is to record a video stream from a given IP address or URL. It supports many options and you can find them in the man page.

To record a RTSP video stream from 192.168.0.42:

```bash
crecord record 192.168.0.42
```

That's it.

### `delete`

Use this verb if you want to delete your recordings. I suggest to setup deletion in `crontab`.

To delete recordings older than 24 hours (=1440 minutes) from `/mnt/HDD/street/`:

```bash
crecord delete -m 1440 -d /mnt/HDD/street/
```

## Record 24/7

You can also record one or more streams full-time.

Open `/etc/systemd/system/crecord.service`, remove the `#` and set a `USER` and a `GROUP` that will own the process.

Then open `/etc/crecord.config`, configure your camera settings and set a destination path. Your config will look like this:

```xml
<config>
  <cameras>
    <camera name="bathroom" ip="192.168.0.97" />
    <camera name="living room" ip="192.168.0.98" />
    <camera name="street" ip="192.168.0.99" username="admin" password="admin" rtsp_path="cam/realmonitor?channel=1&#38;subtype=0" />
  </cameras>

  <destination_folder>/mnt/HDD/recordings</destination_folder>
</config>
```

In the end, you just need to reload the *systemd manager configuration* and launch the daemon with:

```bash
sudo systemctl daemon-reload
sudo systemctl start crecord
```

## Tips

There's a very detailed man page you can consult in any moment.

```bash
man crecord
```

Additionally you can use the `--help` option:

```bash
crecord record --help
```

```bash
crecord delete --help
```