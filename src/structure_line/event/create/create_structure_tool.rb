module Mustafa
  module StructureLine
    module Event
      module Create
        class CreateStructureTool < ToolHelper::Polyline
          include Utils::Constants
          include Environment

          attr_accessor :contractor

          def initialize(event)
            @event = event
          end

          # Sketchup manggil method ini setiap kali tool nya ke-activate
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#activate-instance_method
          def activate
            super
          end

          # Sketchup manggil method ini kalo kita pencet suatu key di keyboard
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#onKeyDown-instance_method
          def onKeyDown(key, _repeat, _flags, view)
            super
            process_user_input(key)
            view.invalidate
          end

          # Sketchup manggil method ini setiap kita ngeklik (tombol kiri) mouse nya
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#onLButtonDown-instance_method
          def onLButtonDown(flags, x, y, view)
            return unless @mouse_ip.valid?
            super
            process_new_point
            create_temp_edge(view)
            record_click
            update_ui
            view.invalidate
          end

          # Sketchup manggil method ini setiap kita double klik mousenya
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#onLButtonDoubleClick-instance_method
          def onLButtonDoubleClick(flags, x, y, view)
            create_3d_model
            deactivate_event
            view.invalidate
          end

          # Sketchup manggil method ini setiap kali view nya ke refresh (ex: pas method view.invalidate dipanggil)
          # Sketchup bakal manggil method ini terus2an jadi musti seminimal mungkin.
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#draw-instance_method
          def draw(view)
            super
            draw_structure_outline(view)
          end

          # Sketchup manggil method ini setiap kali dia mau tau extent dari apa yang mau digambar.
          # Sketchup bakal manggil method ini terus2an jadi musti seminimal mungkin.
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#getExtents-instance_method
          def getExtents
            @contractor.get_bounding_box(@mouse_ip&.position)
          end

          def suspend(view)
            #@event.enable_overlay
          end

          def resume(view)
            #@event.disable_overlay
          end

          # Sketchup manggil method ini kalo kita milih tool yang lain atau kita pencet spasi
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#deactivate-instance_method
          def deactivate(view)
            super
            deactivate_event
            close_project
            reset_tool
            update_ui
          end

          private

          def process_user_input(key)
            @contractor.process_user_input(key)
          end

          def process_new_point
            @contractor.process_new_point(@clicked_point)
          end

          def draw_structure_outline(view)
            @contractor.draw_structure_outline(view, @mouse_ip.position) unless structure_not_ready_to_draw?
          end

          def structure_not_ready_to_draw?
            @click_state == :not_yet_clicked || @contractor.not_ready_to_draw?
          end

          def create_3d_model
            model = Sketchup.active_model
            model.start_operation('Create Structure', true)
            @contractor.begin_construction
            model.commit_operation
          end

          def reset_tool
            super
            @nodes.clear
          end

          def create_temp_edge(view)
            return if @click_state == :first_click
            @contractor.create_temp_edge(@prev_clicked_point, @clicked_point)
            # Gatau kenapa kalo kita klik midpoint salah satu edge dari @temp_edge_group, itu akan ngeubah value dari
            # @mouse_ip waktu method add_edges ketriggered. Jadi abis ngebikin edge kita harus pick lagi @mouse_ip nya
            @mouse_ip.pick(view, @mouse_position.x, @mouse_position.y)
          end

          def close_project
            @contractor.delete_temp_edges
          end

          def deactivate_event
            @event.deactivate
          end

        end
      end
    end
  end
end
