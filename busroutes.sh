#!/bin/sh

# Some city samples:

#CITY_NAME=digne
#NORTH=44.122607
#SOUTH=44.027331
#WEST=6.0924795
#EAST=6.2982896

#CITY_NAME=goussainville
#NORTH=49.02609
#SOUTH=49.02281
#WEST=2.46065
#EAST=2.46619

#CITY_NAME=aix-en-provence
#NORTH=43.5594
#SOUTH=43.5013
#WEST=5.3891
#EAST=5.4776

CITY_NAME=grenoble
NORTH=45.211
SOUTH=45.1547
WEST=5.6747
EAST=5.7633


cat > request.xml << EOF
<union>
  <query type="relation">
    <bbox-query s="${SOUTH}" n="${NORTH}" w="${WEST}" e="${EAST}" />
    <has-kv k="route" v="bus"/>
  </query>
  <recurse type="relation-node" into="nodes"/>
  <recurse type="relation-way"/>
  <recurse type="way-node"/>
</union>
<print/>
EOF

wget --post-file=request.xml --header='Content-Type: text/xml'  'http://api.openstreetmap.fr/oapi/interpreter' -O ${CITY_NAME}.osm
rm -f request.xml

osm2pgsql -d osm -k ${CITY_NAME}.osm
rm -f ${CITY_NAME}.osm

cat template/head.html > ${CITY_NAME}.html

MIDLAT=$(echo "$NORTH - ($NORTH - $SOUTH) / 2" | bc -l)
MIDLON=$(echo "$EAST - ($EAST - $WEST) / 2" | bc -l)

cat >> ${CITY_NAME}.html <<EOF
  <script language="javascript">
    var midlat = ${MIDLAT};
    var midlon = ${MIDLON};
  </script>
EOF


cat > query.sql <<EOF
SELECT
       ref
       , tags -> 'colour' AS colour
       , ST_AsGeoJSON(ST_TRANSFORM(ST_Collect(way), 4326)) AS geojson
FROM
       planet_osm_line
WHERE
       route = 'bus'
GROUP BY
       ref, colour
ORDER BY
       ref
EOF

cat query.sql | psql -H osm >> ${CITY_NAME}.html
rm -f query.sql

cat template/eof.html >> ${CITY_NAME}.html

