# Kubernetes Deployment 

This document discusses how to build a kubernetes/helm deployment of EdgeLake.

## Requirements
<ul>
    <li><a href="https://kubernetes.io/docs/tasks/tools/" target="_blank">Kubernetes Cluster manager</a> - deploy Minikube with <a href="https://minikube.sigs.k8s.io/docs/drivers/docker/" target="_blank">Docker</a></li>
    <li><a href="https://helm.sh/" target="_blank">Helm</a></li>
    <li><a href="https://kubernetes.io/docs/reference/kubectl/" target="_blank">kubectl</a></li>
    <li>Hardware Requirements - based on <a href="https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin" target="_blank">official documentation</a></li>
</ul>

<table>
    <thead>
        <tr>
            <th><b>Requirements</b></th>
        </tr>
    </thead>
    <tbody>
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
    </tbody>
</table>
