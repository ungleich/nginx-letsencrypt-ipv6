#!/bin/sh

addr=$(ip -o a | grep inet6 | grep -vE ' lo |fe80' | awk '{ print $4 }')
expanded_addr=$(sipcalc $addr | awk '/^Expanded/ { print $4}')
dnsname=$(echo $expanded_addr | sed 's/:/-/g').has-a.name

echo Getting certificate for $dnsname

wwwroot=/var/www/${dnsname}

mkdir -p "${wwwroot}"

cat > "/etc/nginx/conf.d/${dnsname}.conf" <<EOF
# required, otherwise nginx complains with > 1 vhost
server_names_hash_bucket_size 128;

server {
	listen 80;
	listen [::]:80;

    server_name ${dnsname};

    location /.well-known/acme-challenge/ {
        root ${wwwroot};
    }

    # Everything else -> ssl
    location / {
        return 301 https://$host$request_uri;
    }


}
EOF

mkdir -p /run/nginx
nginx

certbot certonly --agree-tos \
        --register-unsafely-without-email \
        --non-interactive \
        --webroot --webroot-path "${wwwroot}" \
        -d "${dnsname}"

cat > "/etc/nginx/conf.d/${dnsname}_ssl.conf" <<EOF
server {
	listen 443 ssl;
	listen [::]:443 ssl;

    ssl_certificate /etc/letsencrypt/live/${dnsname}/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${dnsname}/privkey.pem;

    server_name ${dnsname};

    root ${wwwroot};
}
EOF

echo Welcome to ${dnsname} running with IPv6+LetsEncrypt > ${wwwroot}/index.html

# restart and run now with cert
pkill nginx

# wait until old process is gone
sleep 2

nginx -g "daemon off;"
