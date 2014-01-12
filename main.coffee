console.log("Running")
d3.csv("datamanip/ontime_geohashes.csv", (csv) =>
  console.log("Loaded csv, number of rows: #{csv.length}")

  facts = crossfilter(csv)
  all = facts.groupAll()

  console.log("Creating dimensions ...")
  dimensions = {
    Origin : facts.dimension((d) => d.Origin)
    GeoHashPair : facts.dimension((d) => "#{d.Origin_Hash},#{d.Dest_Hash}")
    GeoHashLevelRollupPair : facts.dimension((d) => "#{d.Origin_Hash[0...2]}->#{d.Dest_Hash[0...2]}")
  }
  console.log("Created dimensions")

  console.log("Creating groups ...")
  groups = {
    GeoHashLevelRollupPair : dimensions.GeoHashLevelRollupPair.group()
  }
  console.log("Created groups")

  groupMinMax = (group) =>
    values = for pairs in group.all()
      pairs.value
    [d3.min(values), d3.max(values)]

  GeoHashLevelRollupPairMinMax = groupMinMax(groups.GeoHashLevelRollupPair)

  colors = d3.scale.linear().domain(GeoHashLevelRollupPairMinMax).range(['white','red'])

  dc.pieChart("#geohash-level2-pie-chart")
    .dimension(dimensions.GeoHashLevelRollupPair)
    .group(groups.GeoHashLevelRollupPair)
    .colorCalculator(colors)
    .colorAccessor((d) => d.value)
    .renderLabel(true)

#  allPairs = for pairs in groups.GeoHashLevelRollupPair.all()
#    pairs.key
#
#  dc.barChart("#geohash-level2-row-chart")
#    .margins({top: 10, right: 50, bottom: 30, left: 80})
#    .width(1000)
#    .dimension(dimensions.GeoHashLevelRollupPair)
#    .group(groups.GeoHashLevelRollupPair)
#    .x(d3.scale.ordinal().domain(allPairs))

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