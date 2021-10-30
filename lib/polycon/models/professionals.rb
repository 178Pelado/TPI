module Polycon
  module Models
    class Professionals
      attr_accessor :name

      def initialize(name)
        @name = name
      end

      def self.find(name)
        professional = new(name)
        return professional if professional.exists?()
      end

      def self.crear_directorio_prof(name)
        Polycon::Store.save_professional(new(name))
      end

      def renombrar_directorio_prof(new_name)
        Polycon::Store::rename_professional(self, new_name)
      end

      def eliminar_directorio_prof()
        Polycon::Store.delete_professional(self)
      end

      def to_s
        "Nombre: #{name}"
      end

      def self.existen_prof?
        ! self.all().empty?
      end
  
      def exists?()
        Polycon::Store.exists_professional?(self)
      end

      def find_appointment(date)
        return Polycon::Models::Appointments.from_file(date, self) if Polycon::Store.exists_appointment?(date, self)
      end

      def appointments
        Polycon::Store.appointments(self).map do |entry|
          date = Polycon::Store.date(entry)
          Polycon::Models::Appointments.from_file(date, self)
        end
      end

      def listar_appointments(date)
        appts = appointments
        if date
          appts = appts.select { |appt| appt.fecha.to_s == date }
        end
        return appts
      end

      def has_appointments?
        !appointments.select do |appointment|
          appointment.date > Time.now.strftime("%Y-%m-%d_%H-%M")
        end.empty?
      end

      def cancel_all()
        appointments.each do |appointment|
          if appointment.date > Time.now.strftime("%Y-%m-%d_%H-%M")
            appointment.cancelar_turno
          end
        end
      end

      def self.all()
        Polycon::Store.professionals().map do |name|
          self.find(name)
        end
      end

    end
  end
end