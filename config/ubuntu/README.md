# Apply custom labels in ubuntu
nginx-app uses the label `com.bobfraser1.apptier` to control container placement. Label names are arbitrary however: *"To prevent naming conflicts, Docker recommends using namespaces to label keys using reverse domain notation."*

Ubuntu 15.10 and later uses systemd to control services. To add a custom label you will override the ExecStart property in the config file for the docker service and add the label.

To add a custom label, edit the file docker-override.conf for your label and copy the file into the node in /etc/systemd/system/docker.service.d. (Create the directory path if necessary.) Check the original config file /lib/systemd/system/docker.service and resolve any merge conflicts for the ExecStart property.

Restart the docker daemon with:
```
sudo systemctl daemon-reload
sudo systemctl restart docker
```
The command `docker info` can be used to verify that the label has been applied.
