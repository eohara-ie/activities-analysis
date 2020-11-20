\d .xxml

ws:{x}
rms:{i:0; while[(i<count x) and x[i] in " \t\n\r"; i+:1]; i _ x} ; /remove extra space
splt:{(where b&1=sums(b&:not e)-((b:"<"=x)&e:1 rotate "/"=x)|((">"=x)&-1 rotate "/"=x))_ x} ; / split children

cmt:{[a] /remove comments
        l1: ss[a;"<!--"];
        l2: ss[a;"-->"]; 
        if[not (count l2)~count l1; show "invalid comments in xml, exiting"; exit 0]; /comment tags should pair up
        if[not count l1; :a];
        p1:first l1; p2: first l2;
        :(p1#a), 3 _ p2 _ a
        };

rmType:{[a]
        l1: ss[a;" type=\""];
        l2: ss[a;"\""]; 
        if[not count l1; :a];
        p1: l1; 
        p2: l2 l2 binr 7+l1;
        k1:0,p2+1;
		k2:(p1-1),(count a)-1;
        raze a{x+0,1+til(y-x)}'[k1;k2]
        };


atr:{ /returns a list with atribute and value
        if[not count x;:()];
        k:trim (p:x?"=")#x:trim x; /remove useless white spaces front and back
        p2:(r:trim (1+p) _ x)?"=";
        k2:trim p2 # r;
        v:trim (neg (reverse k2)?" ") _ k2;
        if[not count v;v:k2];
        if[p2~count r;v:k2]; /special boundry case....
        d: (enlist `$k)!(enlist v); if[count n:(count v) _ r; :raze (d;atr[n]);];
        :d;
        };


lxml:{[lvl;x] /lvl, just for debugging purposes
		a:(1+m:s?" ")_ s:(n:x?">")#x;
		if["/"=last a;a:-1_a];
		s:`$(1_ m#s)except "/";
		b:"<"=first val:x:rms ws(1+n)_(neg 1+(reverse x)?"<")_ x;
		if[b;
			val:lxml[lvl+1;]'[splt x];
 			g:group val[;0];
        	col:asc key g;
			val:col!val[;1]{$[1=count x; first x;x]}each g col
		];
		if[not b; val:ssr[ssr[ssr[val;"&lt;";"<"];"&gt;";">"];"&amp;";"&"]];
		a:"S= "0:a;
		if[0<k:count first a;
			$[99=type val;val:((key val),a 0)!(value val),a 1;val:(`,a 0)! (enlist val),a 1];
		];
		:(s;val);
		}; 
 

tl:{[s;ret]
       if[not (type ret) in (99h;98h);:(enlist s)!(enlist ret)];
       if[98h ~ type ret; :(enlist s)!(enlist tl[s;]'[ret])];
       k:first key ret;
       l:raze ret[key ret]; /to raze or not to
       l1: first l;
       l2: last l;
       rd: tl[k;]'[l2];
       :(enlist s)!enlist (l1;rd);
 };

rdXML:{[fname]
        a: raze fname;
        if[count a ss "<[?]xml";a:((first a ss "<[?]xml")#a),(2+first a ss "[?]>") _ a]; /remove xml label/dtd tag information
        if[count a ss "<[!]DOCTYPE";a:((first a ss "<[!]DOCTYPE")#a),(1+first a ss ">") _ a];
        a: (cmt/)[rms a];
        if[a like "*MxML*"; a:rmType a];
        ret: lxml[0;]'[splt a]; /splt splits remaining xml into nested tags
		:ret;
     };
\d .