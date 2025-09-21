# Burner Browser

## Why?

This exists because Facebook and Google are creepy (despite what they claim)
data brokers suck, and because some nation states suck and exploit browsers
and OSes instead of reporting the vulnerabilities to the projects/products so
the vulnerabilities can be addressed.

This is helpful for scenarios where you are explicitly engaging with services
like Facebook and you want to make it more difficult for them to create a
shadow profile of you. This is also good for cases where you're dealing with
an untrusted service provider or you need a better airgapped browsing
experience.

In theory you could do this by creating a separate profile which clears the
cache each time, but this intentionally goes a step further by spawning a
separate VPN instance to ensure that data collection is as difficult as
possible for those services.

Plus it's nice to have a system that is easier to airgap than running directly
on your machine, without having to spin up an entire VM to accomplish the same
thing, with meta-exploits like Pegasus roaming around the Internet.

## Why Docker and not Docker Compose?

Docker Compose would have been the better way to express this using a more
modular microservices model and by making it easier to airgap the VPN service
from the client activities, since both items are run in separate containers,
however, NordVPN doesn't seem to support port forwarding or port triggering
(easily, at least).

Also, installing docker-compose requires yet another tool for managing this
ephemeral ecosystem.

Moreover, it would be easier to create multi-distro containers, e.g., OpenSUSE
busybox (lightweight) vs Ubuntu (heavyweight).

I might redo this later once I create a VPN image that functions as an
autoforwarding router gateway, but for now this simple system suffices.

## How to Build

```shell
make all
```

## How to Run

### Requirements

* An OS with a running X11 server (Wayland's ok too I guess.. 😜).

#### MacOS Requirements

```shell
brew install xquartz
```

#### Procedure

```shell
docker run --pull --rm burner-browser:latest -e "DISPLAY=$DISPLAY" -v "$TMPDIR/.X11-unix:/tmp/.X11-unix"
```
