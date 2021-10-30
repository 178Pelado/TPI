module Polycon
  module Commands
    module Templates

      class CreateDay < Dry::CLI::Command
        desc 'Crea la grilla de un día'

        argument :date, required: true, desc: 'Date to filter appointments by (should be the day)'
        option :professional, required: false, desc: 'Full name of the professional'

        def call(date:, professional: nil)
          if ! professional.nil?
            prof = Polycon::Models::Professionals.find(professional)
            if prof.nil?
              warn "No se pudo crear la grilla, debido a que no existe el profesional #{professional}"
              return 1
            end
          end
          if Polycon::Models::Appointments.fecha_correcta?(date)
            Polycon::A_day.grilla_de_un_dia(date, professional)
            warn "Se creó la grilla del #{date}"
          else
            warn "No se pudo crear la grilla, debido a que la fecha #{date} no respeta el formato"
          end
        end
      end

      class CreateWeek < Dry::CLI::Command
        desc 'Crea la grilla de una semana'

        argument :date, required: true, desc: 'Fecha para filtrar los appoitments de esa semana'
        option :professional, required: false, desc: 'Full name of the professional'

        def call(date:, professional: nil)
          if ! professional.nil?
            prof = Polycon::Models::Professionals.find(professional)
            if prof.nil?
              warn "No se pudo crear la grilla, debido a que no existe el profesional #{professional}"
              return 1
            end
          end
          if Polycon::Models::Appointments.fecha_correcta?(date)
            Polycon::A_week.grilla_de_una_semana(date, professional)
            warn "Se creó la grilla de la semana del #{date}"
          else
            warn "No se pudo crear la grilla, debido a que la fecha #{date} no respeta el formato"
          end
        end
      end

    end
  end
end