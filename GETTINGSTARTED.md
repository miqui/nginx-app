# Getting Started
Installation and operation of nginx-app
## Use case
nginx-app is a simple proxied web server. The design is to run a haproxy container on the front end of our Docker cluster with port 80 exposed on a public IP address. Then http requests are proxied to a nginx container on the backend that serves up a static web site from an external named Docker volume.
## System requirements
This example requires a multi-host swarm cluster. You can use open source [Docker Swarm](https://docs.docker.com/swarm/) or [Docker Universal Control Plane](https://docs.docker.com/ucp/). This example was tested on UCP with a Docker Datacenter trial license.
## Dependencies
The proxy used is a modified haproxy that can be configured via environment variables. The image is on Docker Hub as [bobfraser1/haproxy-env](https://hub.docker.com/r/bobfraser1/haproxy-env/). The github project is at [bobfraser1/haproxy-env](https://github.com/bobfraser1/haproxy-env).
The web server is the standard DockerHub image [nginx:alpine](https://hub.docker.com/_/nginx/).
## Swarm container placement and node labels
nginx-app uses Swarm filters to ensure that haproxy runs on the front end and nginx runs on the backend data tier. For this to work custom labels must be applied to the Swarm nodes.
### Adding labels in boot2docker
An example of adding a label to a boot2docker node is in config/boot2docker.
### Adding labels to ubuntu
An example of adding a label to an ubuntu node is in config/ubuntu
## External volumes
External volumes are a great way to share data among containers and to abstract application tiers from the underlying persistance layer. docker-compose will neither create nor destroy external volumes. The volume must be created before you run docker-compose.
### Using the local driver
The simplest thing to do is to create a named volume from the command line with the default driver (local):
```
docker volume create --name nginx-app-html
```
The compose file will map this to /usr/share/nginx/html inside the nginx container. When nginx starts up for the first time, it will create a default index.html. You could then attach to the container and muck with the files or you could create another container (such as a samba container) that also maps the same external volume.
### Using volume plugins
There are a variety of [Docker volume plugins](https://github.com/docker/docker/blob/master/docs/extend/plugins.md) available providing different persistance strategies.

[Cameron Spear](https://github.com/CWSpear) has a most excellent volume plugin [local persist](https://github.com/CWSpear/local-persist) that will map a directory on the host node into a Docker volume. After installing the plugin, ssh into your data node and create the volume:
```
docker volume create -d local-persist -o mountpoint=/volumes/nginx-app-html --name=nginx-app-html
```
Now you can edit files in /volumes/nginx-app-html and the results will automatically show up in the nginx container.
## Running nginx-app
Once your client is configured to target Swarm or UCP you can run `docker-compose up`.

Point your browser at <frontend-ip-address>:80 and you should see your web page.

**NOTE:** There is a chance this may fail with an error message about 'nginx' being invalid. There is a race condition where the nginx service may not be fully operational when haproxy looks for it. One workaround is to simply run `docker-compose up` again. This time nginx will already be up and the restart of haproxy will succeed. Think of it as 'desired state' programming. Another solution is to run `docker-compose up -d nginx; docker-compose up`. This will explicitly launch the nginx service first, then launch haproxy.
