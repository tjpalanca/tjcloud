# Add nginx config and start nginx
echo "

map \$http_upgrade \$connection_upgrade {
    default upgrade;
    '' close;
}

# Main RStudio Server
server {
    listen 8080;
    server_name $PROXY_DOMAIN;
    client_max_body_size 2G;
    location / {
        proxy_pass http://127.0.0.1:8787/;
        proxy_redirect https://127.0.0.1:8787/ https://$PROXY_DOMAIN/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \$connection_upgrade;
        proxy_read_timeout 20d;
        proxy_set_header Host $PROXY_DOMAIN;
        proxy_set_header X-Forwarded-Host $PROXY_DOMAIN;
        proxy_set_header X-Forwarded-Server $PROXY_DOMAIN;
    }
}

# Port 8888
server {
    listen 8080;
    server_name 8888.$PROXY_DOMAIN;
    client_max_body_size 2G;
    location / {
        proxy_pass http://127.0.0.1:8888/;
        proxy_redirect https://127.0.0.1:8888/ https://8888.$PROXY_DOMAIN/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \$connection_upgrade;
        proxy_read_timeout 20d;
        proxy_set_header Host 8888.$PROXY_DOMAIN;
        proxy_set_header X-Forwarded-Host 8888.$PROXY_DOMAIN;
        proxy_set_header X-Forwarded-Server 8888.$PROXY_DOMAIN;
    }
}

# Port 5500
server {
    listen 8080;
    server_name 5500.$PROXY_DOMAIN;
    client_max_body_size 2G;
    location / {
        proxy_pass http://127.0.0.1:5500/;
        proxy_redirect https://127.0.0.1:5500/ https://5500.$PROXY_DOMAIN/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \$connection_upgrade;
        proxy_read_timeout 20d;
        proxy_set_header Host 5500.$PROXY_DOMAIN;
        proxy_set_header X-Forwarded-Host 5500.$PROXY_DOMAIN;
        proxy_set_header X-Forwarded-Server 5500.$PROXY_DOMAIN;
    }
}

# Port 3838
server {
    listen 8080;
    server_name 3838.$PROXY_DOMAIN;
    client_max_body_size 2G;
    location / {
        proxy_pass http://127.0.0.1:3838/;
        proxy_redirect https://127.0.0.1:3838/ https://3838.$PROXY_DOMAIN/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \$connection_upgrade;
        proxy_read_timeout 20d;
        proxy_set_header Host 3838.$PROXY_DOMAIN;
        proxy_set_header X-Forwarded-Host 3838.$PROXY_DOMAIN;
        proxy_set_header X-Forwarded-Server 3838.$PROXY_DOMAIN;
    }
}

" > /etc/nginx/sites-enabled/default
echo "
user rstudio;
worker_processes auto;
pid /run/nginx.pid;
include /etc/nginx/modules-enabled/*.conf;

events {
    worker_connections 768;
}

http {

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
    ssl_prefer_server_ciphers on;

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    gzip on;

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;

}
" > /etc/nginx/nginx.conf
service nginx start

# Allow non root user to use docker
usermod -aG docker $USER

# Get root environment and place in system-wide Renviron file
R_ENVIRON=$(Rscript -e "cat(R.home())")/etc/Renviron.site
env > $R_ENVIRON

# Remove sensitive enrivonment variables
sed -i '/^HOME=/d' $R_ENVIRON
sed -i '/^PWD=/d' $R_ENVIRON
sed -i '/^PATH=/d' $R_ENVIRON
sed -i '/^USER=/d' $R_ENVIRON
sed -i '/^PASSWORD=/d' $R_ENVIRON

# Add miniconda to path
export PATH="/home/$USER/.local/bin:/home/$USER/.local/share/r-miniconda/bin:$PATH"

# Run original script
/init
