# Mount distant disk locally

This tutorial is really made for Linux users. This method can be used to mount a distant disk into your local explorer.

* **Mount the disk :** `sshfs rlebogosse@login.mesocentre.univ-amu.fr:/path_to_mount/ /local_path/`
* **Unmount the disk :** `fusermount -zu /local_path/`
