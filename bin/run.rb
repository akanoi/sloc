require_relative '../lib/sloc'

def read_file(file)
	File.read(file)
end

code = read_file ARGV[0]

analyzer = Sloc::CodeAnalyzer.new(code)

puts analyzer.process.inspect