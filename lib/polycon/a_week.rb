require 'erb'
require 'date'

module Polycon
  class A_week

    def self.grilla_de_una_semana(date, name = nil)
      headers = %w[Hora/Día]
      title = 'Turnos de una semana'

      fecha_pedida = Date.strptime(date, '%Y-%m-%d')

      filename = "Grilla de la semana del #{fecha_pedida} "

      if ! name.nil?
        prof = Polycon::Models::Professionals.find(name)
        appointments = prof.appointments
        filename += "para #{name}"
      else
        appointments = Polycon::Store.all_appointments()
        filename += "para todos los profesionales"
      end
      inicio_semana = fecha_pedida - fecha_pedida.wday()
      fin_semana = inicio_semana + 7
      appointments.select! { |appt| (inicio_semana..fin_semana).cover? appt.fecha() }

      horas = Polycon::Store.horas()

      template = ERB.new(File.read("/home/felipe/Ruby/TPI/a_week.html.erb"))
      Polycon::Store.save_template(filename, (template.result binding))
    end
  end
end