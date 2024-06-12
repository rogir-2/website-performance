# Data Collection 
This section aims to demonstrate the data acquisition process, outlining the steps taken to extract and load data.

### Data Source

I personally know the client and they shared encrypted and password protected zip file containing csv data. File name is “sitelog-Dec-2023.”

The csv consists of 6 fields and 2319 entries / records.
<table>
    <tr>
        <th>Fields</th>
        <th>Description</th>
    </tr>
    <tr>
        <td>session_id</td>
        <td>A unique identifier for the session</td>
    </tr>
    <tr>
        <td>created_at</td>
        <td>The timestamp when the session was created</td>
    </tr>
    <tr>
        <td>device</td>
        <td>The device used during the session</td>
    </tr>
    <tr>    
        <td>load_time</td>
        <td>The load time of the session</td>
    </tr>   
    <tr>
        <td>view_time</td>
        <td>The view time of the session</td>
    <tr>
        <td>lead_status</td>
        <td>Lead registration (0/1)</td>
    </tr>
</table>

### Load to MySQL (CSV -> MYSQL)
Before proceed with the data import, I've taken the initiative to set up the initial database named "web" and an empty table "session" with the exact number of columns required. I've ensured that each column is set to the default data type "varchar" to accommodate a wide range of data.