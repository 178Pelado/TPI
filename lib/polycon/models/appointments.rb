module Polycon
  module Models
    class Appointments
      
      def self.fecha_guion(date)
        (date.gsub " ", "_").gsub ":", "-"
      end

      def self.leer_turno(date)
        File.readlines("#{self.fecha_guion(date)}.paf")
      end

      def self.mostrar_turno(turno)
        turno.each do |linea|
          puts linea
        end
      end

    end
  end
end