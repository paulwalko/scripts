Usage: `ansible-playbook main.yml -i hosts.cfg --limit=cabinet`

Assumes:

- All:
  - OS (Debian) has been installed and IPs have been configured in hosts.cfg
  - Host is already trusted via ssh and can be ssh'd into using keys
  - Passwordless sudo is enabled for the user ansible uses
  - Root and user pw is something memorable

- Wireguard hosts:
  - Secure boot is disabled (wireguard is an unsigned module)
  - Wireguard is configured on 10.200.0.0/24; See https://wiki.debian.org/Wireguard

- ZFS server:
  - ZFS is configured with a volume at /bigdata for sharing

- Media server:
  - Create /media-vtluug folder

- Remote:
  - joe/pew users have been created
