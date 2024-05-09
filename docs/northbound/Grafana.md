---
layout: default
parent: Northbound
title: Using Grafana
nav_order: 2
---
# Using Grafana

## Overview

Grafana is an open-source BI tool managed by [Grafana Labs](https://grafana.com/). We utilize Grafana as our default 
demo BI tool. However, directions for other BI tools, such as [Microsoft's PowerBI](PowerBI.md), can be found in our 
[North Bound services](../) section.   

Using Grafana, users can visualize time series data using pre-defined queries and add new queries using SQL.

Directions for importing our demo images dashboards can be found in [import grafana dashboard document](import_grafana_dashboard.md)


## Prerequisites & Links
* 
* [Grafana Support](https://grafana.com/docs/grafana/latest/)

* An [installation of Grafana](https://grafana.com/docs/grafana/latest/setup-grafana/installation/) - We support _Grafana_ version 7.5 and higher, we recommend using _Grafana_ version 9.5.16 or higher.

* An EdgeLake node that provides a REST connection - To configure an EdgeLake node to satisfy REST calls, issue the 
following command on the EdgeLake command line:  
  * `[ip]` and `[port]` are the IP and Port that would be available to REST calls.
  * `[max time]` is an optional value that determines the max execution time in seconds for a call before being aborted.
  * A 0 value means a call would never be aborted and the default time is 20 seconds.
<pre class="code-frame"><code class="language-anylog">&lt;run rest server where
    external_ip=!external_ip and external_port=!anylog_rest_port and
    internal_ip=!ip and internal_port=!anylog_rest_port and
    bind=!rest_bind and threads=!rest_threads and timeout=!rest_timeout
&gt;</code></pre>


## Setting Up Grafana 
<ol start="1">
<li><a href="https://grafana.com/docs/grafana/latest/getting-started/getting-started/" target="_blank">Login to Grafana</a> - 
The default <i>HTTP</i> port that Grafana listens to is 3000 - On a local machine go to <code>http://localhost:3000</code>.
<br>
<div class="image-frame">
    <img src="../../../imgs/grafana_login.png" alt="Grafana page" />
</div>
</li>
<li>In <i>Data Sources</i> section, create a new JSON data source
    <ul style="padding-left: 20px">
        <li>select a JSON data source</li>
        <li>On the name tab provide a unique name to the connection.</li>
        <li>On the URL Tab add the REST address offered by the EdgeLake node (i.e. http://10.0.0.25:32149)</li>
        <li>On the <b>Custom HTTP Headers</b>, name the default database. If no header is set, then all accessible databases to 
   the node will be available to query</li>
    </ul>
<div class="image-frame">
<table>
  <tr>
    <td align="center"><img src="../../../imgs/grafana_datasource_connector.png" alt="Data Source Option" /></td>
    <td align="center"><img src="../../../imgs/grafana_data_source.png" alt="Data Source Config" /></td>
  </tr>
</table>
</div>
</li>
<br/>
<li>Select the <b>Save and Test</b> option that should return a green banner message: ***Data source is working***.
    <div class="image-frame">
        <img src="../../../imgs/grafana_confirmation.png" alt="Confirmation Message" />
    </div>
</li>
</ol>

### Enabling Authentication

Enabling authentication is explained at [Authenticating HTTP requests](../authentication.md#Authenticating-http-requests).

When authentication only REST requests via _username_ and _password_ ([basic authentication](../authentication.md#enabling-basic-authentication-in-a-node-in-the-network)) 
the Grafana configuration should have _basic auth_ enabled.

<div class="image-frame">
    <img src="../../../imgs/grafana_basic_auth.png" alt="basic authentication"  >
</div>

While authentication using [SSL Certificates](../authentication.md#using-ssl-certificates) should have _TLS Client Auth_ and _Skip TLS Verify_ enabled. 

<div class="image-frame">
    <img src="../../../imgs/grafana_auth_image.png" alt="SSL Authentication" />
</div>

**Notes**: Failure to connect may be the result of one of the following
* EdgeLake instance is not running or not configured to support REST calls.
* Wrong IP and Port.
* Firewalls are not properly configured and make the IP and Port not available.
* EdgeLake is configured with authentication detection that is not being satisfied.
* If the connected node is not able to determine tables for the selected database, the dashboard (Edit Panel/Metric Selection) presents "Error: No table connected" in the pull-down menu.

## Using Grafana to visualize EdgeLake

Grafana allows to present data in 2 modes _Time Series_ collects and visualize data values as a function of time, and 
_Table_ format where data is presented in rows and columns.

EdgeLake offers 2 predefined query types ([_Increments_ and _Period_](#using-the-time-series-data-visualization)) which 
users can modify or specify additional queries either "as-is" or using _Additional JSON Data_ options on the panel.

**Additional JSON Data** section(s) provides additional information to the query process. The information provided overrides 
the default behaviour and can pull data from any database managed by EdgeLake (as long as the user maintains valid permissions).  
The additional information is provided using a JSON script with the following attribute names:

<table>
  <tbody>
    <tr>
      <td>dbms</td>
      <td>The name of the logical database to use. Overrides the dbms name in the configuration page.</td>
    </tr>
    <tr>
      <td>table</td>
      <td>The name of the table to use. Overrides the table name in the sql statement.</td>
    </tr>
    <tr>
      <td>type</td>
      <td>The type of the query. The default value is 'sq' and other valid types are: 'increments', 'period' and 'info'.</td>
    </tr>
    <tr>
      <td>sql</td>
      <td>A sql statement to use.</td>
    </tr>
    <tr>
      <td>details</td>
      <td>An EdgeLake command which is not a SQL statement.</td>
    </tr>
    <tr>
      <td>where</td>
      <td>A "WHERE" condition added to the SQL statement. Can add filter or other conditions to the executed SQL.</td>
    </tr>
    <tr>
      <td>functions</td>
      <td>A list of SQL functions to use which overwrites the default functions.</td>
    </tr>
    <tr>
      <td>timezone</td>
      <td>***utc*** (default) or ***default*** to change time values to local time before the transfer to Grafana.</td>
    </tr>
    <tr>
      <td>time_column</td>
      <td>The name of the time column in the Time Series format.</td>
    </tr>
    <tr>
      <td>value_column</td>
      <td>The name of the value column in the Time Series format.</td>
    </tr>
    <tr>
      <td>time_range</td>
      <td>When using a Table view, determines if the query needs to consider the time range. The default value is 'true'.</td>
    </tr>
    <tr>
      <td>servers</td>
      <td>Replacing the network determined servers with a list of Operators (data hosting servers) to use.</td>
    </tr>
    <tr>
      <td>instructions</td>
      <td>Additional EdgeLake query instructions.</td>
    </tr>
  </tbody>
</table>

<div class="image-frame">
    <img src="../../../imgs/grafana_dashboard_layout.png" alt="Grafana Page Layout" />
</div> 

### Blockchain based Visualization

**Creating Network Map**
1. In the _Visualizations_ section, select _Geomap_

2. In the _Metric_  section, select a table name to "query" against

3. Update _Payload_ with the following information
<pre class="code-frame"><code class="language-json">{
    "type" : "map",
    "member" : ["master", "query", "operator", "publisher"],
    "metric" : [0,0,0],
    "attribute" : ["name", "name", "name", "name"]
}
</code></pre>

<div class="image-frame">
    <img src="../../../imgs/grafana_geomap.png" alt="Network Map" />
</div> 

**Creating Table from Blockchain**
1. In the _Visualizations_ section, select _Table_

2. In the _Metric_  section, select a table name to "query" against

3. Update _Payload_ with the following information

<pre class="code-frame"><code class="language-json">{
    "type": "info", 
    "details": "blockchain get operator bring.json [*][cluster] [*][name] [*][company] [*][ip] [*][country] [*][state] [*][city]"
}
</code></pre>

<div class="image-frame">
    <img src="../../../imgs/grafana_blockchain_table.png" alt="Network Map" />
</div>

### Using the Time-Series Data Visualization

**Increments query** (The default query) is used to retriv statistics on the time series data in the selected time 
range. Depending on the number of data point requested, the time range is divided to intervals and the min, max and 
average are collected for each interval and graphically presented.  

<ol start="1">
  <li>In the <i>Visualizations</i> section, select Time series</li>
  <li>In the <i>Metric</i> section, select a table name to “query” against</li>
  <li>Update Payload with the following information
  <pre class="code-frame"><code class="language-json"># Input in Grafana 
{
  "type": "increments",
  "time_column": "timestamp",
  "value_column": "value",
  "grafana": {
    "format_as": "timeseries"
  }
}</code></pre></li>
  <li>Under Query Options, update <i>Max data points</i> (ie limit) otherwise the outcome would look like a single line 
as opposed to clearly showing <i>min / max / avg</i> value(s).
  <br/>
  <br/>
  <div class="image-frame">
    <img src="../../../imgs/grafana_increments_graph.png" alt="Increments Graph"   />
  </div>
  </li>
</ol>

When the query type is set to _increments_, the query being executed on the EdgeLake side is as follows:
<pre class="code-frame"><code class="language-sql">SELECT 
  increments(second, 1, timestamp), max(timestamp) as timestamp, avg(value) as avg_val, min(valu e) as min_val, 
  max(value) as max_val 
FROM 
  percentagecpu_sensor 
WHERE 
  timestamp >= '2024-02-19T19:42: 02.133Z' and timestamp <= '2024-02-19T19:57:02.133Z' 
LIMIT 2128;
</code></pre>

***Period query*** is a query to retrieve data values at the end of the provided time range (or, if not available, before 
and nearest to the end of the time range). The derived time is the latest time with values within the time range. From the 
derived time, the query will determine a time interval that ends at the derived time and provides the avg, min and max values.    
To execute a period query, include the key: 'type' and the value: 'period' in the Additional JSON Data section.  

<ol start="1">
  <li>In the <i>Visualizations</i> section, select <i>Gauge</i></li>
  <li>In the <i>Metric</i> section, select a table name to “query” against</li>
  <li>Update Payload with the following information
<pre class="code-frame"><code class="language-json"># Input in Grafana
{
  "type": "period", 
  "time_column": "timestamp",
  "value_column": "value",
  "grafana" : {
    "format_as" : "timeseries"
  }
}</code></pre>
  </li>
  <li>Under <i>Query Options</i>, update <i>Max data points</i> (ie limit) otherwise the outcome would look like a single line as opposed to clearly showing <i>min / max / avg</i> value(s).
  <div class="image-frame">
    <img src="../../../imgs/grafana_period_gauge.png" alt="Increments Graph"   />
  </div></li>
</ol>

When the query type is set to _period_, the query being executed on the EdgeLake side is as follows:
<pre class="code-frame"><code class="language-sql">SELECT 
    max(timestamp) as timestamp, avg(value) as avg_val, min(value) as min_val, max(value) as max_val 
FROM 
    ping_sensor 
</code></pre>

More information on increments and period types of queries are available in [queries and info requests](https://github.com/AnyLog-co/documentation/blob/master/queries.md#optimized-time-series-data-queries).

## Other Grafana Examples

* Extending query to use where conditions
<pre class="code-frame"><code class="language-json">{
  "type": "increments",
  "time_column": "timestamp",
  "value_column": "value",
  "where": "device_name='ADVA FSP3000R7'",
  "grafana" : {
    "format_as" : "timeseries"
  }
}</code></pre>

* Extend to specify which Functions without time_range to query
<pre class="code-frame"><code class="language-json">{
  "type": "period", 
  "time_column": "timestamp",
  "value_column": "value",
  "time_range": false,
  "functions": ["min", "max", "avg", "count"],
  "grafana" : {
    "format_as" : "timeseries"
  }
}</code></pre>