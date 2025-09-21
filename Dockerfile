FROM ubuntu:latest

ARG USER=unprivileged
ONBUILD USER root

# 1. Install packages.
#
# This is segmented up to improve OverlayFS caching if making iterative changes
# between these steps.

# a. Upgrade and update via apt.
RUN apt update && apt upgrade -y

# b. Install the base packages.
RUN apt install -y ca-certificates openvpn sudo unzip wget

# c. Install the clients.
RUN apt install -y ca-certificates firefox torbrowser-launcher

ADD scripts/update-vpn-profiles.sh /usr/local/sbin/update-vpn-profiles.sh

# 2. Download and install OpenVPN profiles.
RUN /usr/local/sbin/update-vpn-profiles.sh

# 3. Add the requisite users for the container.
RUN adduser ${USER}
RUN usermod -G adm ${USER}
ENV HOME=/home/unprivileged

# 4. Setup sudoers for passwordless entry for the unprivileged user.
RUN mkdir -m 0755 -p /etc/sudoers.d
# XXX: constrain this down to a more minimal command set for sudo.
RUN echo '%adm ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/passwordless-admin-${USER}
# Sanity check that `sudo true` works without prompting for a password.
RUN /usr/bin/sudo -u "${USER}" sh -c "/usr/bin/sudo -u root true"

# 5. Clean up the apt cache.
RUN <<EOS sh
set -ex
rm -rf /var/lib/apt/lists/*
apt clean
EOS

ADD scripts/entry.sh /usr/local/sbin/entry.sh

USER ${USER}
CMD ["/usr/bin/env", "bash", "-i"]
ENTRYPOINT ["/usr/local/sbin/entry.sh"]
