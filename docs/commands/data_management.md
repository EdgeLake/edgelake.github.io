## Data management commands

The data management commands organize the node's local databases and provide the functionalities to monitor the state of the
data during ingestion, storage and query.

## Associate a physical database to a logical database
The **connect dbms** command associates a physical database to a logical database. This process is per node, to determine,
when a data table is created, the physical database to host the table's data.

### Connect DBMS
**Usage**:
<pre>
    <code>
connect dbms [db name] where type = [db type] and user = [db user] and password = [db passwd] and ip = [db ip] and port = [db port] and memory = [true/false] and connection = [db string]
    </code>
</pre>

**Explanation**: Associate a physical database to a logical database.

**Examples**:
<pre>
    <code>
connect dbms test where type = sqlite
connect dbms sensor_data where type = psql and user = anylog and password = demo and ip = 127.0.0.1 and port = 5432
    </code>
</pre>








