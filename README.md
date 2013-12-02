osm-busroutes
=============

A quick n' dirty way to render bus routes from OpenStreetMap into a single HTML page.


# setup

1. Clone the repository
2. Install a postgis-enabled database named osm, as well as osm2pgsql
3. Edit the busroutes.sh to suit the city you are targetting, e.g. (for Digne-les-Bains):

```bash
CITY_NAME=digne
NORTH=44.122607
SOUTH=44.027331
WEST=6.0924795
EAST=6.2982896
```

Note: you can figure out which values to use for N/S/W/E using the openstreetmap website,
then clicking "export data" on the left once you are on the expected zone.

4. Launch the script:

```
    ./busroutes.sh
```

A file `CITYNAME.html` will then be generated.

# Video

[![Using osm-busroutes](http://img.youtube.com/vi/h9-e7r13ZbI/0.jpg)](http://www.youtube.com/watch?v=h9-e7r13ZbI)
