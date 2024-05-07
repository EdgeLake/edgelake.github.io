---
layout: default
parent: Southbound Examples
title: FLEDGE
nav_order: 2
---
# FLEDGE Connection

AnyLog's fledge-connector is based on [fledge-http-north](https://github.com/fledge-iot/fledge-north-http), but instead of 
sending data between FLEDGE nodes, it allows sending data into AnyLog via _POST_ or _PUT_. 

* [Docker Hub](https://hub.docker.com/r/robraesemann/fledge)
* [FLEDGE Documentation](https://fledge-iot.readthedocs.io/en/latest/quick_start/index.html)

## Requirements 
<ol> 
<li>EdgeLake deployment to accept data - directions can be found <a href="https://github.com/EdgeLake/docker-compose" target="_blank">here</a></li> 
<li>FLEDGE & Corresponding plugins
   <ul style="padding-left: 20px;">
   <li>FLEDGE</li>
   <li>FLEDGE-GUI</li>
   <li>FLEDGE Southbound services OpenWeatherMap</li>
</ul></li></ol>

## Accepting Data from FLEDGE into EdgeLake
<ol>
<li>Clone AnyLog's fledge-connector
<pre class="code-frame"><code class="language-shell">cd $HOME
git clone https://github.com/AnyLog-co/fledge-connector</code></pre>
</li>

<li>Copy anylog_plugin into <i>FLEDGE</i>
<pre class="code-frame"><code class="language-shell">cp -r $HOME/fledge-connector/anylog_rest_conn/ /usr/local/fledge/python/fledge/plugins/north/</code></pre>
</li>

<li>Access Fledge GUI</li></ol>

![fledge_gui.jpeg](..%2F..%2Fimgs%2Ffledge_gui.jpeg)

<ol start="4">
<li>Begin sending data & view `readings` columns. - We'll be using the OpenWeatherMap asset as an example
<pre class="code-frame"><code class="language-json"># Sample data being generated
&lt;
 "asset": "OpenWeatherMap",
 "reading": &lt;
   "city": "London",
   "wind_speed": 5.14,
   "clouds": 100,
   "temperature": 289.21,
   "pressure": 1009,
   "humidity": 74,
   "visibility": 10000
 &gt;,
 "timestamp": "2022-06-25 19:42:09.916403"
&gt;
</code></pre></li>

<li>Under the _North_ section add `anylog_rest_conn`
   <ul style="padding-left: 20px">
      <li><b>URL</b> - The IP:Port address to send data to</li>
      <li><b>REST Topic Name</b> - REST topic to send data to</li>
      <li><b>Asset List</b> - Comma separated list of assets to send using this AnyLog connection. If no assets set, then data 
   from all assets will be sent</li>
   <li><b>Database Name</b> - logical database to store data in AnyLog</li>
   </ul>
</li></ol>

![North Plugin Configs](../../imgs/fledge_north_plugin.png)

At this point data will send into EdgeLake via REST. 


## Configuring EdgeLake REST  Client
When sending data via _PUT_, all that's required is for EdgeLake to accept REST requests - which is done by default. 

When sending data via _POST_, an message client accepting the requests should be running. 

**Sample Message Client**:
<pre>
   <code>
&lt;msg client where broker=rest and user-agent=anylog and log=!mqtt_log and topic=(
    name=fledge-weather and
    dbms=!default_dbms and
    table="bring [asset]" and
    column.timestamp.timestamp="bring [timestamp]" and
    column.city=(type=str and value="bring [readings][city]" and optional=true) and
    column.clouds=(type=float and value="bring [readings][clouds]" and optional=true) and
    column.humidity=(type=float and value="bring [readings][humidity]" and optional=true) and
    column.pressure=(type=float and value="bring [readings][pressure]" and optional=true) and
    column.temperature=(type=float and value="bring [readings][temperature]" and optional=true) and
    column.visibility=(type=float and value="bring [readings][visibility]" and optional=true) and
    column.wind_speed=(type=float and value="bring [readings][wind_speed]" and optional=true)
)&gt;
   </code>
</pre>

EdgeLake deployment comes with a sample connection to Fledge that accepts data from both OpenWeather and Random southbound service.        
