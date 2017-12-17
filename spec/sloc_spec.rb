require 'rspec'
require './lib/sloc.rb'

describe Sloc do 
  before(:all) do 
  	code = File.read("./spec/test-script.rb")
  	@analyz_result = Sloc::CodeAnalyzer.new(code).process
  end

  it 'has correctly counts the total number of rows' do 
  	@analyz_result[:total].should be 13
  end

  it 'has correctly counts the empty lines in code' do
  	@analyz_result[:empty_line].should be 2
  end

  it 'has correctly counts methods' do
  	@analyz_result[:methods].should be 2
  end

  it 'has correctly counts the lines with code' do
  	@analyz_result[:code].should be 9
  end

  it 'has correctly counts the nesting' do
  	@analyz_result[:nesting].should be 3
  end

  it 'has correctly counts the comment lines' do
  	@analyz_result[:comments].should be 2
  end
end