require_relative 'library'

module Mustafa
  module StructureLine
    module Environment
      module Material
        module Loader
          extend self

          include Library

          def activate(model)
            library_path = File.join(__dir__, "library")
            return unless Dir.exist?(library_path)

            Dir.glob(File.join(library_path, "*.skm")).each do |skm_file|
              begin
                material = model.materials.load(skm_file)
                MATERIAL_LIBRARY[material.name] = material
              rescue => e
                puts "Failed to load material #{skm_file}: #{e.message}"
              end
            end
          end
        end
      end
    end
  end
end