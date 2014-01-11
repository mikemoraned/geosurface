fs = require('fs')
csv = require('csv')

argv = require('optimist').argv

if not (argv.airports and argv.geohashes)
  console.error("Usage: #{argv.$0} --airports <input csv file> --geohashes <output csv file>")
  process.exit(1)

csv()
.from.path("#{__dirname}/#{argv.airports}", {
  delimiter: ','
  escape: '"'
  columns: true
})
.to.stream(fs.createWriteStream("#{__dirname}/#{argv.geohashes}"))
#.transform( (row) =>
#  row.unshift(row.pop())
#  row
#)
.on('record', (row,index) =>
  console.log('#'+index+' '+JSON.stringify(row))
)
.on('close', (count) =>
  console.log("Number of lines: #{count}")
)
.on('error', (error) =>
  console.error(error.message)
)