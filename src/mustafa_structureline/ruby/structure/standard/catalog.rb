module Mustafa
  module StructureLine
    module Structure
      module Standard
        module Catalog
          extend self

          include Utils::Constants

          STRUCTURE_TYPE_MAP = {
            STRUCTURE_TYPE_CONFINED_MASONRY => :create_confined_masonry_structure_standard
          }

          def create_standard(structure)
            method = STRUCTURE_TYPE_MAP[structure.type]
            raise ArgumentError, "Unknown structure type" unless method
            send(method, structure)
          end

          private

          def create_confined_masonry_structure_standard(structure)
            standard = ConfinedMasonry::StructureStandard.new(structure)
            standard
          end

        end
      end
    end
  end
end