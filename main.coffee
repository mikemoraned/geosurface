console.log("Running")
d3.csv("datamanip/ontime_geohashes.csv", (csv) =>
  console.log("Loaded csv, number of rows: #{csv.length}")

  cf = crossfilter(csv)
  all = cf.groupAll()

  console.log("Creating dimensions ...")
  dimensions = {
    Origin : cf.dimension((d) => d.Origin)
  }
  console.log("Created dimensions")

  dc.dataTable(".dc-data-table")
    .dimension(dimensions.Origin)
    .group((d) => d)
    .columns([
      (d) => d.Origin
      (d) => d.Dest
    ])
    .sortBy((d) => "#{d.Origin}-#{d.Dest}")
    .order(d3.ascending)

  dc.renderAll()
)