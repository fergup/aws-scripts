for i in `cat $OPEN |awk -F'",' '($21~"Incident")&&($4!~"Resolved") { print $23 }' |sort|uniq -c |sort -rn|sed 's/ "/ - /g' |sed 's/"//g' |head -15 |awk -F- '{ print $2 }'`; do echo " ";printf "<b>============ $i ============<b>";echo " ";head -1 $OPEN | awk -F'","' '{ print "<table border='1'><tr bgcolor="009999"><td>"$1"</td><td>"$2"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$6"</td><td>"$7"</td><td>"$23"</td></tr>" }';cat $OPEN | awk -F'","' '($21~"Incident")&&($4!~"Resolved") { print "<tr><td>"$1"</td><td>"$2"</td><td>"$3"</td><td>"$4"</td><td>"$5"</td><td>"$6"</td><td>"$7"</td><td>"$23"</td></tr>" }' |grep $i; echo "</table><br>";done > /tmp/p.html ; mutt paul.ferguson@sungardas.com -a /tmp/p.html < /etc/hosts