.separator ,
.import ../../geosurface-data/airports.csv airports
.import geohashes.csv geohashes
.import ../../geosurface-data/2008.csv ontime

delete from ontime where typeof(year) == "text";
delete from airports where typeof(lat) == "text";