module Polycon
  module Models
    class Professionals

      def self.existen_prof?
        not Dir.empty?(".")
      end

      def self.listar_prof
        Dir.children(".").each do |prof|
          puts prof
        end
      end

      def self.crear_prof(name)
        Dir.mkdir(name)
      end

      def self.eliminar_prof(name)
        FileUtils.rm_rf(name)
      end

      def self.renombrar_prof(old_name, new_name)
        File.rename(old_name, new_name)
      end

      def self.hay_turno_prof?(name)
        f_actual = Time.now.strftime("%Y-%m-%d_%H:%M")
        Dir.foreach("./#{name}") do |turno|
          if (turno > f_actual)
            return true
          end
        end
      end

    end
  end
end