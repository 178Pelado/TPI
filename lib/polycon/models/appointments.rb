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
        appointment.professional = professional
        appointment.date = date
        Polycon::Store.appointment_from_file(appointment)
      end

      def self.crear_turno(date, name, surname, phone, notes = nil, professional)
        appointment = new(date, name, surname, phone, notes, professional)
        Polycon::Store.save_appointment(appointment)
      end

      def save()
        Polycon::Store.save_appointment(self)
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

      def to_s()
        "-------------------------------------------------\n" \
        "Profesional: #{professional.name}\n" \
        "Paciente: #{name} #{surname}\n" \
        "Teléfono: #{phone}\n" \
        "Fecha: #{fecha}\n" \
        "Hora: #{hora}\n" \
        "Notas: #{notes.nil? ? '-' : notes}\n" \
        "-------------------------------------------------"
      end

      def cancelar_turno()
        Polycon::Store.delete_appointment(self)
      end

      def reprogramar_turno(new_date)
        Polycon::Store::reschedule_appointment(self, new_date)
      end

      def self.fecha_posterior?(date)
        date > Time.now.strftime("%Y-%m-%d %H:%M")
      end

      def self.fecha_hora_correcta?(date)
        begin
          DateTime.strptime(date, '%Y-%m-%d %H:%M')
          true
        rescue
          false
        end
      end

      def self.fecha_hora_turno_correcta?(date)
        fecha_hora = DateTime.strptime(date, '%Y-%m-%d %H:%M')
        horarios = [0, 20, 40]
        horarios.include?(fecha_hora.min)
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