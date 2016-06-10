# nginx-app
docker-compose 2.0 example with container placement, multi-host networking, and external, named volumes
## Overview
nginx-app is a simple proxied web server illustrating the following compose 2.0 features:
 - Swarm contraint-based container placement via labels
 - Linking services over multi-host networking
 - Using external, named volumes to abstract container data persistance

## Installation and operation
As this example uses host node labels and external volumes, a little setup is required. This is detailed in GETTINGSTARTED.md
