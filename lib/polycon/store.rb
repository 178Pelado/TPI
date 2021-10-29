require "fileutils"
require 'date'

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
      date = DateTime.strptime(appointment.date, '%Y-%m-%d %H:%M')
      filename = date.strftime("%Y-%m-%d_%H-%M")
      File.open(root_path + "/#{appointment.professional.name}/#{filename}.paf", 'w') do |f|
        f << "#{appointment.surname}\n"
        f << "#{appointment.name}\n"
        f << "#{appointment.phone}\n"
        f << "#{appointment.notes}\n" unless appointment.notes.nil?
      end
    end

    # @param Professional professional
    def self.exists_appointment?(date, professional)
      date = DateTime.strptime(date, '%Y-%m-%d %H:%M')
      date = date.strftime("%Y-%m-%d_%H-%M")
      File.exists?(root_path + "/#{professional.name}/#{date}.paf")
    end

    # @param Professional professional
    def self.exists_professional?(professional)
      File.exists?(root_path + "/#{professional.name}")
    end

    # @param Professional professional
    def self.delete_professional(professional)
      FileUtils.rm_rf root_path + "/#{professional.name}"
    end

    # @param Professional professional_old, String new_name
    def self.rename_professional(professional_old, new_name)
      File.rename(root_path + "/#{professional_old.name}", root_path + "/#{new_name}")
    end

    # @param Professional professional
    def self.appointments(professional)
      Dir.children(root_path + "/#{professional.name}")
    end

    def self.professionals()
      Dir.children(root_path)
    end

    def self.all_appointments
      appointments = []
      (Polycon::Models::Professionals.all).each do |p|
        appointments += p.appointments
      end
      appointments
    end

    def self.save_template(template)
      File.write(root_path + '/prueba.html', template)
    end

  end
end