Before do
  extend UserHelpers
  extend SessionHelpers
end

Before('~@no-ui') do |scenario|
  extend ApiHelpers if scenario.feature.file =~ /\/api\//
end
