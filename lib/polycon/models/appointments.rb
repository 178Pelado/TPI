module Polycon
  module Models
    class Appointments
      
      def self.fecha_guion(date)
        (date.gsub " ", "_").gsub ":", "-"
      end

      def self.crear_turno(date, professional, name, surname, phone, notes = nil)
        File.write("#{self.fecha_guion(date)}.paf", "#{surname}\n#{name}\n#{phone}\n#{notes}")
      end

      def self.crear_turno(date, professional, name, surname, phone, notes = nil)
        File.write("#{self.fecha_guion(date)}.paf", "#{surname}#{name}#{phone}#{notes}")
      end

      def self.existe_turno?(date)
        File.exists?("#{self.fecha_guion(date)}.paf")
      end

      def self.leer_turno(date)
        File.readlines("#{self.fecha_guion(date)}.paf")
      end

      def self.mostrar_turno(turno)
        turno.each do |linea|
          puts linea
        end
      end

      def self.cancelar_turno(date)
        File.delete("#{self.fecha_guion(date)}.paf")
      end

      def self.cancelar_turnos()
        f_actual = Time.now.strftime("%Y-%m-%d_%H:%M")
        Dir.foreach(".") do |turno|
          if (turno > f_actual)
            File.delete(turno)
          end
        end
      end

      def self.listar_turnos(professional, date = nil)
        Dir.children(".").each do |turno|
          if date != nil
            fecha = turno.split("_")
            if (fecha[0] == date)
              puts turno
            end
          else
            puts turno
          end
        end
      end

      def self.reprogramar_turno(old_date, new_date)
        File.rename("#{self.fecha_guion(old_date)}.paf", "#{self.fecha_guion(new_date)}.paf")
      end
    end
  end
end