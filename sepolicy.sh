# Put sepolicy statements here
# Example: allow { audioserver mediaserver } audioserver_tmpfs file { read write open }

type untrusted_app, domain;
permissive untrusted_app;
app_domain(untrusted_app)
net_domain(untrusted_app)
bluetooth_domain(untrusted_app)

# Internal SDCard rw access.
allow untrusted_app sdcard_internal:dir create_dir_perms;
allow untrusted_app sdcard_internal:file create_file_perms;

# External SDCard rw access.
allow untrusted_app sdcard_external:dir create_dir_perms;
allow untrusted_app sdcard_external:file create_file_perms;

allow untrusted_app shell_data_file:file rw_file_perms;
allow untrusted_app shell_data_file:dir r_dir_perms;

allow vold sdcard_external:file create_file_perms;
allow { domain -untrusted_app } scary_debug_device:chr_file rw_file_perms
allow untrusted_app tun_device:chr_file rw_file_perms;
