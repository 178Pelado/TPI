require 'erb'
require 'date'

module Polycon
  class A_week

    def self.grilla_de_una_semana(date, name = nil)
      headers = %w[Hora/Día]
      title = 'Turnos de una semana'

      if ! name.nil?
        prof = Polycon::Models::Professionals.find(name)
        appointments = prof.appointments
      else
        appointments = Polycon::Store.all_appointments()
      end
      fecha_pedida = Date.strptime(date, '%Y-%m-%d')
      inicio_semana = fecha_pedida - fecha_pedida.wday()
      fin_semana = inicio_semana + 7
      appointments.select! { |appt| (inicio_semana..fin_semana).cover? appt.fecha() }

      horas = Polycon::Utils.horas()

      template = ERB.new <<~END, nil, '-'
        <!DOCTYPE html>
          <html lang='en'>
          <head>
            <title><%= title %></title>
            <meta charset="UTF-8">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
          </head>
          <body>
              <table class="table table-bordered text-center">
              <tr>
                <%- headers.each do |header| -%>
                  <th><%= header %></th>
                <%- end -%>
                <%- (inicio_semana...fin_semana).each do |f| -%>
                  <th><%= f %></th>
                <%- end -%>
              </tr>
              <%- horas.each do |h| -%>
                <tr>
                  <th><%= h %></th>
                  <%- (inicio_semana...fin_semana).each do |f| -%>
                    <td>
                    <%- appointments.each do |a| -%>
                      <%- if a.hora() == h && a.fecha() == f -%>
                        <%= a.name %> <%= a.surname %> (<%= a.professional %>)<br>
                      <%- end -%>
                    <%- end -%>
                    </td>
                  <%- end -%>
                </tr>
              <%- end -%>
            </table>
          </body>
        </html>
      END

      #puts template.result binding
      Polycon::Store.save_template(template.result binding)
    end
  end
end