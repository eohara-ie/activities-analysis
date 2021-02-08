\l activities-analysis/scripts/parseTCX.q
opts:(enlist`)!enlist(::);
//if[not`file in key opts:.Q.opt .z.x;'"Please include '-file' parameter with filepath(s).";exit 1];
//if[not`dash in key opts:.Q.opt .z.x;'"Please include '-dash' parameter with port of Dashboards database process.";exit 1];

//
//! Change these values.
//
opts[`file]:`C:/Users/eohara/Documents/fitbit/37059150822.tcx`C:/Users/eohara/Documents/fitbit/37289863038.tcx`C:/Users/eohara/Documents/fitbit/37376073373.tcx;
opts[`dash]:6812;

dash:hopen opts`dash;
tbls:.aa.transformTCX peach opts`file;
numTbls:$[0h~type tbls;count tbls;1&count tbls];
tbls:$[0h~type tbls;raze tbls;tbls];
dash(set;`Rundata;tbls);
0N!string[count tbls]," rows now available in KX Dashboards for ",string[numTbls]," activities starting on ",string[`date$first tbls`Time],".";
0N!"Please open/refresh your Demo Fitness Tracker Dashboard.";