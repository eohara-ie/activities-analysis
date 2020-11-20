//
// Store scratchpad code here.
//
.aa.transform each{`$"exercise_tcx_file_",string[x],".tcx"}each til -9+count[system"dir"]; // Cycle through each file, following current naming convention

.d.prcl.removeFuncFromTimer[`doCleanse;1b];

Rundata:RundataRaw

h:hopen 6812

h(set;`Rundata;Rundata)

h(set;`parseTimestamp;.axq.parseTimestamp)

h".z.p"

.qdate

parseStringToTS:{
    $["Z"=last x;
        .qdate.resolveAs[`timestamp;"%FT%T.%i";x];
        .qdate.resolveAs[`timestamp;"%FT%T.%i%z";(-3_x),-2#x]
        ]
    };

h

h(:;`resolveAs;.qdate.resolveAs)

//
// From remote scratchpad
//
meta Rundata

5#Rundata

("SZZJFJSSPFFFFJJJ";enlist ",") 0: read0 `$"activity-1.csv"

tRaw:("SZZJFJSSPFFFFJJJ";enlist ",") 0: read0 `$"activity-1.csv"

RundataOld

RundataRaw

\a

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

\p

delete diffDist,diffTime from
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
        MinHeartTarget:min HeartRate,
        MaxHeartTarget:max HeartRate
        from Rundata


.axq.parseTimestamp each Rundata`Time


.axq.parseTimestamp


\p
//
// From remote scratchpad 2nd Nov
//

startTime:2020.04.23D13:30:11.000000000
Rundata:delete diffDist,diffTime from update Speed:diffDist%("j"$diffTime)%1000000000 from update diffTime:deltas Time,diffDist:deltas DistanceMeters,Seconds:("j"$Time-startTime)div 1000000000 from Rundata

\c 50 2000

select from tabE where Speed=0w


0.36%

("j"$0D00:00:00.122000000)%1000000000


read0 hsym `$"C:\\Users\\eohara\\dash\\sample\\data\\geo1.csv"

save `Rundata.csv

(hsym `$"C:\\Users\\eohara\\dash\\sample\\data\\geo1.csv")0: csv 0: Rundata

