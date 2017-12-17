module Sloc
  class CodeAnalyzer

    NESTING_REGEX = /^(\s{2,})+/
    COMMENT_REGEX = /^\s+?(#.+)/ 
    COMMENT_IN_CODE_REGEX = /\w+.+(#.+)/
    TOTAL_REGEX = /\n/
    EMPTY_LINE_REGEX = /^\s*$/
    METHOD_REGEX = /^([^#]*def)/
    
    def initialize(code, defautl_nesting=0)
      @result = {}
      @default_nesting = defautl_nesting
      @code = code.scrub.gsub(/\r\n|\r/, '\n').gsub(/\t/, '  ')
    end

    def process
      @result[:total] = @code.scan(TOTAL_REGEX).count
      @result[:empty_line] = @code.scan(EMPTY_LINE_REGEX).count
      @result[:methods] = @code.scan(METHOD_REGEX).count

      mixed_lines = @code.scan(COMMENT_IN_CODE_REGEX).count
      comment_lines = @code.scan(COMMENT_REGEX).count
      @result[:comments] = mixed_lines + comment_lines
      @result[:code] = @result[:total] - @result[:empty_line] - comment_lines

      @result[:nesting] = calculated_nesting

      @result
    end

    private

    def calculated_nesting
      nesting = @code.scan(NESTING_REGEX).max.first.scan(/\s{2}/).count - @default_nesting
    end
  end
end
