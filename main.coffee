console.log("Running")
d3.csv("datamanip/ontime_geohashes.csv", (csv) =>
  console.log("Loaded csv, number of rows: #{csv.length}")

  cf = crossfilter(csv)
  all = cf.groupAll()

  console.log("Creating dimensions ...")
  dimensions = {
    Origin : cf.dimension((d) => d.Origin)
    GeoHashPair : cf.dimension((d) => "#{d.Origin_Hash},#{d.Dest_Hash}")
    GeoHashLevel2Pair : cf.dimension((d) => "#{d.Origin_Hash[0...2]}->#{d.Dest_Hash[0...2]}")
  }
  console.log("Created dimensions")

  console.log("Creating groups ...")
  groups = {
    GeoHashLevel2Pair : dimensions.GeoHashLevel2Pair.group()
  }
  console.log("Created groups")

  dc.pieChart("#geohash-level2-chart")
    .dimension(dimensions.GeoHashLevel2Pair)
    .group(groups.GeoHashLevel2Pair)
    .renderLabel(true)

  dc.dataTable(".dc-data-table")
    .dimension(dimensions.Origin)
    .group((d) => d)
    .columns([
      (d) => d.Origin
      (d) => d.Origin_Hash
      (d) => d.Dest
      (d) => d.Dest_Hash
    ])
    .sortBy((d) => "#{d.Origin}-#{d.Dest}")
    .order(d3.ascending)

  dc.renderAll()
)