require 'sketchup.rb'

module Mustafa
  module StructureLine

    def self.reload(_clear_console = true, undo = false)
      # Hide warnings for already defined constants.
      verbose = $VERBOSE
      $VERBOSE = nil
      Dir.glob(File.join(PLUGIN_DIR, "**/*.{rb,rbe}")).each { |f| load(f) }
      $VERBOSE = verbose

      Sketchup.undo if undo
      puts "Extension is reloaded"
    end

    Dir.glob(File.join(PLUGIN_DIR, "**/*.{rb,rbe}")).each { |f| Sketchup.require(f) }

  end
end