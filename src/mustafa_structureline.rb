require 'sketchup.rb'
require 'extensions.rb'

module Mustafa
  module StructureLine
    _file_ = __FILE__
    unless file_loaded?(_file_)
      _file_.force_encoding("UTF-8") if _file_.respond_to?(:force_encoding)

      PLUGIN_ID = File.basename(_file_, ".*")
      PLUGIN_DIR = File.join(File.dirname(_file_), PLUGIN_ID)

      ex = SketchupExtension.new('Structure Line', File.join(PLUGIN_DIR, 'main'))

      ex.creator     = 'Mustafa Kamal' ## /!\ Auto-generated line, do not edit ##
      ex.description = 'A SketchUp extension to automate structure modeling' ## /!\ Auto-generated line, do not edit ##
      ex.version     = '1.0.0-dev' ## /!\ Auto-generated line, do not edit ##
      ex.copyright   = "2025-#{Date.today.year} - MIT License" ## /!\ Auto-generated line, do not edit ##

      Sketchup.register_extension(ex, true)
      file_loaded(_file_)
    end
  end
end