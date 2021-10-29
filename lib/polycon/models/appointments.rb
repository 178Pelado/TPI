require 'date'
require 'time'

module Polycon
  module Models
    class Appointments
      attr_accessor :date, :name, :surname, :phone, :notes, :professional

      def initialize(date = nil, name = nil, surname = nil, phone = nil, notes = nil, professional = nil)
        @date = date
        @name = name
        @surname = surname
        @phone = phone
        @notes = notes
        @professional = professional
      end

      def self.from_file(date, professional)
        appointment = new
        appointment.professional = professional.name
        appointment.date = date
        path = "#{Polycon::Store.root_path}/#{professional.name}/#{self.fecha_guion(date)}.paf"
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

      def fecha()
        Date.strptime(self.date, '%Y-%m-%d')
      end

      def hora()
        self.date[11..].gsub "-", ":" #Mejorar
      end

      def self.create_path(date)
        "#{fecha_guion(date)}.paf"
      end
      
      def self.posicionarme_prof(professional)
        Dir.chdir(professional)
      end

      def self.fecha_guion(date)
        (date.gsub " ", "_").gsub ":", "-"
      end

      def self.crear_turno(date, name, surname, phone, notes = nil, professional)
        appointment = new(date, name, surname, phone, notes, professional)
        Polycon::Store.save_appointment(appointment)
      end

      def self.existe_turno?(date)
        File.exists?(self.create_path(date))
      end

      def self.leer_turno(date)
        File.read(self.create_path(date))
      end

      def self.cancelar_turno(date)
        File.delete(self.create_path(date))
      end

      def self.cancelar_turnos()
        f_actual = Time.now.strftime("%Y-%m-%d_%H-%M")
        Dir.foreach(".") do |turno|
          if (turno > f_actual)
            File.delete(turno)
          end
        end
      end

      def self.listar_turnos(professional, date = nil)

        #prof = Polycon::Models::Professionals.find(professional)
        #appts = prof.appointments
        #if options[:date]
        #  appts = appts.selct { |appt| appt.date == options[:date] }
        #end

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

      def self.fecha_posterior?(date)
        date > Time.now.strftime("%Y-%m-%d %H:%M")
      end

      def self.reprogramar_turno(old_date, new_date)
        File.rename(self.create_path(old_date), self.create_path(new_date))
      end

      def self.fecha_hora_correcta?(date)
        begin
          DateTime.strptime(date, '%Y-%m-%d %H:%M')
          true
        rescue
          false
        end
      end

      def self.fecha_correcta?(date)
        begin
          Date.strptime(date, '%Y-%m-%d')
          true
        rescue
          false
        end
      end
    end
  end
end