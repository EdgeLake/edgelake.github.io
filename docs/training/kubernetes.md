---
layout: default
parent: training
title: Kubernetes
nav_order: 6
---
# Kubernetes

This document demonstrate a deployment of an EdgeLake node as a Kubernetes instance with Minikube and Helm.
The deployment makes EdgeLake scripts persistent (using PersistentVolumeClaim). In a customer deployment, it is recommended 
to predefine the services for each Pod.

* [Requirements](#requirements)
* [Deploying EdgeLake](#deploy-edgelake)
    * [Validate Connectivity](#using-node)
* [Network & Volume Configuration](#networking-and-volume-management)

## Requirements
* <a href="https://kubernetes.io/docs/tasks/tools/" target="_blank">Kubernetes Cluster manager</a> - deploy Minikube with [Docker](https://minikube.sigs.k8s.io/docs/drivers/docker/) 
* <a href="https://helm.sh/" target="_blank">helm</a>
* <a href="https://kubernetes.io/docs/reference/kubectl/" target="_blank">kubectl</a>
* Hardware Requirements - based on <a href="https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin" target="_blank">official documentation</a>

<table>
    <tr>
        <th>Requirements</th>
    </tr>
    <tr>
        <td>2 GB or more RAM</td>
    </tr>
    <tr>
        <td>2 or more CPUs</td>
    </tr>
    <tr>
        <td>Network connectivity between machines in cluster</td>
    </tr>
    <tr>
        <td>Unique hostname / MAC address for every physical node</td>
    </tr>
    <tr>
        <td>Disable swap on machine</td>
    </tr>
</table>

## Deploy EdgeLake
Steps to deploy an EdgeLake container using the <a href="https://github.com/EdgeLake/deployment-k8s/blob/main/deploy_node.sh" target="_blank">deployment script</a>
<ol start="1">
  <li>Clone deployment-k8s
    <pre class="code-frame"><code class="language-shell">git clone https://github.com/EdgeLake/deployment-k8s</code></pre>
  </li>
  <li>Update Configurations - located in <a href="https://github.com/EdgeLake/deployment-k8s/tree/main/configurations" target="_blank">deploymnet-k8s//configurations</a></li>
  <li>(Optional) build helm package - The Github repository already has a Helm package for both the node and volume.  
    <pre class="code-frame"><code class="language-shell">bash deploy_node.sh package deployment-k8s/configurations/edgelake_master.yaml</code></pre>
  </li>
  <li>Deploy Kubernetes volume and container for EdgeLake Node - the deployment script also enables port-forwarding with an optional specification of which IP to proxy against.  
    <pre class="code-frame"><code class="language-shell">bash deploy_node.sh start deployment-k8s/configurations/edgelake_master.yaml [--address={INTERNAL_IP}]</code></pre>
  </li>
  <li>(Optional) Stop deplyment and corresponding proxy process, this will not remove volumes
    <pre class="code-frame"><code class="language-shell">bash deploy_node.sh stop deployment-k8s/configurations/edgelake_master.yaml</code></pre>
  </li>
</ol>


