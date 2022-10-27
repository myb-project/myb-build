server {
	listen      *:80;
	listen      [::]:80;
	server_name %%API_FQDN%%;

	error_log /dev/null;
	access_log off;

	include letsencrypt.conf;

	location / {
		return 301 "https://$host$request_uri";
	}
}
