require 'forwardable'

module Mustafa
  module StructureLine
    module Contractor
      class ContractorCompany
        include Structure
        include Team

        extend Forwardable

        def_delegators :@structure, :process_user_input, :process_new_point, :get_bounding_box, :create_temp_edge,
                       :delete_temp_edges, :not_ready_to_draw?, :create_skeleton, :delete_skeleton, :sync_with_skeleton,
                       :instance_path
        def_delegators :@pm, :draw_structure_outline


        attr_reader :structure, :pm

        def initialize(itb =  nil)
          puts "test github"
          @itb = itb
          establish_structure
          establish_project_manager
        end

        def begin_construction
          @structure.save_attributes
          @pm.begin_construction
        end

        def teardown_structure
          @pm.teardown_structure
        end

        private

        def establish_structure
          @structure = StructureSystem.new(@itb.structure_type,
                                           @itb.structure_style,
                                           @itb.structure_presentation,
                                           @itb.structure_group,
                                           @itb.structure_segments)
        end

        def establish_project_manager
          @pm = ProjectManager.new(@structure)
        end

      end
    end
  end
end