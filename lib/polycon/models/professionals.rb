module Polycon
  module Models
    class Professionals
      attr_accessor :name

      def initialize(name)
        @name = name
      end

      def self.existen_prof?
        ! Dir.empty?(".")
      end

      def self.listar_prof
        Dir.children(".").each do |prof|
          puts prof
        end
      end

      def self.crear_prof(name)
        Dir.mkdir(name)
      end

      #Inicio nuevos métodos

      def self.crear_directorio_prof(name)
        Polycon::Store.save_professional(new(name))
      end

      def self.find(name)
        professional = new(name)
        return professional if professional.exists?(name)
      end

      def exists?(name)
        Polycon::Store.exists_professional?(name)
      end

      def find_appointment(date)
        #Implementar llamado al Store y el self.from_file de appointments
      end

      def appointments
        Polycon::Models::Appointments.posicionarme_prof(name)
        Polycon::Store.appointments().map do |entry|
          date = File.basename entry, ".paf"
          Polycon::Models::Appointments.from_file(date)
        end
      end

      def has_appointments?
        !appointments.select do |appointment|
          appointment.date > Time.now.strftime("%Y-%m-%d_%H-%M")
        end.empty?
      end

      #Fin nuevos métodos

      def self.eliminar_prof(name)
        FileUtils.rm_rf(name)
      end

      def self.renombrar_prof(old_name, new_name)
        File.rename(old_name, new_name)
      end

      def self.hay_turno_prof?(name)
        f_actual = Time.now.strftime("%Y-%m-%d_%H-%M")
        Dir.foreach("./#{name}") do |turno|
          if (turno > f_actual)
            return true
          end
        end
        false
      end

    end
  end
end