require 'datasets'

iris = Datasets::Iris.new
iris.each do |record|
  p [
    record.sepal_length,
    record.sepal_width,
    record.petal_length,
    record.petal_width,
    record.label
  ]
end

iris_hash = iris.to_table.to_h
p iris_hash

# カラムナーフォーマットだよ
iris_table = iris.to_table
p iris_table
p iris_table.fetch_values(:sepal_length, :sepal_width)
p iris_table.fetch_values(:sepal_length, :sepal_width).transpose
