# Add nginx config and start nginx
echo "

map \$http_upgrade \$connection_upgrade {
    default upgrade;
    '' close;
}

# Main RStudio Server
server {
    listen 8080;
    server_name _;
    client_max_body_size 2G;
    location / {
        proxy_pass http://127.0.0.1:8787/;
        proxy_redirect http://127.0.0.1:8787/ \$scheme://$PROXY_DOMAIN/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \$connection_upgrade;
        proxy_read_timeout 20d;
    }
}

# Port 8888
server {
    listen 8080;
    server_name 8888.$PROXY_DOMAIN;
    client_max_body_size 2G;
    location / {
        proxy_pass http://127.0.0.1:8888/;
        proxy_redirect http://127.0.0.1:8888/ \$scheme://\$http_host/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \$connection_upgrade;
        proxy_read_timeout 20d;
    }
}

# Port 5050
server {
    listen 8080;
    server_name 5050.$PROXY_DOMAIN;
    client_max_body_size 2G;
    location / {
        proxy_pass http://127.0.0.1:5050/;
        proxy_redirect http://127.0.0.1:5050/ \$scheme://\$http_host/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \$connection_upgrade;
        proxy_read_timeout 20d;
    }
}

# Port 3838
server {
    listen 8080;
    server_name 3838.$PROXY_DOMAIN;
    client_max_body_size 2G;
    location / {
        proxy_pass http://127.0.0.1:3838/;
        proxy_redirect http://127.0.0.1:3838/ \$scheme://\$http_host/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \$connection_upgrade;
        proxy_read_timeout 20d;
    }
}

" > /etc/nginx/sites-enabled/default
service nginx start

# Run original script
/init
