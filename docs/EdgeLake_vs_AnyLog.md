# EdgeLake vs AnyLog

EdgeLake empowers businesses to unlock the true potential of their edge data. By turning the edge into a virtual data 
lake, companies extract real-time insights from their distributed edge data without centralizing the data.

An EdgeLake Network seamlessly captures, stores, and manages data at its source, while providing a complete and unified 
view of the data to satisfy SQL queries from edge and cloud applications, as if the data is organized in a centralized 
database. 

Using EdgeLake, companies manage their data on each distributed edge node using pre-configured services and gain 
real-time insight from their distributed edge data without dependency on the cloud.


## EdgeLake vs AnyLog

### General 
<table>
  <tr>
    <td></td>
    <td><strong>EdgeLake</strong></td>
    <td><strong>AnyLog</strong></td>
  </tr>
  <tr>
    <td style="text-align: left;">Master / Blockchain</td>
    <td style="text-align: center;">+</td>
    <td style="text-align: center;">+</td>
  </tr>
  <tr>
    <td style="text-align: left;">Operator</td>
    <td style="text-align: center;">+</td>
    <td style="text-align: center;">+</td>
  </tr>
  <tr>
    <td style="text-align: left;">Query</td>
    <td style="text-align: center;">+</td>
    <td style="text-align: center;">+</td>
  </tr>
  <tr>
    <td style="text-align: left;">Publisher</td>
    <td></td>
    <td style="text-align: center;">+</td>
  </tr>
</table>


### Breakdown
<table>
  <thead>
    <tr>
      <th></th>
      <th></th>
      <th style="text-align: center"><b>EdgeLake</b></th>
      <th style="text-align: center"><b>AnyLog</b></th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td rowspan="5"><b>Networking</b></td>
      <td>TCP</td>
      <td style="text-align: center;">+</td>
      <td style="text-align: center;">+</td>
    </tr>
    <tr>
      <td>REST</td>
      <td style="text-align: center;">+</td>
      <td style="text-align: center;">+</td>
    </tr>
    <tr>
      <td>Message Broker</td>
      <td style="text-align: center;">+</td>
      <td style="text-align: center;">+</td>
    </tr>
    <tr>
      <td><a href="southbound/kubearmor.md">gRPC</a></td>
      <td style="text-align: center;">+</td>
      <td style="text-align: center;">+</td>
    </tr>
    <tr>
      <td><a href="southbound/syslog.md">Syslog</a></td>
      <td style="text-align: center;">+</td>
      <td style="text-align: center;">+</td>
    </tr>
    <tr>
      <td rowspan="4"><b>Database</b></td>
      <td>SQLite</td>
      <td style="text-align: center;">+</td>
      <td style="text-align: center;">+</td>
    </tr>
    <tr>
      <td>PostgresSQL</td>
      <td style="text-align: center;">+</td>
      <td style="text-align: center;">+</td>
    </tr>
    <tr>
      <td>MongoDB</td>
      <td style="text-align: center;">+</td>
      <td style="text-align: center;">+</td>
    </tr>
    <tr>
      <td>File store for blobs</td>
      <td style="text-align: center;">+</td>
      <td style="text-align: center;">+</td>
    </tr>
    <tr>
      <td rowspan="5"><b>Core</b></td>
      <td>Data Partitioning</td>
      <td style="text-align: center;">+</td>
      <td style="text-align: center;">+</td>
    </tr>
    <tr>
      <td>Node Monitoring</td>
      <td style="text-align: center;">+</td>
      <td style="text-align: center;">+</td>
    </tr>
    <tr>
      <td>High-Availability of Operator Nodes</td>
      <td></td>
      <td style="text-align: center;">+</td>
    </tr>
    <tr>
      <td>Horizontal Data Distribution</td>
      <td></td>
      <td style="text-align: center;">+</td>
    </tr>
    <tr>
      <td>Built-in Overlay Network</td>
      <td></td>
      <td style="text-align: center;">+</td>
    </tr>
    <tr>
      <td rowspan="5"><b>Security</b></td>
      <td>HTTP Authentication</td>
      <td></td>
      <td style="text-align: center;">+</td>
    </tr>
    <tr>
      <td>Key-Based Authentication</td>
      <td></td>
      <td style="text-align: center;">+</td>
    </tr>
    <tr>
      <td>Encrypting network messages</td>
      <td></td>
      <td style="text-align: center;">+</td>
    </tr>
    <tr>
      <td>Signed blockchain policies</td>
      <td></td>
      <td style="text-align: center;">+</td>
    </tr>
    <tr>
      <td>Group / individual permissions</td>
      <td></td>
      <td style="text-align: center;">+</td>
    </tr>
  </tbody>
</table>

<h3 align="center"><a href="https://anylog.co/download-anylog/" target="_blank">Download AnyLog</a>, the enterprise version of EdgeLake</h3>
