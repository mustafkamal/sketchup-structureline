module Mustafa
  module StructureLine
    module Event
      module ToolHelper
        class Polyline

          CURSOR_PENCIL = 632

          # Sketchup manggil method ini setiap kali tool nya ke-activate
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#activate-instance_method
          def activate
            # Object @mouse_ip itu isi nya input point sesuai posisi mouse yang ada di monitor
            @mouse_ip = Sketchup::InputPoint.new
            # Object @last_picked_ip isi nya input point sesuai posisi mouse yang ada di monitor pas kita klik
            @last_picked_ip = Sketchup::InputPoint.new
            # Object @clicked_point itu isi nya 3D point dari @mouse_ip pas kita klik mouse nya
            @clicked_point = Geom::Point3d.new
            # Object @prev_clicked_point itu isi nya 3D point dari @last_picked_ip pas kita klik mouse nya
            @prev_clicked_point = Geom::Point3d.new
            # Object buat ngetrack posisi mouse buat input point picking
            @mouse_position = ORIGIN
            # Object 3D point pas kita ngeklik mouse nya
            @mouse_down = ORIGIN
            # Object buat ngekeep value jarak dari point yang kita klik sama @last_picked_ip
            @distance = 0
            # Object buat ngekeep track vector dari titik yang terakhir diklik (last node) ke posisi cursor mouse
            @line_vector = Geom::Vector3d.new(0, 0, 0)
            # Object untuk ngelock inference nya pas tombol shift/arrow dipencet
            @inference_lock_helper = InferenceLockHelper.new
            # Array yang isi nya itu titik2 yang kita klik
            @nodes = Array.new
            # Object untuk ngekeeptrack ini klikan ke berapa
            @click_state = :not_yet_clicked
            update_ui
          end

          # Sketchup manggil method ini kalo kita milih tool yang lain atau kita pencet spasi
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#deactivate-instance_method
          def deactivate(view)
            view.invalidate
          end

          # Sketchup manggil method ini kalo kita ngeorbit pas kita make tool nya
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#suspend-instance_method
          def suspend(view)
            view.invalidate
          end

          # Sketchup manggil method ini kalo tool nya jadi aktif lagi setelah disuspend
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#resume-instance_method
          def resume(view)
            update_ui
            view.invalidate
          end

          # Sketchup manggil method ini kalo:
          #   1. Pencet tombol escape (reason = 0)
          #   2. User milih tool nya lagi dari toolbar/menu (reason = 1)
          #   3. Sketchup nya di undo pas tool nya active (reason = 2)
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#onCancel-instance_method
          def onCancel(_reason, view)
            reset_tool
            view.invalidate
          end

          # Method untuk ngasih tau sketchup apakah user nya bisa ngeinput value di VCB.
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#enableVCB%3F-instance_method
          def enableVCB?
            @click_state != :not_yet_clicked
          end

          # Sketchup manggil method ini pas tool nya mau ngeset cursor nya.
          # Gatau kenapa method ini dipanggil terus sama sketchup, jadi musti seminimal mungkin.
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#onSetCursor-instance_method
          def onSetCursor
            UI.set_cursor(CURSOR_PENCIL)
          end

          # Sketchup manggil method ini setiap kita ngeklik (tombol kiri) mouse nya
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#onLButtonDown-instance_method
          def onLButtonDown(flags, x, y, view)
            # Reminder -> Untuk semua subclass dari class ini harus ngeconfirm kalo @mouse_ip nya valid sebelum manggil
            # super
            set_click_state # abis keluar method ini kita udah ngehitung clickan yang ngetriger method ini
            set_clicked_point
            # Reminder -> Untuk semua subclass ini harus manggil record_click sebelum nyelesain method onLButtonDown nya
          end

          # Sketchup manggil method ini kalo kita pencet suatu key di keyboard
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#onKeyDown-instance_method
          def onKeyDown(key, _repeat, _flags, view)
            # Di standard line tool itu kemungkinan nya cuman dua, antara dia mau input jarak atau mau ngelock inference
            # kalo dia mau input jarak kita gamau ngeinvoke pick_mouse_position biar vcb nya ga keupdate
            if key == CONSTRAIN_MODIFIER_KEY or key == VK_RIGHT or key == VK_LEFT or key == VK_UP
              @inference_lock_helper.on_keydown(key, view, @mouse_ip, @last_picked_ip)
              pick_mouse_position(view)
            end
          end

          # Sketchup manggil method ini kalo kita ngelepas suatu key di keyboard
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#onKeyUp-instance_method
          def onKeyUp(key, _repeat, _flags, view)
            if key == CONSTRAIN_MODIFIER_KEY or key == VK_RIGHT or key == VK_LEFT or key == VK_UP
              @inference_lock_helper.on_keyup(key, view)
              pick_mouse_position(view)
            end
          end

          # Sketchup manggil method ini setiap kita ngegerakin mouse nya
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#onMouseMove-instance_method
          def onMouseMove(_flags, x, y, view)
            # Simpen posisi mouse nya biar kita bisa pake di function yang lain
            @mouse_position = Geom::Point2d.new(x, y)
            pick_mouse_position(view)
            set_line_vector unless @click_state == :not_yet_clicked
          end

          # Sketchup manggil method ini setiap kali view nya ke refresh (ex: pas method view.invalidate dipanggil)
          # Sketchup bakal manggil method ini terus2an jadi musti seminimal mungkin.
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#draw-instance_method
          def draw(view)
            # draw_preview itu ngegambar garis putus2 yang ngehubungin last_picked_point sama current mouse position
            draw_preview(view)
            # Method #draw dari Sketchup::InputPoint itu untuk ngegambar symbol2 inference yang ada di ujung cursor
            @mouse_ip.draw(view) if @mouse_ip.display?
          end

          # Sketchup manggil method ini setiap kali dia mau tau extent dari apa yang mau digambar.
          # Sketchup bakal manggil method ini terus2an jadi musti seminimal mungkin.
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#getExtents-instance_method
          def getExtents
            bounds = Geom::BoundingBox.new
            bounds.add(get_last_node_and_mouse_point)
            bounds
          end

          # Sketchup manggil method ini pas kita input sesuatu di VCB dan kita hit enter
          # @see https://ruby.sketchup.com/Sketchup/Tool.html#onUserText-instance_method
          def onUserText(text, _view)
            # untuk class StandardLineToolInterface kita mau ngeset method onUserText untuk ga ngereturn apa2 kalo bukan
            # angka yang diinput
            begin
              distance = text.to_l
            rescue ArgumentError
              return
            end
            direction = get_last_node_and_mouse_point[1] - get_last_node_and_mouse_point[0]
            end_point = get_last_node_and_mouse_point[0].offset(direction, distance)
            @mouse_ip = Sketchup::InputPoint.new(end_point)
          end

          private

          def set_clicked_point
            @clicked_point = @mouse_ip.position.clone
          end

          def set_click_state
            @click_state =
              case @nodes.length
              when 0 then :first_click
              when 1 then :second_click
              else        :subsequent_click
              end
          end

          def set_line_vector
            last_node, mouse_point = get_last_node_and_mouse_point
            @line_vector = last_node.vector_to(mouse_point)
          end

          def record_click
            @nodes << @clicked_point
            @last_picked_ip.copy!(@mouse_ip)
            @prev_clicked_point = @clicked_point.clone
            @inference_lock_helper.unlock
          end

          # Method untuk ngebalikin kondisi tool seperti semula
          def reset_tool
            @last_picked_ip.clear
            @inference_lock_helper.unlock
            @click_state = :not_yet_clicked
            update_ui
          end

          # Method untuk ngerefresh UI nya sketcup
          def update_ui
            if @click_state == :not_yet_clicked
              Sketchup.status_text = 'Select start point.'
            else
              Sketchup.status_text = 'Select next point.'
              Sketchup.vcb_value = @distance
            end
            Sketchup.vcb_label = 'Length'
          end

          # Method untuk ngemasukin koordinat mouse yang ada di monitor ke object @mouse_ip
          # Method ini dipanggil setiap kali mouse nya gerak atau setiap kali inference locking nya berubah
          #
          # @param view [Sketchup::View] Active view dari sketchup
          def pick_mouse_position(view)
            if @click_state == :not_yet_clicked
              @mouse_ip.pick(view, @mouse_position.x, @mouse_position.y)
            else
              # Kita mau point yang akan dipilih itu ngereference point yang terakhir kita pilih
              # Ini berguna untuk inference2 tambahan dari last point itu
              @mouse_ip.pick(view, @mouse_position.x, @mouse_position.y, @last_picked_ip)
              @distance = @mouse_ip.position.distance(@prev_clicked_point)
              update_ui
            end
            view.tooltip = @mouse_ip.tooltip if @mouse_ip.valid?
            view.invalidate
          end

          # Method ini ngereturn array 3D koordinat dari point yang lagi kita mau klik dan point yang kita klik sebelum nya
          # (kalo ada)
          #
          # @return [Array]
          def get_last_node_and_mouse_point
            # Method #position dari sebuah InputPoint object itu berguna untuk mendapatkan 3D koordinat dari point yang
            # udah dipilih (picked)
            points = []
            points << @prev_clicked_point
            points << @mouse_ip.position if @mouse_ip.valid?
            points
          end

          # Method untuk ngegambar preview dari line yang akan kita buat
          #
          # @param view [Sketchup::View]
          def draw_preview(view)
            return if @click_state == :not_yet_clicked # Kalo user belom ngeklik apa2 kita gamau ngegambar apapun.
            last_node, mouse_point = get_last_node_and_mouse_point
            # Method #set_color_from_line dari Sketchup::View itu ngebikin warna drawing nya tergantung
            # arah dari line yang mau kita buat (sama kayak native tool nya). Berguna pas kita locking ke axis nya Sketchup.
            view.set_color_from_line(last_node, mouse_point)
            view.line_width = view.inference_locked? ? 3 : 1
            view.line_stipple = '_'
            view.draw(GL_LINES, last_node, mouse_point)
          end
        end
      end
    end
  end
end