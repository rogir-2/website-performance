# Data Cleaning & Wrangling

This section outlines all the data manipulation and transformation done on the dataset.

### Pre-Modification Measures
Before any manipulation and transformation were made, measures were taken to ensure data integrity. These measures included:

+ **Creation of Backup Table**<br> A backup table "session" with the exact columns from the imported dataset was created. This served as a safeguard against unintended changes to the original dataset.

## Cleaning Steps Applied:

**Data Inconsistency**<br>
The "distinct" function was utilised to inspect categorical variables and update them. E.g. device field had values "m" and "d."<br>

**Duplicate Record Removal**<br>
192 duplicate records were identified and removed based on multiple criteria, including session_id, created_at, device, and status. Remain 2118 unique records.<br>

**Handled Null & Empty Values**<br>
Fields with null values were identified and addressed. Appropriate measures were taken, including filling null with average instead of dropping them, considering it is a small dataset.<br>

**Outlier Removal**<br>
Negative, zero and extreme values in the "load_time" and "view_time" variables were examined and removed to ensure data integrity.<br>

**Time Unit Conversion**<br>
The "load_time" and "view_time" variables were converted from milliseconds to seconds for consistency and easy interpretation.<br>

**Data Type Modication**<br>
Data type were inspected for categorical and numerical variables, and appropriate changes made to enhance storage efficiency and query performance. 

Please reflect over the data dictionary below:

<table>
    <tr>
        <th>Fields</th>
        <th>Before</th>
        <th>After</th>
    </tr>
    <tr>
        <td>session_id</td>
        <td>INT</td>
        <td>INT NL AI PRIMARY KEY</td>
    </tr>
    <tr>
        <td>created_at</td>
        <td>VARCHAR(255)</td>
        <td>DATE</td>
    </tr>
    <tr>
        <td>device</td>
        <td>VARCHAR(255)</td>
        <td>VARCHAR(10)</td>
    </tr>
    <tr>
        <td>load_time</td>
        <td>VARCHAR(255)</td>
        <td>DECIMAL(10,1)</td>
    </tr>
    <tr>
        <td>view_time</td>
        <td>VARCHAR(255)</td>
        <td>DECIMAL(10,1)</td>
    </tr>
    <tr>
        <td>status</td>
        <td>VARCHAR(255)</td>
        <td>TINYINT UNSIGNED</td>
    </tr>
</table>