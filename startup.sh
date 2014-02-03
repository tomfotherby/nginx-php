 #!/bin/sh

# update the fpm configuration to make the service environment variables available
function setEnvironmentVariable() {

        if [ -z "$2" ]; then
                echo "Environment variable $1 not set."
                return
        fi  

        # This is a weird hack, because the php-fpm environment does not see the $MYSQL_PORT_3306_TCP_ADDR variable...
        if grep -q MYSQL_HOST /etc/php5/fpm/pool.d/www.conf; then
                sed -i "s/^env\[$1.*/env[$1] = $2/g" /etc/php5/fpm/pool.d/www.conf
        else
                echo "env[$1] = $2" >> /etc/php5/fpm/pool.d/www.conf
        fi  
}

# set environment variables to other services
setEnvironmentVariable MONGO_PORT_27017_TCP_ADDR $MONGO_PORT_27017_TCP_ADDR
setEnvironmentVariable MONGO_PORT_27017_TCP_PORT $MONGO_PORT_27017_TCP_PORT

setEnvironmentVariable MYSQL_PORT_3306_TCP_ADDR $MYSQL_PORT_3306_TCP_ADDR
setEnvironmentVariable MYSQL_PORT_3306_TCP_PORT $MYSQL_PORT_3306_TCP_PORT

setEnvironmentVariable REDIS_PORT_6379_TCP_ADDR $REDIS_PORT_6379_TCP_ADDR
setEnvironmentVariable REDIS_PORT_6379_TCP_PORT $REDIS_PORT_6379_TCP_PORT

setEnvironmentVariable ELASTIC_PORT_9200_TCP_ADDR $ELASTIC_PORT_9200_TCP_ADDR
setEnvironmentVariable ELASTIC_PORT_9200_TCP_PORT $ELASTIC_PORT_9200_TCP_PORT

setEnvironmentVariable RABBIT_PORT_5672_TCP_ADDR $RABBIT_PORT_5672_TCP_ADDR
setEnvironmentVariable RABBIT_PORT_5672_TCP_PORT $RABBIT_PORT_5672_TCP_PORT

 # start php-fpm
service php5-fpm start

# start nginx
nginx
