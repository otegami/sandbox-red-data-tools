require "net/http"
require "arrow"
require "datasets-arrow"

iris = Datasets::Iris.new
# puts iris.to_arrow
#     sepal_length    sepal_width     petal_length    petal_width       label
# 0         5.100000       3.500000         1.400000       0.200000       Iris-setosa

table = Arrow::Table.new(name: ['Tom', 'Max'], age: [22, 23])
# p table
# #<Arrow::Table:0x120c00848 ptr=0x11218bea0>
# name    age
# 0       Tom      22
# 1       Max      23

params = {
  query: "SELECT WatchID as watch FROM hits LIMIT 10 FORMAT Arrow",
  user: "play",
  password: "",
  database: "default"
}
uri = URI('https://play.clickhouse.com:443/')
uri.query = URI.encode_www_form(params)
resp = Net::HTTP.get(uri)
table = Arrow::Table.load(Arrow::Buffer.new(resp))
# p table
# #<Arrow::Table:0x11d734448 ptr=0x11f8cc6d0>
# watch
# 0      8120543446287442873
# 1      9110818468285196899
# 2      8156744413230856864
# 3      5206346422301499756
# 4      6308646140879811077
# 5      6635790769678439148
# 6      4894690465724379622
# 7      6864353419233967042
# 8      8740403056911509777
# 9      8924809397503602651

table = Arrow::Table.new(
  name: ['Tom', 'Max', 'Kate'],
  age: [22, 23, 19]
)
# p table.slice { |slicer| slicer['age'] > 19 }
# #<Arrow::Table:0x1371ce980 ptr=0x114784c50>
# name    age
# 0       Tom      22
# 1       Max      23

# p table.slice { |slice| slice['age'].in?(19..22) }
# #<Arrow::Table:0x1371c5880 ptr=0x1147854d0>
# name    age
# 0       Tom      22
# 1       Kate     19

# p table.slice { |slicer| (slicer['age'] > 19) & (slicer['age'] < 23) }
# => #<Arrow::Table:0x7fa3882cc300 ptr=0x7fa3ad260b00>
#   name	age
# 0	Tom 	 22

add = Arrow::Function.find('add')
# p add.execute([table['age'].data, table['age'].data]).value

table = Arrow::Table.new(
  name: ['Tom', 'Max', 'Kate', 'Tom'],
  amount: [10, 2, 3, 5]
)
# p table.group(:name).sum(:amount)
# #<Arrow::Table:0x1315186c8 ptr=0x11129c910>
# sum(amount)     name
# 0                15     Tom 
# 1                 2     Max 
# 2                 3     Kate
