require "fileutils"
require 'date'

module Polycon
  module Store
    
    def self.root_path
      root_path = Dir.home + "/.polycon"
      FileUtils.mkdir_p root_path
      root_path
    end

    def self.table_path
      table_path = Dir.home + "/tables"
      FileUtils.mkdir_p table_path
      table_path
    end

    def self.filename(date)
      date = DateTime.strptime(date, '%Y-%m-%d %H:%M')
      date.strftime("%Y-%m-%d_%H-%M")
    end

    def self.date(entry)
      date = File.basename entry, ".paf"
      date = DateTime.strptime(date, '%Y-%m-%d_%H-%M')
      date.strftime("%Y-%m-%d %H:%M")
    end

    # @param Appointment appointment
    def self.save_appointment(appointment)
      filename = self.filename(appointment.date)
      File.open(root_path + "/#{appointment.professional.name}/#{filename}.paf", 'w') do |f|
        f << "#{appointment.surname}\n"
        f << "#{appointment.name}\n"
        f << "#{appointment.phone}\n"
        f << "#{appointment.notes}\n" unless appointment.notes.nil?
      end
    end

    # @param Professional professional
    def self.exists_appointment?(date, professional)
      filename = self.filename(date)
      File.exists?(root_path + "/#{professional.name}/#{filename}.paf")
    end

    # @param Appointment appointment
    def self.delete_appointment(appointment)
      filename = self.filename(appointment.date)
      File.delete(root_path + "/#{appointment.professional.name}/#{filename}.paf")
    end

    # @param Appointments appointment_old, String new_date
    def self.reschedule_appointment(appointment_old, new_date)
      filename_old = self.filename(appointment_old.date)
      filename_new = self.filename(new_date)
      turno_old = root_path + "/#{appointment_old.professional.name}/#{filename_old}.paf"
      turno_new = root_path + "/#{appointment_old.professional.name}/#{filename_new}.paf"
      File.rename(turno_old, turno_new)
    end

    # @param Appointment appointment
    def self.appointment_from_file(appointment)
      filename = self.filename(appointment.date)
      path = "#{root_path}/#{appointment.professional.name}/#{filename}.paf"
      File.open(path, 'r') do |file|
        appointment.surname = file.gets.chomp
        appointment.name = file.gets.chomp
        appointment.phone = file.gets.chomp
        appointment.notes = file.gets.chomp unless file.eof?
      end
      appointment
    end

    # @param Professional professional
    def self.save_professional(professional)
      FileUtils.mkdir_p root_path + "/#{professional.name}"
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

    def self.save_template(filename, template)
      File.write(table_path + "/#{filename}.html", template)
    end

    def self.hours()
      hours = []
      (8...20).each do |h|
        hours << "#{h}:00"
        hours << "#{h}:20"
        hours << "#{h}:40"
      end
      hours
    end

  end
end