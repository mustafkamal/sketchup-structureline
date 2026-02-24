module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Construction

          class Demolitionist
            def initialize(structure)
              @structure = structure
            end

            def teardown_structure
              @structure.each_element do |element|
                element.delete_3d_model
              end
            end

          end
        end
      end
    end
  end
end