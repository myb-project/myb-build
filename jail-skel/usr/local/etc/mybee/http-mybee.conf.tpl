upstream api {
	server 127.0.0.1:65531;
}

server {
	listen      *:80;
	listen      [::]:80;
	server_name _;

	error_log /var/log/nginx/http.err;
	access_log /var/log/nginx/http.acc;

	include mime.types;

	location /status {
		include acl.conf;
		root /usr/local/www/status;
		try_files /status.html =404;
	}

	location /images {
		include acl.conf;
		types { }
		default_type application/json;
		proxy_pass http://api;
	}
	location /clusters {
		include acl.conf;
		types { }
		default_type application/json;
		proxy_pass http://api;
		#deny all;
		#allow <trusted>;
	}

        # GARM
        location ~ ^/api/v1/first-run/ {
                proxy_set_header X-Forwarded-For $remote_addr;
                proxy_set_header X-Forwarded-Host $http_host;
                proxy_set_header        Host    $Host;
                proxy_redirect off;
                proxy_pass http://127.0.0.1:9997;
        }
        location ~ ^/api/v1/auth/ {
                proxy_set_header X-Forwarded-For $remote_addr;
                proxy_set_header X-Forwarded-Host $http_host;
                proxy_set_header        Host    $Host;
                proxy_redirect off;
                proxy_pass http://127.0.0.1:9997;
        }
        location ~ ^/api/v1/providers {
                proxy_set_header X-Forwarded-For $remote_addr;
                proxy_set_header X-Forwarded-Host $http_host;
                proxy_set_header        Host    $Host;
                proxy_redirect off;
                proxy_pass http://127.0.0.1:9997;
        }
        location ~ ^/api/v1/repositories {
                proxy_set_header X-Forwarded-For $remote_addr;
                proxy_set_header X-Forwarded-Host $http_host;
                proxy_set_header        Host    $Host;
                proxy_redirect off;
                proxy_pass http://127.0.0.1:9997;
        }
        location ~ ^/api/v1/instances {
                proxy_set_header X-Forwarded-For $remote_addr;
                proxy_set_header X-Forwarded-Host $http_host;
                proxy_set_header        Host    $Host;
                proxy_redirect off;
                proxy_pass http://127.0.0.1:9997;
        }
        location ~ ^/api/v1/pools {
                proxy_set_header X-Forwarded-For $remote_addr;
                proxy_set_header X-Forwarded-Host $http_host;
                proxy_set_header        Host    $Host;
                proxy_redirect off;
                proxy_pass http://127.0.0.1:9997;
        }
        location ~ ^/api/v1/credentials {
                proxy_set_header X-Forwarded-For $remote_addr;
                proxy_set_header X-Forwarded-Host $http_host;
                proxy_set_header        Host    $Host;
                proxy_redirect off;
                proxy_pass http://127.0.0.1:9997;
        }
        location /webhooks {
                proxy_set_header X-Forwarded-For $remote_addr;
                proxy_set_header X-Forwarded-Host $http_host;
                proxy_set_header        Host    $Host;
                proxy_redirect off;
                proxy_pass http://127.0.0.1:9997;
        }
        location ~ ^/api/v1/callbacks/status {
                proxy_set_header X-Forwarded-For $remote_addr;
                proxy_set_header X-Forwarded-Host $http_host;
                proxy_set_header        Host    $Host;
                proxy_redirect off;
                proxy_pass http://127.0.0.1:9997;
        }


	location ~ ^/api/v[1-9]\d*/ {
		include acl.conf;
		types { }
		default_type application/json;
		proxy_pass http://api;
		#deny all;
		#allow <trusted>;
	}

	location / {
		root /usr/local/www/public;
	}
}
