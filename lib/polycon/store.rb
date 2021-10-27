require "fileutils"

module Polycon
  module Store
    
    def self.root_path
      root_path = Dir.home + "/.polycon"
      FileUtils.mkdir_p root_path
      root_path
    end

    # @param Professional professional
    def self.save_professional(professional)
      FileUtils.mkdir_p root_path + "/#{professional.name}"
    end

    # @param Appointment appointment
    def self.save_appointment(appointment)
      # appointment.date es DateTime
      filename = appointment.date.strftime("%Y-%m-%d_%H-%I")
      File.write(root_path + "/#{appointment.professional.name}/#{filename}.paf") do |f|
        f << appointment.surname
        f << appointment.name
        f << appointment.phone
        f << appointment.notes
      end
    end

    def self.exists_professional?(name)
      File.exists?(name)
    end

    def self.appointments()
      Dir.children(".")
    end

    def self.professionals()
      Dir.children(".").map do |entry|
        Polycon::Models::Professionals.find(entry)
      end
    end

    def self.all_appointments
      appointments = []
      (self.professionals).each do |p|
        appointments.push(*p.appointments)
        Polycon::Utils.posicionarme()
      end
      appointments
    end

  end
end