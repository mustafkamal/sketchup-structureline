module Mustafa
  module StructureLine
    module Utils
      module Constants
        # Structure Type
        STRUCTURE_TYPE_CONFINED_MASONRY = 'Confined masonry'.freeze

        # Structure Style
        STRUCTURE_STYLE_1 = 'Structure style 1'.freeze

        # Structure Presentation
        STRUCTURE_PRESENTATION_SIMPLE = 'Structure presentation simple'.freeze
        STRUCTURE_PRESENTATION_FULL = 'Structure presentation full'.freeze
        STRUCTURE_PRESENTATION_PARTIAL = 'Structure presentation partial'.freeze
        STRUCTURE_PRESENTATION_SKELETON = 'Structure presentation skeleton'.freeze

        # Dictionary Name
        DICT_NAME = 'MustafaStructureLine'.freeze

        # Dictionary Key
        DICT_KEY_TYPE = 'Type'.freeze
        DICT_KEY_STRUCTURE_TYPE = 'Structure type'.freeze
        DICT_KEY_STRUCTURE_STYLE = 'Structure Style'.freeze
        DICT_KEY_STRUCTURE_PRESENTATION = 'Structure Presentation'.freeze
				DICT_KEY_ELEMENT_MANAGER_NAME = 'Element manager name'.freeze
        DICT_KEY_SEGMENTS = 'Segments'.freeze
        DICT_KEY_ELEMENT_PROPERTIES = 'Element properties'.freeze
        DICT_KEY_ELEMENT_TYPE = "Element type".freeze
        DICT_KEY_ELEMENT_ID = 'Element ID'.freeze
				DICT_KEY_COMPONENT_TYPE = 'Component type'.freeze
        DICT_KEY_COMPONENT_ID = 'Component ID'.freeze
        DICT_KEY_COMPONENT_PRESENTATION = 'Component Presentation'.freeze

        # Dictionary Value
        DICT_VALUE_STRUCTURE = 'Structure'.freeze
				DICT_VALUE_ELEMENT_MANAGER = 'Element manager'.freeze
				DICT_VALUE_ELEMENT = 'Element'.freeze
				DICT_VALUE_COMPONENT = 'Component'

        # Element Type
        ELEMENT_TYPE_WALL = 'Wall'.freeze
        ELEMENT_TYPE_COLUMN = 'Column'.freeze
        ELEMENT_TYPE_RC_BEAM = 'Beam'.freeze
				
				# Component Type
        COMPONENT_TYPE_BRICK = 'Brick'.freeze
				COMPONENT_TYPE_CONCRETE_BOX = 'Concrete Box'.freeze
				COMPONENT_TYPE_REBAR = 'Rebar'.freeze

        # Wall Style
        WALL_STYLE_BRICK_MASONRY = 'Brick masonry'.freeze

        # Column Style
        COLUMN_STYLE_RC_COLUMN = 'RC column'.freeze

        # Rc Beam Style
        RC_BEAM_STYLE_NORMAL = 'Normal RC Beam'.freeze

        # General Element Presentation
        ELEMENT_PRESENTATION_SIMPLE = 'Simple element'.freeze
        ELEMENT_PRESENTATION_FULL = 'Full element'.freeze

        # Wall Presentation
        WALL_PRESENTATION_PARTIAL_PLASTER = 'Partial plaster wall'.freeze
        WALL_PRESENTATION_NO_PLASTER = 'No plaster wall'.freeze

        # Column Presentation
        COLUMN_PRESENTATION_PARTIAL_CONCRETE = 'Partial concrete column'.freeze
        COLUMN_PRESENTATION_NO_CONCRETE = 'No concrete column'.freeze

        # Rc Beam Presentation
        RC_BEAM_PRESENTATION_PARTIAL_CONCRETE = 'Partial concrete RC beam'.freeze
        RC_BEAM_PRESENTATION_NO_CONCRETE = 'No concrete RC beam'.freeze

        # General Component Presentation
        COMPONENT_PRESENTATION_FULL = "Full component".freeze
        COMPONENT_PRESENTATION_HIDDEN = 'Hidden component'.freeze

        # Concrete Box Presentation
        CONCRETE_BOX_PRESENTATION_PARTIAL = 'Partial concrete Box'.freeze


      end
    end
  end
end
