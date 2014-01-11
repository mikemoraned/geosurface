.headers on
.mode csv
.output ontime_geohashes.csv
select o.origin, origin_g.hash as Origin_Hash, o.dest, dest_g.hash as Dest_Hash
from ontime o join airports origin_a on o.origin = origin_a.iata join geohashes origin_g on origin_a.iata = origin_g.iata
              join airports dest_a on o.dest = dest_a.iata join geohashes dest_g on dest_a.iata = dest_g.iata;
