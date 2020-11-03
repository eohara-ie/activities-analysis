using `util;

.xml.mkAsc:{while[not x~asc x; x:-1_ x; if[(count x)<2; :asc x]]; x};

.xml.read:{
  //if it's a symbol, read the file, otherwise it's a string to be parsed
  if[.Q.ty[x]="S"; x:` sv read0 x];
	//remove comments if there are any
  x:.util.rmBetweenInc[x;"<!--";"-->"];
  //remove the header if there is one
  if[count d:ss[x;"[?]>"]; x:(2+first d)_x];
  //get the start and end tags
  tagStarts:ss[;"<[^/]"] x;
  tagEnds:asc raze ({{(x x binr y)}[ss[x;">"];ss[x;"</"]]+1};{ss[x;"/>"]+2}) @\: x;
  //use those to get the depth of nesting
  shallower:deeper:((count x:rtrim x)+1)#0; deeper[tagStarts]:1; shallower[tagEnds]:1; depth:(sums deeper)-sums shallower;
  cidx:where deeper | shallower;
	tab:flip `depth`tag!(depth cidx;cidx cut x);
  //clean up the tags
  tab:delete from tab where (tag inter\: " \n\t")~'tag;
  //classify the tags
  tab:update tagType:{$[(x like "<*>") & (all "><" in 1_ -1_ x);`field; (trim x) like "</*";`close;`open]}each tag from tab;
  tab:update tag:{first .util.findBetweenInc[x;"<";">"]}each tag from tab where not tag like "<*>";
  //get the tag name and attributes
	tab:update tagName:{res:first .util.findBetween[x;"<";">"];$[res like "/*"; 1_res;res]}each tag from tab;
  tab:update tagName:`${(x?\:" ")#'x}tagName, tagAttributes:{trim each (x?\:" ")_'x}tagName from tab;
  //get the tag value	
	tab:update tagValue:.util.XMLue each {"",first .util.findBetween[x;">";"<"]}each tag from tab;
  //extract the human readable location of the tag	
	tab:update idx:i from tab;
  tab:update pathNodes:{[x;y] value exec last i by depth from x where i<=y}[tab]'[i] from tab;
	tab:update .xml.mkAsc each pathNodes from tab;
	//path
	tab:update path:tagName pathNodes from tab;
	map:{(raze x)!raze til each count each x}value exec distinct idx by tagName from tab where tagType=`open;
	tab:update pathMap:map each pathNodes from tab;
	tab:update path:string path, pathMap:{{?[x~\:""; x; "[",/:x,\:"]."]}each string x}pathMap from tab;
	tab:update pathMap:{raze raze flip (x;y)}'[path;pathMap] from tab;
	tab:update pathMap:`${?[x like\: "*.";-1_/: x; x]}pathMap from tab;
	tab:delete path from tab;
	tab:update pathMap:` from tab where tagType<>`field;
	tab:update string pathMap from tab;
	tab};

  
//system "c 40 220";
//show t:.xml.read `:cds.xml;
