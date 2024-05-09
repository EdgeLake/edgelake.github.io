---
layout: default
parent: Northbound
title: Using Postgres to view Data (Tableau)
nav_order: 5
---
# PSQL Connector & Tableau Visualization
  
For software that doesn't support REST requests, but does support PostgresSQL connector graphs can be generated through 
the <code>system_query</code> database. To connect <code>system_query</code> in  PostgresSQL

<pre class="code-frame"><code class="language-anylog">db_ip = 127.0.0.1 
db_port = 5432 
db_user = admin 
db_passwd = passwd
connect dbms system_query where type=psql and ip=!db_ip and port=!db_port and user=!db_user and password=!db_passwd</code></pre>


## Setting up Postgres 
<ol start="1">
   <li><a href="https://www.postgresqltutorial.com/install-postgresql/" target="_blank">Install PostgresSQL</a></li>
   
   <li>In <code>postgresql.conf</code>, update <bold>listen_address</bold> value to allow remote access
      <pre class="code-frame"><code class="language-config">listen_addresses = '*'</code></pre>
   </li>
   
   <li>In <code>pg_hba.conf</code>, add the following line at the bottom of the paga
      <pre class="code-frame"><code class="language-config">host    all            all             0.0.0.0/0               md5</code></pre>
   </li>
   
   <li>Restart PostgresSQL instance</li> 
</ol>

## Executing Query
0. On AnyLog connect `system_query` to Postgres database 
```anylog
connect dbms psql anylog@127.0.0.1:demo 5432 system_query
```

1. Execute query - [to run in repeat](../alerts%20and%20monitoring.md#repeatable-queries)
```anylog
AL aiops-single-node > run client () sql aiops format=table and table=new_table and drop=true "select increments(hour, 1, timestamp), min(timestamp), min(value), avg(value), max(value) from fic11_mv where timestamp >= NOW() - 1 day"
```

2. Utilize explain query to view how the results are generated
```anylog
AL aiops-single-node > query explain 

07 Remote DBMS    : aiops
07 Remote Table   : fic11_mv
07 Source Command : select increments(hour, 1, timestamp), min(timestamp), min(value), avg(value), max(value) from fic11_mv where timestamp >= NOW() - 1 day
07 Remote Query   : select date_trunc('day',timestamp), (extract(hour FROM timestamp)::int / 1), min(timestamp), min(value), SUM(value), COUNT(value), max(value) from fic11_mv where timestamp >= '2022-01-17T18:31:31.442147Z' group by 1,2
07 Local Create   : create table new_table (increments_1_trunc timestamp without time zone, increments_1_extract integer, min_2 timestamp without time zone, min_3 double precision, SUM__value numeric, COUNT__value integer, max_5 double precision);
07 Local Query    : select min(min_2), min(min_3), SUM(SUM__value) /NULLIF(SUM(COUNT__value),0), max(max_5) from new_table group by increments_1_trunc,increments_1_extract order by increments_1_trunc,increments_1_extract
```
Disclaimer: [Full list of SQL options](../queries.md#query-options)

## Extract Data onto Tableau
1. [Download & Install Tableau](https://www.tableau.com/products/desktop/download)
2. Under _Data_ → _Data Sources_ select PostgresSQL connector type 

| ![data](../../imgs/tableau_img2a.png) | ![data source](../../imgs/tableau_img2b.png) |
| --- | --- |

3. Fill-out the information to connect to database & Press "Ok"
![connection information](../../imgs/tableau_img3.png)


4. Double-click on the table you want to use (in this case `new_table`) and goto worksheet
![prep worksheet data](../../imgs/tableau_img4.png)


## Generating Graphs

The `system_query` database gathers (query) results from the different AnyLog instances to generate a unified dataset for 
the user. As such, generating graphs from the final results is a bit complicated. 
   * Min 2 - is column `MIN(timestamp)`
   * Min 3 - is column `MIN(value)`
   * SUM(SUM__VALUE) / COUNT(new_table_count) -- is column `AVG(value)`
   * MAX 5 - is column `MAX(value)`
![column explanation](../../imgs/tableau_img5.png)

To generate a graph, use "Min 2" as _Columns_ and all others for _Rows_
![generated image](../../imgs/tableau_img6.png)