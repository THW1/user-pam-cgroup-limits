# user-pam-cgroup-limits
settings for a user session cgroup resource limits via PAM for systems with systemd &lt; 239

## Intro


On a shared multi user system, it can be helpful to contrain user sessions within cgroups. I.e., to limit the resources like CPU or memory a user can utilize within her or his session to avoid affecting other users.

While with newer [systemd releases >239](https://github.com/systemd/systemd/commit/5396624506e155c4bc10c0ee65b939600860ab67) one can drop systemd-logind slice configurations to limit user sessions, older releases have to fall back to other options. As solution on CentOS 7, we run the `user_session_cgroup.sh` script during a ssh session login and set cgroup limits. In principle, it could be run also from other PAM module configurations.

## Usage

Include in  `/etc/pam.d/sshd` (or a similar config like login) the pam_exec call like

```
session    required     pam_exec.so debug /usr/local/bin/user_session_cgroup.sh
```
Change the cgroup resource limits set in the script accordiog to your needs (watch out for relative [cgroup share arithmetics](https://www.redhat.com/sysadmin/cgroups-part-two).)


## Thanks

The original is from Steve Traylen/CERN, who also suggested to use pam_exec insertad of pam_script.
