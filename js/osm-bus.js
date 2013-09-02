var bus_lines = [];


// on ready
$(function() {
  // creates the map object
  var map = L.map('map').setView([midlat, midlon], 13);
  L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
      opacity: 0.3
      }).addTo(map);


  // Populates the bus_lines array
  var current_ref = null, current_color = null;
  // chromium / chrome adds an implicity tbody on tables ...
  $("div#bus-layout > table > tbody > tr > td").each(function(index) {
    if (current_ref == null) current_ref = $(this).html();
    else if (current_color == null) current_color = $(this).html();
    else {
      var current_geom = $.parseJSON($(this).html().replace(/&quot;/ig, '"'));

      var current_feature = {
        "type": "Feature",
        "properties": {
          "name": current_ref
        },
        "geometry": current_geom
      };

      var current_style = {
        "color": current_color,
        "weight": 5,
        "opacity": 0.65
      };
      L.geoJson(current_feature, {
            style: current_style
      }).addTo(map);
      bus_lines.push(current_feature);
      current_ref = null;
      current_color = null;
   }
  });

});

