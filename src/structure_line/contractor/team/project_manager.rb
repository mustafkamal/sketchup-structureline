module Mustafa
  module StructureLine
    module Contractor
      module Team
        class ProjectManager

          include Engineering
		      include Design
          include Drafting
          include Construction

          def initialize(structure)
            @structure = structure
            hire_project_team
          end

          def draw_structure_outline(view, preview_point = nil)
            @drafter.make_outline_drawings(view, preview_point)
          end

          def begin_construction
            make_detail_drawing
            make_structure_design
            build_structure
          end

          def teardown_structure
            @demolitionist.teardown_structure
          end

          private

          def hire_project_team
            @engineer = Engineer.new(@structure)
            @designer = Designer.new(@structure)
            @drafter = Drafter.new(@structure)
            @foreman = Foreman.new(@structure)
            @demolitionist = Demolitionist.new(@structure)
          end

          def make_detail_drawing
            @drafter.make_detail_drawing
          end

          def make_structure_design
            @designer.design_structure
          end

          def build_structure
            @foreman.build_structure
          end

        end
      end
    end
  end
end