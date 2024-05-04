---
layout: default
title: Query Data 
parent: Commands
nav_order: 4
---
# Query Data

EdgeLake is a SQL native data management platform for real-time / IoT data. 

It allows to query across your entire (edge) data lake of nodes from a single point, as though the entire data-set is 
centralized. 

In addition, EdgeLake provides the ability to optimize SQL queries specifically for real-time data analysis. 

In depth details can be found as part of [AnyLog's documentation](https://github.com/AnyLog-co/documentation/blob/master/queries.md).

## SQL supported functionality
**Projection List**: 
* [increments function](#increments-function)
* Column name
* Min
* Max
* Sum
* Count
* Avg
* Count Distinct
* Range
* Time functions over Column values

**Where Conditions**:
* [period function](#period-function)
* Greater than 
* Less than 
* Equal 
* Not Equal 
* Group By 
* Order By 
* Limit

## Query Format 
**Sample Query**: 
<pre>
    <code>
# Query Format Breakdown 
run client () sql [db_name] format=[output_type] and stats=[true/false] [select statement] 

# Sample Query 
run client () sql litsanleandro format = table "select insert_timestamp, device_name, timestamp, value from ping_sensor limit 100"
    </code>
</pre>

* `run client ()` directs the query to the relevant nodes in the network. When [executing via REST](../examples/rest_examples.md), 
the `--headers "destination: network"` is instead of the `run client ()`.
* `format` dictates the way the result will appear to the user
  * `format=json` returns the results data in a JSON  structure whereas the output data is assigned to the key "Query" and if 
statistics is enabled, it is assigned to the key "Statistics". To remove Statistics froms part of the output include 
`and stats=false`. 
  * `format=json:output	` returns results data in rows whereas each row is a JSON structure - this format is identical to the 
data load structure.
  * `format=json;list` returns results data in an organized in a list, every entry in the list represents a row (use this format 
with [PowerBI](../northbound/PowerBI.md).
  * `format=table` returns results data that's simply organized as a table.

## Built-in Query Functions

### Period Function
The `period` function finds the first occurrence of data before or at a specified date; if a filter-criteria is specified, 
the occurrence needs also to satisfy the filter-criteria, considering the readings in a period of time which is measured 
by the type of the time interval (_Minutes_, _Hours_, _Days_, _Weeks_, _Months_ or _Years_) and the number of units of 
the time interval (i.e. 3 days - whereas time-interval is day and unit is 3).

**Sampel Call**: 
<pre>
  <code>
run client () sql edgex format=table "select min(timestamp), max(timestamp), count(value) from rand_data WHERE period(day, 1, now(), timestamp);"
  </code>
</pre>

### Increments Function
The `increments` functions considers data in increments of time within a time range. The function is compose 3 parts 
`date-column` or column name (ex. _timestamp_), `time-interval` (_Minutes_, _Hours_, _Days_, _Weeks_, _Months_ or _Years_)
and `units` associated with the time interval. 

<pre>
  <code>
run client () sql edgex format=table "select increments(day, 1, timestamp), min(timestamp), max(timestamp), count(value) from rand_data" 
  </code>
</pre>


