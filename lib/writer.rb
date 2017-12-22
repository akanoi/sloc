require 'csv'

class Writer

	def initialize(output_file)
		@output = output_file
	end

	def write_data(data)
		CSV.open(@output, 'a', headers: data.first.keys) do |csv|
			data.each do |d|
				csv << d.values
			end
		end
	end
	
end
