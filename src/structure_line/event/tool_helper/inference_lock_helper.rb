module Mustafa
  module StructureLine
    module Event
      module ToolHelper
        # Object untuk ngunci inference pas tombol shift/arrow dipencet
        class InferenceLockHelper

          # Initialize nyala pas kita aktifin tool yang ngebikin object ini
          def initialize
            # Object untuk ngekeep track apakah sketchup lagi ngelock inference nya atau ga
            @axis_lock = nil
          end

          # Method ini dipanggil dari +onkeyDown+
          #
          # Nentuin inference locking berdasarkan dari tombol yang dipencet
          #
          # @param key [Integer] Tombol yang dipencet
          # @param view [Sketchup::View] Active view dari sketchup
          # @param mouse_ip [Sketchup::InputPoint] Input point yang ada di cursor mouse nya
          # @param last_picked_ip [Sketchup::InputPoint] Input point terakhir yang dipilih
          def on_keydown(key, view, mouse_ip, last_picked_ip = @mouse_ip)
            if key == CONSTRAIN_MODIFIER_KEY # Shift Key
              try_lock_constraint(view, mouse_ip)
            else
              # kalo bukan shift, kita masuk ke function ini buat ngecek apakah tombol arrow yang dipencet
              try_lock_axis(key, view, last_picked_ip)
            end
          end

          # Method ini dipanggil dari +onKeyUp+
          #
          # Nentuin apakah inference locking nya musti dilepas apa enggak berdasarkan dari tombol yang dilepas
          #
          # @param key [Integer] Tombol yang dilepas
          # @param view [Sketchup::View] Active view dari sketchup
          def on_keyup(key, view)
            # Kalo bukan tombol shift yang dilepas berarti kita gamau ngerubah state inference locking nya
            return unless key == CONSTRAIN_MODIFIER_KEY
            # Kalo tombol shift nya yang dilepas tapi tool nya lagi ngelock ke axis tertentu, kita juga gamau ngeubah
            # state inference locking nya
            return if @axis_lock

            # Manggil method #lock_inference tanpa argument itu akan nge unlock semua inference
            view.lock_inference
          end

          # Method ini dipanggil dari +deactivate+ dan +reset_tool+
          #
          # Ngelepas semua inference locking
          def unlock
            @axis_lock = nil
            # Manggil method #lock_inference tanpa argument itu akan nge unlock semua inference
            Sketchup.active_model.active_view.lock_inference
          end

          private

          # Mencoba ngelock inference berdasarkan constraint yang ada. Method ini nyala setiap user nya mencet tombol shift
          #
          # @param view [Sketchup::View] Active view dari sketchup
          # @param mouse_ip [Sketchup::InputPoint] Input point yang ada di cursor mouse nya
          def try_lock_constraint(view, mouse_ip)
            # Di native line tool pas kita mencet tombol shift itu nyuruh sketchup untuk ngelock inference berdasarkan
            # entity yang ada di input point nya (contoh: pas ada disuatu bidang sebuah face, terusan dari sebuah edge)

            return if @axis_lock # Waktu axis nya ke lock, kita gamau ngeubah inference nya samsek
            return unless mouse_ip.valid?

            view.lock_inference(mouse_ip)
          end

          # Mencoba ngelock inference berdasarkan global axis sketchup. Method ini nyala setiap user mencet tombol selain
          # shift
          #
          # @param key [Integer] Tombol yang dipencet
          # @param view [Sketchup::View] Active view dari sketchup
          # @param last_picked_ip [Sketchup::InputPoint] Input point terakhir yang dipilih
          def try_lock_axis(key, view, last_picked_ip)
            return unless last_picked_ip.valid?

            case key
            when VK_RIGHT
              lock_inference_axis([last_picked_ip.position, view.model.axes.xaxis], view)
            when VK_LEFT
              lock_inference_axis([last_picked_ip.position, view.model.axes.yaxis], view)
            when VK_UP
              lock_inference_axis([last_picked_ip.position, view.model.axes.zaxis], view)
            else
              return
            end
          end

          # Method ini untuk ngunci inference nya ke axis yang dipilih atau ngelepas inference nya kalo dia kekunci di
          # axis yang kita pilih
          #
          # @param line [Array<(Geom::Point3d, Geom::Vector3d)>] garis yang berawal dari +last_picked_ip+ dan memiliki
          #   arah yang sama seperti salah satu 3 axis sketchup
          # @param view [Sketchup::View] Active view dari sketchup
          def lock_inference_axis(line, view)
            return unlock_axis(view) if line == @axis_lock

            @axis_lock = line
            view.lock_inference(
              Sketchup::InputPoint.new(line[0]),
              Sketchup::InputPoint.new(line[0].offset(line[1]))
            )

          end

          # Method ini untuk ngeunlock inferecence ke axis
          #
          # @param view [Sketchup::View] Active view dari sketchup
          def unlock_axis(view)
            # Kita hanya mau ngelepas inference locking yang ke axis aja. Kalo ada inference locking dari yang lain
            # itu harus kita keep
            return unless @axis_lock

            @axis_lock = nil
            view.lock_inference
          end
        end
      end
    end
  end
end