module Mustafa
  module StructureLine
    module Contractor
      module Structure
        module Standard
          class BaseStandard

            def establish_groups
              @element_managers.each_value do |element_manager|
                element_manager.establish_groups
              end
            end

            def each_element
              return to_enum(:each) unless block_given?
              @element_managers.each_value do |element_manager|
                element_manager.each do |element|
                  yield element
                end
              end
            end

            def each_element_manager
              return to_enum(:each) unless block_given?
              @element_managers.each_value do |element_manager|
                yield element_manager
              end
            end

            def should_draw_preview?(name)
              @node_elements_attachment_table[name] || @segment_elements_attachment_table[name]
            end
						
						def [](element_manager_name)
	            @element_managers[element_manager_name]
	          end

          end
        end
      end
    end
  end
end