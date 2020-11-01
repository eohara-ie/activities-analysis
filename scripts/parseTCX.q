CURRENT_DIR:system"dir" //! Windows-only. To include OS check before this point
system"cd C:\\Users\\eohara\\Documents\\fitbit" //! Windows-only(the directory of the TCX files)

\d .aa

\P 20 // High number of significant figures in AltitudeMeters column


//
// @desc Parses a TCX file and publishes reference and sensor tables to subscribers(kxsTP).
//
// @param fName     {symbol}    TCX file name.
//
// @example .aa.transformPub[`exercise_tcx_file_5.tcx]
//
transformPub:{[fName]
    parsedFile0:enlist first first last first .xml.rdXML[read0`$":",string fName];

    pubRef:delete Creator,Id,Sport,Lap from 
        update startTime:{$[count[x]in 24 29;.aa.parseStringToTS x;'"Unknown timestamp format: ",x]}each Id,
        sport:{`$-1 _ 1 _ x}each Sport,
        calories:{"H"$x`Calories}each Lap,
        totaldistanceMetres:{"F"$x`DistanceMeters}each Lap,
        totalTimeSeconds:{"F"$x`TotalTimeSeconds}each Lap,
        intensity:{`$x`Intensity}each Lap,
        updateTS:.z.p
        from parsedFile0;
    
    .msg.pub[`activityTelemetryRef;pubRef];
    
    pub:`time`startTime xcols 
        `altitudeMetres`distanceMetres`heartRateBpm`time`startTime`latitudeDegrees`longitudeDegrees`updateTS xcol 
        delete Position from 
        update startTime:first pubRef`startTime,
        "F"$AltitudeMeters,
        "F"$DistanceMeters,
        HeartRateBpm:{"H"$first x}each HeartRateBpm,
        LatitudeDegrees:"F"${first x}each Position,
        LongitudeDegrees:"F"${last x}each Position,
        Time:{$[count[x]in 24 29;.aa.parseStringToTS x;'"Unknown timestamp format: ",x]}each Time,
        updateTS:.z.p 
        from first value first(parsedFile0`Lap)`Track;
    
    .msg.pub[`activityTelemetry;pub];
    };


//
// @desc Parses a TCX file and saves down sensor table as a CSV. The columns are modified to match the table used in 
//       the Fitness demonstation dashboard on https://demo.kx.com.
//
// @param fName     {symbol}    TCX file name.
//
// @return          {symbol}    File symbol.
//
// @example .aa.transformSaveToCSV[`exercise_tcx_file_5.tcx]
//
transformSaveToCSV:{[fName]
    parsedFile0:enlist first first last first .xml.rdXML[read0`$":",string fName];
    startTime:.aa.parseStringToTS first parsedFile0`Id;

    pub:delete diffDist,diffTime from
        update Speed:diffDist%("j"$diffTime)div 1000000000 from
        update diffTime:deltas Time,diffDist:deltas DistanceMeters,Seconds:("j"$Time-startTime)div 1000000000 from
        delete HeartRateBpm,Position from
        update "F"$AltitudeMeters,
        "F"$DistanceMeters,
        HeartRate:{"H"$first x}each HeartRateBpm,
        LatitudeDegrees:"F"${first x}each Position,
        LongitudeDegrees:"F"${last x}each Position,
        Time:{$[count[x]in 24 29;.aa.parseStringToTS x;'"Unknown timestamp format: ",x]}each Time,
        Weight:0, //~ Dummy value
        MinHeartTarget:110, //~ Dummy value
        MaxHeartTarget:165 //~ Dummy value
        from first value first(parsedFile0`Lap)`Track;
    
    pub:update Pace:Speed from update Speed:0Nf from pub where Speed=0w;

    0:[`:geo1.csv;csv 0: `Time`LatitudeDegrees`LongitudeDegrees`AltitudeMeters`DistanceMeters`HeartRate`Weight`Seconds`Pace`Speed`MinHeartTarget`MaxHeartTarget xcols pub]
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


