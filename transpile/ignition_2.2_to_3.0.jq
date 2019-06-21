del(.networkd) |
(.systemd.units[] |=with_entries(if .key == "enable" then .key = "enabled" else . end)) |
( .storage.filesystems[]? |= del(.create) ) |
( .passwd.users[]? |= del(.create) ) |
.ignition.version="3.0.0"
