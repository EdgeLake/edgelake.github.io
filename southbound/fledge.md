# FLEDGE Connection

AnyLog's fledge-connector is based on [fledge-http-north](https://github.com/fledge-iot/fledge-north-http), but instead of 
sending data between FLEDGE nodes, it allows sending data into AnyLog via _POST_ or _PUT_. 

* [Docker Hub](https://hub.docker.com/r/robraesemann/fledge)
* [FLEDGE Documentation](https://fledge-iot.readthedocs.io/en/latest/quick_start/index.html)

## Requirements 
1. EdgeLake deployment to accept data - directions can be found [here](https://github.com/EdgeLake/docker-compose) 
2. FLEDGE & Corresponding plugins
   * FLEDGE
   * FLEDGE-GUI
   * FLEDGE Southbound services OpenWeatherMap
 
## Accepting Data from FLEDGE into EdgeLake
1. Clone AnyLog's fledge-connector
<pre>
   <code>
cd $HOME
git clone https://github.com/AnyLog-co/fledge-connector 
   </code>
</pre>

2. Copy anylog_plugin into _FLEDGE_
<pre>
   <code>
cp -r $HOME/fledge-connector/anylog_rest_conn/ /usr/local/fledge/python/fledge/plugins/north/ 
   </code>
</pre>


3. Access Fledge GUI

4. Begin sending data & view `readings` columns. - We'll be using the OpenWeatherMap asset as an example
<pre>
   <code>
# Sample data being generated
{
 "asset": "OpenWeatherMap",
 "reading": {
   "city": "London",
   "wind_speed": 5.14,
   "clouds": 100,
   "temperature": 289.21,
   "pressure": 1009,
   "humidity": 74,
   "visibility": 10000
 },
 "timestamp": "2022-06-25 19:42:09.916403"
}
   </code>
</pre>

5. Under the _North_ section add `anylog_rest_conn` 
   * **URL** - The IP:Port address to send data to
   * **REST Topic Name** - REST topic to send data to
   * **Asset List**: - Comma separated list of assets to send using this AnyLog connection. If no assets set, then data 
   from all assets will be sent
   * **Database Name** - logical database to store data in AnyLog
![North Plugin Configs](../imgs/fledge_north_plugin.png)

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
