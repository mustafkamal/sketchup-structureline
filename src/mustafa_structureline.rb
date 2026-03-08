require 'sketchup.rb'
require 'extensions.rb'

module Mustafa
  module StructureLine
    path = __FILE__
    unless file_loaded?(path)
      path.force_encoding("UTF-8") if path.respond_to?(:force_encoding)

      PLUGIN_ID = File.basename(path, ".*")
      PLUGIN_DIR = File.join(File.dirname(path), PLUGIN_ID)

      ex = SketchupExtension.new('Structure Line', File.join(PLUGIN_DIR, 'main'))
      ex.creator = 'Mustafa Kamal'
      ex.description = 'An extension to automate structure modeling'
      ex.version = '1.0'
      ex.copyright = "2025, #{ex.creator}"

      Sketchup.register_extension(ex, true)
      file_loaded(path)
    end
  end
end