# Apply custom labels in boot2docker
nginx-app uses the label `com.bobfraser1.apptier` to control container placement. Label names are arbitrary however: *"To prevent naming conflicts, Docker recommends using namespaces to label keys using reverse domain notation."*

To apply a label to a boot2docker node (eg. a docker-machine created node) ssh into the node and edit the file /var/lib/boot2docker/profile adding the `--label` argument:
```
--label com.bobfraser1.apptier=frontend
```
Refer to the file `profile` for an example.

After updating the profile, either reboot the node or restart the Docker daemon with:
```
/etc/init.d/docker restart
```
The command `docker info` can be used to verify that the label has been applied.
## boot2docker and static IP addresses
boot2docker uses DHCP to obtain IP addresses and the address of the node can change after reboot. Static IP addresses are very useful, for example to bind to a DNS address. To set a static IP in boot2docker, edit the file `bootsync.sh` for the appropriate network parameters and copy the file into the node in /var/lib/boot2docker. Reboot the node. After changing the IP address you should update the certificates with `docker-machine regenerate-certificates <node-name>`.

The above should be done before adding your boot2docker node to a swarm cluster.
