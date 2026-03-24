require 'sketchup.rb'
require_relative 'extension'

module Mustafa
  module StructureLine

    EXTENSION ||= Extension.new

    unless file_loaded?(__FILE__)
      EXTENSION.setup
      file_loaded(__FILE__)
    end

  end
end