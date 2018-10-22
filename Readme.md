# Create Kubernetes Cluster with Vagrant

Run it;

```bash
cd Provisioning
vagrant up
```

After all machines are up reload them: `vagrant reload`

## Playground
1) Run `kubectl apply -f apps/1-configmap.yml` command to disable ssl-redirect forcement on Nginx Ingress Controller.
2) Run `kubectl apply -f apps/2-metallb-configmap.yml` command to configure [MetalLB](https://metallb.universe.tf)
3) Run `kubectl apply -f apps/3-basic-app.yml` command to create custom service and deployment. It's Python Flask app and used to write hostname.
4) Run `kubectl apply -f apps/4-ingress.yml` command to create Nginx Ingress Controller.

Reach and application with *Load Balancer IP address* type `kubectl get services --namespace ingress-nginx`. Output should be;

```bash
NAME                    TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)                      AGE
service/ingress-nginx   LoadBalancer   10.107.225.26   172.81.81.101   80:32555/TCP,443:30497/TCP   15m
```

Get **EXTERNAL-IP** value and run it;

```bash
while true; do sleep 1; curl http://172.81.81.101/basic-app;echo -e '\n';done
```

Expected result, two different hostname should be written! For instance;

```bash
<h1>Hostname: basic-app-deployment-b9c7c9bb4-sssmx</h1>
<h1>Hostname: basic-app-deployment-b9c7c9bb4-9xvtc</h1>
<h1>Hostname: basic-app-deployment-b9c7c9bb4-sssmx</h1>
<h1>Hostname: basic-app-deployment-b9c7c9bb4-9xvtc</h1>
<h1>Hostname: basic-app-deployment-b9c7c9bb4-sssmx</h1>
<h1>Hostname: basic-app-deployment-b9c7c9bb4-9xvtc</h1>
<h1>Hostname: basic-app-deployment-b9c7c9bb4-sssmx</h1>
```

On the other terminal panel, write `vagrant ssh worker02` and connect to worker machine. After that get the running containers with `sudo docker container ls` command and catch the Flask app container id kill it. Service will continue to respond.
