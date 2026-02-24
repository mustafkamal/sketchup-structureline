module Mustafa
  module StructureLine
    module Contractor
      module Team
        module Design
          module ElementDesigner
            module ColumnDesigner
              extend self

              include Component
              include Utils::Constants

              COLUMN_DESIGN_STYLE_MAP = {
                COLUMN_STYLE_RC_COLUMN => :design_rc_column
              }

              def design(column)
                @column = column
                method = COLUMN_DESIGN_STYLE_MAP[@column.style]
                raise ArgumentError, "No design for this column style" unless method
                send(method)
              end

              private

              def design_rc_column
			  	      RcColumnDesigner.design(@column)
              end
			  
			  

            end
          end
        end
      end
    end
  end
end