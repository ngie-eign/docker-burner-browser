FROM ubuntu:latest

# 1. Install the base packages.
RUN apt update && apt upgrade -y && \
    apt install -y ca-certificates firefox openvpn sudo torbrowser-launcher unzip wget

ADD scripts/update-vpn-profiles.sh /usr/local/sbin/update-vpn-profiles.sh

# 2. Download and install OpenVPN profiles.
RUN /usr/local/sbin/update-vpn-profiles.sh

ARG USER=unprivileged

# 3. Add the requisite users for the container.
RUN adduser ${USER}
RUN usermod -G adm ${USER}

# 4. Setup sudoers for passwordless entry.
RUN mkdir -m 0755 -p /etc/sudoers.d
RUN echo '%adm ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/passwordless-adm
# Sanity check that `sudo true` works without prompting for a password.
RUN /usr/bin/sudo -u "${USER}" sh -c "/usr/bin/sudo -u root true"

# 5. Clean up the apt cache.
RUN <<EOS sh
set -ex
rm -rf /var/lib/apt/lists/*
apt clean
EOS

ADD scripts/entry.sh /usr/local/sbin/entry.sh

ONBUILD USER root
USER ${USER}
ENV HOME=/home/unprivileged

CMD ["/usr/bin/env", "bash", "-i"]
ENTRYPOINT ["/usr/local/sbin/entry.sh"]
