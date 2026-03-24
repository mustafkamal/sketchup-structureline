module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Drafting
          class Drafter
            include Utils::Constants

            STRUCTURE_DETAIL_DRAWING_HANDLER_MAP = {
              STRUCTURE_TYPE_CONFINED_MASONRY => :make_confined_masonry_detail_drawing
            }

            def initialize(structure)
              @structure = structure
            end

            def make_outline_drawings(view, preview_point = nil)
              draw_registered_elements(view)
              draw_element_previews(view, preview_point) if preview_point
            end

            def make_detail_drawing
              # Detail drawing is when the there is no more collision between the elements of a structure
              method = STRUCTURE_DETAIL_DRAWING_HANDLER_MAP[@structure.type]
              raise ArgumentError, "No detail drawings for this structure type" unless method
              send(method)
            end

            private

            def draw_registered_elements(view)
              @structure.each_element do |element|
                element.draw(view)
              end
            end

            def draw_element_previews(view, preview_point)
              @structure.each_element_manager do |element_manager|
                element_manager.draw_preview(view, preview_point) if element_manager.should_draw_preview?
              end
            end

            def make_confined_masonry_detail_drawing
              DrawingStandard::ConfinedMasonry.make_detail_drawing(@structure)
            end

          end
        end
      end
    end
  end
end