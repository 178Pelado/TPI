require 'erb'
require 'date'

module GridsHelper

  def grilla_de_un_dia(date, professional = nil)
    headers = %w[Hora/Día]
    title = 'Turnos de un día'

    fecha_pedida = Date.strptime(date, '%Y-%m-%d')

    filename = "Grilla del #{fecha_pedida} " + filename_grilla(professional)

    appointments = appointments_grilla(professional)
    appointments = appointments.select { |appt| appt.date.to_date == fecha_pedida }

    horas = horas_grilla()

    template = ERB.new(File.read(Rails.root.join("templates/a_day.html.erb")))
    File.open(Rails.root.join("tmp/#{filename}.html"), "w+") {|file| file.write("#{template.result binding}")}
    filename
  end

  def grilla_de_una_semana(date, professional = nil)
    headers = %w[Hora/Día]
    title = 'Turnos de una semana'

    fecha_pedida = Date.strptime(date, '%Y-%m-%d')

    filename = "Grilla de la semana del #{fecha_pedida} " + filename_grilla(professional)
    
    inicio_semana = fecha_pedida - fecha_pedida.wday()
    fin_semana = inicio_semana + 7
    appointments = appointments_grilla(professional)
    appointments = appointments.select { |appt| (inicio_semana..fin_semana).cover? appt.date.to_date }

    horas = horas_grilla()

    template = ERB.new(File.read(Rails.root.join("templates/a_week.html.erb")))
    File.open(Rails.root.join("tmp/#{filename}.html"), "w+") {|file| file.write("#{template.result binding}")}
    filename
  end

  def appointments_grilla(professional)
    if professional.nil?
      appointments = []
      Professional.all.each do |p|
        appointments += p.appointments
      end
    else
      appointments = professional.appointments
    end
    appointments
  end

  def filename_grilla(professional)
    if ! professional.nil?
      "para #{professional.name}"
    else
      "para todos los profesionales"
    end
  end

  def horas_grilla
    horas = []
    (8...20).each do |h|
      horas << "#{h}:00"
      horas << "#{h}:20"
      horas << "#{h}:40"
    end
    horas
  end

end