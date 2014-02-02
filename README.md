## Nginx with php5-fpm docker image


### Usage 

`docker run -d -p 80:80 -link mysql:mysql -v /vagrant/sites-available:/etc/nginx/sites-available -v /vagrant/www:/var/www -v /var/log/nginx:/var/log/nginx pulse00/nginx-php`

Add a `default` file on your host box inside the linked `sites-available` folder with a content like this:


#### CLI 

To access the php commandline, run

`docker run -i -rm -t -entrypoint="bash" -v /vagrant/www:/var/www  -link mysql:mysql -link redis:redis -link mongo:mongo pulse00/nginx-php -c '/bin/bash'`


```
server {
        #listen   80; ## listen for ipv4; this line is default and implied
        #listen   [::]:80 default ipv6only=on; ## listen for ipv6

		# /var/www is mounted from the host
        root /var/www;
        index index.html index.php;

        # Make site accessible from http://localhost/
        server_name localhost;

        location / { 
            try_files $uri $uri/ /index.php;
        }   

        location ~ \.php$ {
            fastcgi_split_path_info ^(.+\.php)(/.+)$;
            fastcgi_pass unix:/var/run/php5-fpm.sock;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_index index.php;
            include fastcgi_params;
        }   
}
```

Mounts the host directories from the `-v` flags into the container.


## Connect to a database on another container

`docker run -d -p 80:80 -link mysql:mysql -v /vagrant/sites-available:/etc/nginx/sites-available -v /vagrant/www:/var/www -v /var/log/nginx:/var/log/nginx pulse00/nginx-php`
