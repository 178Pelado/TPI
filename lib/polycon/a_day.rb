require 'erb'
require 'date'

module Polycon
  class A_day

    def self.grilla_de_un_dia(date, name = nil)
      headers = %w[Hora/Día]
      title = 'Turnos de un día'

      if ! name.nil?
        prof = Polycon::Models::Professionals.find(name)
        appointments = prof.appointments
      else
        appointments = Polycon::Store.all_appointments()
      end
      fecha_pedida = Date.strptime(date, '%Y-%m-%d')
      appointments.select! { |appt| appt.fecha() == fecha_pedida }

      horas = Polycon::Utils.horas()

      template = ERB.new <<~END, nil, '-'
        <!DOCTYPE html>
          <html lang='en'>
          <head>
            <title><%= title %></title>
            <meta charset="UTF-8">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
          </head>
          <body>
            <table class="table table-bordered">
              <tr>
                <%- headers.each do |header| -%>
                  <th><%= header %></th>
                <%- end -%>
                <th><%= date %></th>
              </tr>
              <%- horas.each do |h| -%>
                <tr>
                  <th><%= h %></th>
                  <td>
                  <%- appointments.each do |a| -%>
                    <%- if a.hora() == h -%>
                      <%= a.name %> <%= a.surname %> (<%= a.professional %>)<br>
                    <%- end -%>
                  <%- end -%>
                  </td>
                </tr>
              <%- end -%>
            </table>
          </body>
        </html>
      END

      #puts template.result binding
      Polycon::Utils.posicionarme()
      File.write('prueba.html', (template.result binding))
    end
  end
end