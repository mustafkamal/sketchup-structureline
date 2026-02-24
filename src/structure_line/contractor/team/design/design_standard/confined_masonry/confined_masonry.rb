require_relative '../../element_designer/node_element_designer/column_designer/column_designer'
require_relative '../../element_designer/segment_element_designer/rc_beam_designer/rc_beam_designer'
require_relative '../../element_designer/segment_element_designer/wall_designer/wall_designer'

module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Design
          module DesignStandard
            module ConfinedMasonry
              extend self
			  
			        include ElementDesigner

              def design(structure)
                initialize_module_objects(structure)
                design_elements
              end

              private

              def initialize_module_objects(structure)
                @standard = structure.standard
                @walls = @standard.walls.elements
                @ring_beams = @standard.ring_beams.elements
                @columns = @standard.columns.elements
              end

              def design_elements
                design_column
                design_wall
                design_ring_beam
              end

              def design_column
                @columns.each_value do |column|
                  ColumnDesigner.design(column)
                end
              end

              def design_wall
                @walls.each_value do |wall|
                  WallDesigner.design(wall)
                end
              end

              def design_ring_beam
                @ring_beams.each_value do |ring_beam|
                  RcBeamDesigner.design(ring_beam)
                end
              end

            end
          end
        end
      end
    end
  end
end