module Polycon
  module Models
    class Professionals
      attr_accessor :name

      #Inicio nuevos métodos

      def initialize(name)
        @name = name
      end

      def self.existen_prof?
        ! self.all().empty?
      end

      def self.listar_prof
        self.all().each do |prof|
          puts prof.name
        end
      end

      def self.crear_directorio_prof(name)
        Polycon::Store.save_professional(new(name))
      end

      def eliminar_directorio_prof()
        Polycon::Store.delete_professional(self)
      end

      def renombrar_directorio_prof(new_name)
        Polycon::Store::rename_professional(self, new_name)
      end

      def self.find(name)
        professional = new(name)
        return professional if professional.exists?()
      end

      def exists?()
        Polycon::Store.exists_professional?(self)
      end

      def find_appointment(date)
        return Polycon::Models::Appointments.from_file(date, self) if Polycon::Store.exists_appointment?(date, self)
      end

      def appointments
        Polycon::Store.appointments(self).map do |entry|
          date = File.basename entry, ".paf"
          Polycon::Models::Appointments.from_file(date, self)
        end
      end

      def has_appointments?
        !appointments.select do |appointment|
          appointment.date > Time.now.strftime("%Y-%m-%d_%H-%M")
        end.empty?
      end

      def self.all()
        Polycon::Store.professionals().map do |name|
          self.find(name)
        end
      end

      #Fin nuevos métodos

    end
  end
end