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

**Details**: [Connect to a local DBMS](https://github.com/AnyLog-co/documentation/blob/master/sql%20setup.md#connecting-to-a-local-database).

### Get associations between logical and physical databases

**Usage**:
<pre>
    <code>
get databases
    </code>
</pre>

**Explanation**: Get the list of connected databases on this node.

**Examples**:
<pre>
    <code>
get databases
    </code>
</pre>

## Partition Data

### Partition table's data by time
**Usage**:
<pre>
    <code>
partition [dbms name] [table name] using [column name] by [time interval]
    </code>
</pre>

**Explanation**: 
* Partition a table or a group of tables by time interval
* Time intervals options are: year, month, week, days in a month

**Examples**:
<pre>
    <code>
partition lsl_demo ping_sensor using timestamp by 2 days
partition lsl_demo ping_sensor using timestamp by month
partition lsl_demo * using timestamp by month
    </code>
</pre>

**Details**: [Data Partitioning](https://github.com/AnyLog-co/documentation/blob/master/anylog%20commands.md#partition-command).

### Get partition information
**Usage**:
<pre>
    <code>
get partitions [info string]
    </code>
</pre>

**Explanation**: Get partitions declarations for all tables or a designated table or the recently dropped partitions.

**Examples**:
<pre>
    <code>
get partitions
get partitioned dropped
get partitions where dbms = lsl_demo and table = ping_sensor
    </code>
</pre>

**Details**: [Data Partitioning](https://github.com/AnyLog-co/documentation/blob/master/anylog%20commands.md#partition-command).

