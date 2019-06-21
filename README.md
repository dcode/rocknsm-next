# Rock 3

Nothing to see here. This repo is just for testing Fedora CoreOS as a
base platform for RockNSM 3.x. There's lots of work to do here and 
nothing at all remotely close to being a functional distribution.

## Development

I'm not fully documenting this now, but there's two scripts to iterate
through all the things. Read the scripts to see what they need.

- `update-version.sh`: Generates the `vars.json` file and downloads the
  latest Fedora CoreOS ISO installer and BIOS bare metal image.
- `generate_config_and_run.sh`: Translates `config/ignition.yaml` to
  `http/config.ign` and runs packer with the aforementioned `vars.json`,
  boots the latest ISO, and serves the generated config and disk image.

Once packer completes the install, you get like maybe 10 minutes before
the VM just times out and shuts off. For where I am dev-wise, that's usually
enough time to see how things broke to make fixes in the ignition config.
