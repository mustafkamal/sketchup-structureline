require_relative 'construction/foreman'
require_relative 'design/designer'
require_relative 'drafting/drafter'
require_relative 'engineering/engineer'

module Mustafa
  module StructureLine
    module Contractor
      class ProjectManager

        include Construction
        include Design
        include Drafting
        include Engineering

        def initialize
          @engineer = Engineer.new
          @designer = Designer.new
          @drafter = Drafter.new
          @foreman = Foreman.new
        end

        def draw_structure_outline(structure, view, preview_point = nil)
          @drafter.make_outline_drawings(structure, view, preview_point)
        end

        def begin_construction(structure)
          @drafter.make_detail_drawing(structure)
          @designer.design_structure(structure)
          @foreman.build_structure(structure)
        end

        def teardown_structure(structure)
          @foreman.teardown_structure(structure)
        end

      end
    end
  end
end