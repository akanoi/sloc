require_relative '../lib/sloc'
require_relative '../lib/writer'

def read_file(path)
  File.read(path)
end

def parse_arg(path)
	path[/scripts\/(.+)/, 1].split('/')
end

code = read_file ARGV[0]
shop, modul = parse_arg(ARGV[0])

return if shop.nil? || modul.nil?
return unless shop[/^\d+$/] || modul[/SCRIPT/]

analyzer = CodeAnalyzer.new(code)
result = [analyzer.process]
result.first.merge!({ :shop_id => shop, :module => modul })

#Writer.new('output.csv').write_data(result)
puts result.inspect