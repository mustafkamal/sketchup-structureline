

module Mustafa
  module StructureLine
    module Utils
      module JsonProcessor
        include Contractor::Structure::ElementBuilders

        def get_3d_point_from_json(array)
          Geom::Point3d.new(*array.map(&:to_f).map(&:mm))
        end

        def get_3d_vector_from_json(array)
          Geom::Vector3d.new(*array.map(&:to_f))
        end

        def get_node_from_json(node_hash)
          Node.new(
            get_3d_point_from_json(node_hash['position']),
            node_hash['attached_components'],
            node_hash['break'],
            node_hash['node_id']
          )
        end
      end
    end
  end
end