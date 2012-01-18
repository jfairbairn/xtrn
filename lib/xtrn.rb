%w(directory executor).each do |i|
  require File.dirname(__FILE__) + "/xtrn/#{i}"
end
