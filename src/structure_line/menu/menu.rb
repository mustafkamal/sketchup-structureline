require_relative '../owner/itb'
module Mustafa
  module StructureLine
    module Menu
      extend self

      include Utils::Constants
      include Environment
      include Owner

      def create_ui
        return nil if file_loaded?(__FILE__) # Safeguard biar SketchUp ga nambah2in menu nya terus
        add_toolbar_menu
        add_context_menu
        file_loaded(__FILE__)
      end

      def add_toolbar_menu
				menu = UI.menu("Plugins").add_submenu("Structure Line")
        menu.add_item("Create Structure") {create_structure(STRUCTURE_PRESENTATION_SIMPLE)}
        menu.add_item("Create Structure Detail") {create_structure(STRUCTURE_PRESENTATION_FULL)}
      end

      def create_structure(presentation)
        itb = Itb.new
        itb.structure_presentation = presentation
        Event::Create.activate(Sketchup.active_model, itb)
      end

      def add_context_menu
        UI.add_context_menu_handler do |menu|
          entity = Sketchup.active_model.selection.first
          break unless entity_is_a_structure_group?(entity)
          menu.add_separator
          itb = Itb.new(entity)
          model = Sketchup.active_model
          handle_edit_structure_menu(menu, model, itb)
          # handle_structure_styling_menu(menu, model)
          # handle_wall_opening_menu(menu, model)

        end
      end

      def entity_is_a_structure_group?(entity)
        entity.get_attribute(DICT_NAME, DICT_KEY_TYPE) == DICT_VALUE_STRUCTURE
      end

      def handle_edit_structure_menu(menu, model, itb)
        menu.add_item("Edit Structure") {Event::Edit.activate(model, itb)}
      end

      def handle_structure_styling_menu(menu, model)
        sub_menu = menu.add_submenu("Structure")
        sub_menu.add_item("Simple") {Event::Styling.activate(group, model, STRUCTURE_STYLE_SIMPLE)}
        sub_menu.add_item("Detail") {Event::Styling.activate(group, model, STRUCTURE_STYLE_DETAIL)}

        menu.add_item("Create Structure Detail") {Event::Styling.activate(group, model)}
      end
			
			def handle_wall_opening_menu(menu, model)
				sub_menu = menu.add_submenu("Structure")
				
				# How to get the element object from the observer file?
				element_from_observer = get_element_from_observer
				sub_menu.add_item("Simple") {Event::WallOpening.activate(group, model, element_from_observer)}
			end

      create_ui
    end
  end
end