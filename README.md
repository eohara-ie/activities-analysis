# activities-analysis
Parsing TCX files from GPS-tracked activites on Fitbit in kdb+/q, and visualising them using Kx Dashboards Direct.

Thanks to Jamie Sheridan, Kx for the XML parser code.

## Prerequisites

Install and start the following
- [Kx Dashboards](https://code.kx.com/dashboards/)
- [Kx Developer](https://code.kx.com/developer/)

Developer contains a date-parsing library needed to transform the TCX file.

## Gather Required Variables

When Kx Dashboards starts, you should see a `Demo Data` window appear. In the window run 
```
\p
```
to obtain the port `Demo Data` is listening on. Take note of this value as we will connect to this process later.

Next, retrieve the filepath of your activity data file(should have a .tcx file extension). Please see [this link](https://help.fitbit.com/articles/en_US/Help_article/1133.htm#) for information on how to export your activity data from Fitbit. 

If on Windows, make sure any back-slashes are escaped with an extra `\` like below:
```
"C:\Users\eogha\kx\fitbit_files\34561252610.tcx" <-- Before
"C:\\Users\\eogha\\kx\\fitbit_files\\34561252610.tcx" <-- After
```

## How to Use

Clone this repository in Developer and open `run.q`. Replace the value in lines 2 and 4 with your own, ensuring the filepath is a string and the port is a long.

Save and close `run.q`.

Right-click `run.q` in the workspace file tree -> Code -> Run. You should see logging similar to below:
```
"5221 rows of fitness data now available in Kx Dashboards Direct for activity starting on 2020.09.27"
"Please open/refresh your Demo Fitness Tracker dashboard UI."
```
Your fitness data will now be visualised in the pre-built Demo Fitness Tracker dashboard. If you wish to edit this dashboard, simply add `edit/` before the `#` in your URL.

## Note

- Your activity data now exists in-memory in the Demo Data process, but will not be persisted if the process is restarted.

- Please raise an issue in this repository if you have any problems/suggestions.

- Data from other fitness trackers has not been tested with
