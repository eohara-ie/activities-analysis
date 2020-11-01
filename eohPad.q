//
// Store scratchpad code here.
//
.aa.transform each{`$"exercise_tcx_file_",string[x],".tcx"}each til -9+count[system"dir"]; // Cycle through each file, following current naming convention

.d.prcl.removeFuncFromTimer[`doCleanse;1b];