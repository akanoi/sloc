require 'yaml'

require_relative '../lib/sloc'
require_relative '../lib/writer'

DEFAULT_YML_PATH = './.rubocop_todo.yml'
NESTING = 'BlockNesting'
CLASS_LENGTH = 'ClassLength'
LINE_LENGTH = 'LineLength'
METHOD_LENGTH = 'MethodLength'

def read_file(path)
  File.read(path)
end

def parse_arg(path)
	path[/scripts\/(.+)/, 1].split('/')
end

def correct_args?(shop, modul)
	return false if shop.nil? || modul.nil?
	return false unless shop[/^\d+$/] && modul[/SCRIPT/]

	true
end

def get_metrics(config, parameter)
	config["Metrics/#{parameter}"]["Max"] rescue '-1'
end

def parse_yml(yml = DEFAULT_YML_PATH)
	config = YAML.load_file(yml)

	{
		nesting: get_metrics(config, NESTING),
		class_length: get_metrics(config, CLASS_LENGTH),
		line_length: get_metrics(config, LINE_LENGTH),
		method_length: get_metrics(config, METHOD_LENGTH),
	}
end

def rubocop_inspect(file_path)
	puts 'Get nesting'

	print `rubocop --auto-gen-config -l #{file_path} >> /dev/null`

	puts 'Config created!'
end

code = read_file(ARGV[0])
shop, modul = parse_arg(ARGV[0])

return unless correct_args? shop, modul

rubocop_inspect(ARGV[0])
metrics = parse_yml()

analyzer = CodeAnalyzer.new(code)
result = [analyzer.process]
result.first.merge!({ :shop_id => shop, :module => modul }).merge!(metrics)

Writer.new('output.csv').write_data(result)