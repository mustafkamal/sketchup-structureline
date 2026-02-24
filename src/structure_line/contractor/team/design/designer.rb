module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Design
          class Designer
            include Utils::Constants

            STRUCTURE_DESIGN_MAP = {
              STRUCTURE_TYPE_CONFINED_MASONRY => :design_confined_masonry_structure
            }

            def initialize(structure)
              @structure = structure
            end

            def design_structure
              # Detail drawing is when the there is no more collision between the elements of a structure
              method = STRUCTURE_DESIGN_MAP[@structure.type]
              raise ArgumentError, "No design for this structure type" unless method
              send(method)
            end

            private

            def design_confined_masonry_structure
              DesignStandard::ConfinedMasonry.design(@structure)
            end

          end
        end
      end
    end
  end
end
