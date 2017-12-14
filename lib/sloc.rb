module Sloc
	class CodeAnalyzer

		NESTING_REGEX = /^(\t+)/
		COMMENT_REGEX = /^\s+?(#.+)/ 
		COMMENT_IN_CODE_REGEX = /\w+.+(#.+)/
		TOTAL_REGEX = /\n/
		EMPTY_LINE_REGEX = /^\s*$/
		DEFAULT_TAB = 2


		def initialize(code)
			@result = {}
			@code = code.scrub.gsub(/\r\n|\r/, '\n')
		end

		def process
			@result[:total] = @code.scan(TOTAL_REGEX).count
			@result[:empty_line] = @code.scan(EMPTY_LINE_REGEX).count

			mixed_lines = @code.scan(COMMENT_IN_CODE_REGEX).count
			comment_lines = @code.scan(COMMENT_REGEX).count
			@result[:comments] = mixed_lines + comment_lines
			@result[:code] = @result[:total] - @result[:empty_line] - comment_lines

			@result[:nesting] = calculated_nesting

			@result
		end

		private

		def calculated_nesting
			@code.scan(NESTING_REGEX).max.first.scan("\t").count - DEFAULT_TAB
		end
	end
end
