# Training Overview
This document and the referenced documents explain the deployment and configuration of an EdgeLake test network.

EdgeLake is deployed using _Docker_ as a pre-configured software package.
To address dynamic and ad-hoc needs, each EdgeLake node provides an interactive environment allowing to dynamically change 
configurations and issue commands and queries. In addition, the interactive environment is extended to send requests and 
inspect responses remotely via REST. Users can use tools like [_cURL_](https://curl.se/) or [Postman](../northbound/using_postman.md) 
as well as a [Remote-CLI](../northbound/remote_cli.md) which is an EdgeLake web based application allowing intuitive and 
simple GUI to interact with nodes in the AnyLog Network.

The training reviews the basic operations with EdgeLake nodes and guides users to manage, monitor and query nodes, metadata and data. This training demonstrates how to make changes to the default configurations to satisfy proprietary processes, data connectors, and specific/domain requirements.

Prerequisites for AnyLog Nodes are detailed [here](prerequisites.md).

**Note**: For the training sessions, remove firewalls restrictions and assign each node to a static IP.

This training includes 2 sessions:

---
layout: default
title: Training
nav_order: 7
has_children: true
---
