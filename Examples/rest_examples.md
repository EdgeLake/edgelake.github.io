 # Using REST

Users can interact with the nodes in the network using REST.

Using REST, users can execute EdgeLake commands over HTTP on any node in the network that is configured to satisfy REST 
requests.

## Prerequisites
* A REST client software like [_cUrL_](https://man7.org/linux/man-pages/man1/curl.1.html) or [_Postman_](https://www.postman.com/)
* An EdgeLake Node that provides a REST connection. To configure an EdgeLake Node to satisfy REST calls, issue the 
following command on the EdgeLake command line:
<pre>
    <code>
run rest server where external_ip = [external_ip ip] and external_port = [external port] and internal_ip = [internal ip] and internal_port = [internal port] and timeout = [timeout] and ssl = [true/false] and bind = [true/false] 
    </code>
</pre>

## HTTP methods supported
EdgeLake commands are supported using the HTTP methods `GET`, `PUT` and `POST`.

* `GET` is used to retrieve information.  
* `PUT` is used to add data to nodes in the network.  
* `POST` is used as a default method to execute all other EdgeLake commands.  

<table>
  <thead>
    <tr>
      <th>HTTP Method</th>
      <th>EdgeLake commands</th>
      <th>Comments</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>GET</td>
      <td>sql</td>
      <td>Issue queries to data hosted by nodes of the network</td>
    </tr>
    <tr>
      <td></td>
      <td>get</td>
      <td>Retrieve information from nodes members of the network</td>
    </tr>
    <tr>
      <td></td>
      <td>blockchain get</td>
      <td>Query the metadata</td>
    </tr>
    <tr>
      <td></td>
      <td>help</td>
      <td>Help on the ANyLog commands</td>
    </tr>
    <tr>
      <td>POST</td>
      <td>set</td>
      <td>Set values or change status</td>
    </tr>
    <tr>
      <td></td>
      <td>reset</td>
      <td>Reset values or status</td>
    </tr>
    <tr>
      <td></td>
      <td>blockchain</td>
      <td>Manage metadata commands (note the `blockchain get` is supported using GET)</td>
    </tr>
    <tr>
      <td>PUT</td>
      <td>command</td>
      <td>publish time-series data to node</td>
    </tr>
  </tbody>
</table>

## Sample cURL Requests

### GET requests 

* `get status` - check whether a node is active or not
<pre>
    <code>
curl --location --request GET '10.0.0.78:7849' \
    --header 'command: get status' \
    --header 'User-Agent: AnyLog/1.23'
    </code>
</pre>
* `blockchain get operator where company='New Company'` - get list of all operators owned by _New Company_
<pre>
    <code>
curl --location --request GET '10.0.0.78:7849' \
    --header 'command: blockchain get operator where company="New Company" \
    --header 'User-Agent: AnyLog/1.23'
    </code>
</pre> 
* `sql new_company format=table "select * from rand_data where timestamp >= NOW() - 1 minute limit 5;"` -
Sample `SELECT` request
<pre>
    <code> 
curl --location --request GET '10.0.0.78:7849' \
    --header 'command:sql new_company format=table "select * from rand_data where timestamp >= NOW() - 1 minute limit 5;"' \
    --header 'User-Agent: AnyLog/1.23' \
    --header 'destination: network'
    </code>
</pre> 









 
 
