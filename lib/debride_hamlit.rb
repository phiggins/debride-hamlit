require 'debride'
require 'hamlit'

class Debride
  module Hamlit
    VERSION = '1.0.0'
  end

  def process_haml file
    haml = File.read file

    ruby = ::Hamlit::Engine.new.call(haml)

    begin
      RubyParser.new.process ruby, file
    rescue => e
      warn ruby if option[:verbose]
      raise e
    end
  end
end
