require 'date'

module Polycon
  module Models
    class Appointments
      attr_accessor :date, :name, :surname, :phone, :notes

      def self.from_file(date)
        appointment = new
        path = "#{self.fecha_guion(date)}.paf"
        File.open(path, 'r') do |file|
          appointment.surname = file.gets.chomp
          appointment.name = file.gets.chomp
          appointment.phone = file.gets.chomp
          appointment.notes = file.gets.chomp unless file.eof?
        end
        appointment
      end

      def save(date)
        path = "#{(date.gsub " ", "_").gsub ":", "-"}.paf"
        File.open(path, 'w') do |file|
          file << "#{surname}\n"
          file << "#{name}\n"
          file << "#{phone}\n"
          file << notes unless notes.nil?
        end
      end

      def edit(options)
        options.each do |key, value|
          self.send(:"#{key}=", value)
        end
      end

      def create_path(date)
        "#{fecha_guion(date)}.paf"
      end
      
      def self.posicionarme_prof(professional)
        Dir.chdir(professional)
      end

      def self.fecha_guion(date)
        (date.gsub " ", "_").gsub ":", "-"
      end

      def self.crear_turno(date, name, surname, phone, notes = nil)
        File.write("#{self.fecha_guion(date)}.paf", "#{surname}\n#{name}\n#{phone}\n#{notes}")
      end

      def self.existe_turno?(date)
        File.exists?("#{self.fecha_guion(date)}.paf")
      end

      def self.leer_turno(date)
        File.read("#{self.fecha_guion(date)}.paf")
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
        turnos = []
        if date == nil
          Dir.children(professional).each do |turno|
            nombre = File.basename turno, ".paf"
            turnos << nombre
          end
        else
          Dir.children(professional).each do |turno|
            nombre = File.basename turno, ".paf"
            date_time = Date.strptime(nombre, "%Y-%m-%d").to_s
            if (date_time == date)
              turnos << nombre
            end
          end
        end
        turnos
      end

      def self.reprogramar_turno(old_date, new_date)
        File.rename("#{self.fecha_guion(old_date)}.paf", "#{self.fecha_guion(new_date)}.paf")
      end
    end
  end
end