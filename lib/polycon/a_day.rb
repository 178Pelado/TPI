require 'erb'
require 'date'

module Polycon
  class A_day

    def self.grilla_de_un_dia(date, name = nil)
      headers = %w[Hora/Día]
      title = 'Turnos de un día'

      fecha_pedida = Date.strptime(date, '%Y-%m-%d')

      filename = "Grilla del #{fecha_pedida} "

      if ! name.nil?
        prof = Polycon::Models::Professionals.find(name)
        appointments = prof.appointments
        filename += "para #{name}"
      else
        appointments = Polycon::Store.all_appointments()
        filename += "para todos los profesionales"
      end
      appointments.select! { |appt| appt.fecha() == fecha_pedida }

      horas = Polycon::Store.horas()

      template = ERB.new(File.read("/home/felipe/Ruby/TPI/a_day.html.erb"))
      Polycon::Store.save_template(filename, (template.result binding))
    end
  end
end