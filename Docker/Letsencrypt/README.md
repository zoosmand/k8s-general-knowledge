# Letsencrypt

~~~ bash
apt-get update
apt-get install letsencrypt python3-certbot-nginx
~~~

~~~ bash
certbot --nginx -d grafana.askug.net
certbot --nginx -d monitoring.askug.net

nginx: master process nginx -g daemon off;
~~~

~~~ bash
sudo certbot certonly --manual \
    --preferred-challenges=dns \
    --email admin@askug.net \
    --server https://acme-v02.api.letsencrypt.org/directory \
    --agree-tos \
    -d askug.net \
    -d *.askug.net
~~~

- certonly: Obtain or renew a certificate, but do not install
- manual: Obtain certificates interactively
- preferred-challenges=dns: Use dns to authenticate domain ownership
- server: Specify the endpoint to use to generate
- agree-tos: Agree to the ACME server’s subscriber terms
- d: Domain name to provide certificates for

~~~ crontab
0 1 * * * /usr/bin/certbot renew >> /var/log/letsencrypt/renew.log
~~~
