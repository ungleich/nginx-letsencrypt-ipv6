This container provides fully automated SSL containers in IPv6
networks

## Requirements

You need to have docker configured to use IPv6. The following code can
be placed in /etc/docker/daemon.json:

```
{
  "ipv6": true,
  "fixed-cidr-v6": "2001:db8::/64"
}
```

You need to replace "2001:db8::/64" with your own IPv6 network.

Read more about [enabling IPv6 in docker](https://ungleich.ch/u/blog/how-to-enable-ipv6-in-docker/).

## How it works

IPv6 addresses are globally reachable, so IPv6 based containers can be
reached from anywhere in the world.

This container uses the domain **has-a.name**, which gives a
name to every IPv6 address.

Checkout how
[has-a.name](https://ungleich.ch/u/blog/has-a-name-for-every-ipv6-address/) works.

## How to use

Start the container and use the logs to gets its domain name:

```
id=$(docker run -d ungleich/nginx-letsencrypt-ipv6)
docker logs ${id} 2>/dev/null | grep "^Getting certificate"
Getting certificate for 2a0a-e5c1-0111-0777-0000-0242-ac11-0004.has-a.name
```

With this information, you can now connect to your container:
```
% curl https://2a0a-e5c1-0111-0777-0000-0242-ac11-0004.has-a.name
Welcome to 2a0a-e5c1-0111-0777-0000-0242-ac11-0004.has-a.name running with IPv6+LetsEncrypt
```

## How to extend it

TBD
