\l activities-analysis/scripts/xxml.util.q

\d .aa

// High number of significant figures in AltitudeMeters column
\P 20

//
// @desc Parses a TCX file into a kdb+ table. Columns are then modified to match that used in 
//       the Demo Fitness Tracker dashboard in Kx Dashboards Direct.
//
// @param   fName   {string}    Filepath to TCX file.
//
// @return          {table}     Fitness data in kdb+ form.
//
// @example .aa.transformTCX["C:\\Users\\eogha\\kx\\fitbit_files\\34561252610.tcx"]
//
transformTCX:{[fName]
    parsedFile0:enlist first first last first .xxml.rdXML read0 hsym`$fName;
    startTime:.aa.parseStringToTS first parsedFile0`Id;

    tab:delete diffDist,diffTime from
        update Speed:diffDist%("j"$diffTime)%1000000000 from
        update diffTime:deltas Time,diffDist:deltas DistanceMeters,Seconds:("j"$Time-startTime)%1000000000 from
        delete HeartRateBpm,Position from
        update "F"$AltitudeMeters,
        "F"$DistanceMeters,
        HeartRate:{"H"$first x}each HeartRateBpm,
        LatitudeDegrees:"F"${first x}each Position,
        LongitudeDegrees:"F"${last x}each Position,
        Time:{$[count[x]in 24 29;.aa.parseStringToTS x;'"Unknown timestamp format: ",x]}each Time,
        Weight:0, //~ Dummy value
        MinHeartTarget:90,
        MaxHeartTarget:175
        from first value first(parsedFile0`Lap)`Track;
    
    `Time`LatitudeDegrees`LongitudeDegrees`AltitudeMeters`DistanceMeters`HeartRate`Weight`Seconds`Pace`Speed`MinHeartTarget`MaxHeartTarget xcols 
        update Pace:Speed from 
        update Speed:0Nf from tab where Speed=0w
    };


//
// @desc Parses a stringed timestamp from a TCX file. Will throw an error if format does not match one of the examples below.
//
// @param x   {string}        Stringed timestamp.
//
// @return     {timestamp}     Parsed timestamp.
//
// @example     q).aa.parseStringToTS each("2019-01-15T12:17:09.000-05:00";"2019-01-15T12:17:09.000+05:00";"2019-01-15T12:17:09.000Z")
//              2019.01.15D17:17:09.000000000 2019.01.15D07:17:09.000000000 2019.01.15D12:17:09.000000000
//
parseStringToTS:{
    $["Z"=last x;
        .qdate.resolveAs[`timestamp;"%FT%T.%i";x];
        .qdate.resolveAs[`timestamp;"%FT%T.%i%z";(-3_x),-2#x]
        ]
    };

