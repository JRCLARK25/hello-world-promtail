FROM ubuntu:latest

USER root

RUN apt-get update
RUN apt-get install -y nginx nodejs gpg wget unzip

# Remove the default Nginx configuration file
RUN rm -v /etc/nginx/nginx.conf

# Copy a configuration file from the current directory
ADD nginx.conf /etc/nginx/

ADD web /usr/share/nginx/html/
ADD web /var/www/html/

# Append "daemon off;" to the beginning of the configuration
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Expose ports
EXPOSE 90

# Setup Promtail
RUN chmod 655 /var/log/nginx/access.log 
RUN chmod 655 /var/log/nginx/error.log
RUN wget https://github.com/grafana/loki/releases/download/v3.2.1/promtail_3.2.1_amd64.deb
RUN chmod +x promtail_3.2.1_amd64.deb
RUN dpkg -i promtail_3.2.1_amd64.deb
ADD config.yml .

# Set the default command to execute
# when creating a new container
CMD service nginx start & promtail -config.file config.yml