\l scripts/parseTCX.q
demoDataPort:6812; //! Replace
dash:hopen demoDataPort;
tcxFile:"C:\\Users\\eogha\\kx\\fitbit_files\\34595820021.tcx"; //! Replace
dash(set;`Rundata;table:.aa.transformTCX[tcxFile]);
0N!string[count table]," rows of fitness data now available in Kx Dashboards Direct for activity starting on ",string `date$first table`Time;
0N!"Please open/refresh your Demo Fitness Tracker dashboard UI.";
exit 0;