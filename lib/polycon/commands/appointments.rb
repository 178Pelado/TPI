module Polycon
  module Commands
    module Appointments

      class Create < Dry::CLI::Command
        desc 'Create an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: true, desc: "Patient's name"
        option :surname, required: true, desc: "Patient's surname"
        option :phone, required: true, desc: "Patient's phone number"
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name=Carlos --surname=Carlosi --phone=2213334567'
        ]

        def call(date:, professional:, name:, surname:, phone:, notes: nil)
          Polycon::Utils.posicionarme()
          if Polycon::Models::Appointments.fecha_hora_correcta?(date)
            if Polycon::Models::Appointments.fecha_posterior?(date)
              if Polycon::Utils.existe_prof?(professional)
                Polycon::Models::Appointments.posicionarme_prof(professional)
                if ! Polycon::Models::Appointments.existe_turno?(date)
                  Polycon::Models::Appointments.crear_turno(date, name, surname, phone, notes)
                  warn "Se creó un turno con el profesional #{professional} para el #{date}"
                else
                  warn "No se pudo crear el turno, debido a que existe otro turno para esa fecha"
                end
              else
                warn "No se pudo crear el turno, debido a que no existe el profesional #{professional}"
              end
            else
              warn "No se pudo crear el turno, debido a que #{date} es anterior a la fecha actual"
            end
          else
            warn "No se pudo crear el turno, debido a que la fecha #{date} no respeta el formato"
          end
        end
      end

      class Show < Dry::CLI::Command
        desc 'Show details for an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Shows information for the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          Polycon::Utils.posicionarme()
          if Polycon::Models::Appointments.fecha_hora_correcta?(date)
            if Polycon::Utils.existe_prof?(professional)
              Polycon::Models::Appointments.posicionarme_prof(professional)
              if Polycon::Models::Appointments.existe_turno?(date)
                puts Polycon::Models::Appointments.leer_turno(date)
              else
                warn "No existe un turno para el #{date} con el profesional #{professional}"
              end
            else
              warn "No se pudo mostrar el turno, debido a que no existe el profesional #{professional}"
            end
          else
            warn "No se pudo mostrar el turno, debido a que la fecha #{date} no respeta el formato"
          end
        end
      end

      class Cancel < Dry::CLI::Command
        desc 'Cancel an appointment'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" # Cancels the appointment with Alma Estevez on the specified date and time'
        ]

        def call(date:, professional:)
          Polycon::Utils.posicionarme()
          if Polycon::Models::Appointments.fecha_hora_correcta?(date)
            if Polycon::Utils.existe_prof?(professional)
              Polycon::Models::Appointments.posicionarme_prof(professional)
              if Polycon::Models::Appointments.existe_turno?(date)
                Polycon::Models::Appointments.cancelar_turno(date)
                warn "Se canceló el turno con el profesional #{professional}"
              else
                warn "No se pudo cancelar el turno para el #{date} con el profesional #{professional}, debido a que no existe en el sistema"
              end
            else
              warn "No se pudo cancelar el turno, debido a que no existe el profesional #{professional}"
            end
          else
            warn "No se pudo cancelar el turno, debido a que la fecha #{date} no respeta el formato"
          end
        end
      end

      class CancelAll < Dry::CLI::Command
        desc 'Cancel all appointments for a professional'

        argument :professional, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez" # Cancels all appointments for professional Alma Estevez',
        ]

        def call(professional:)
          Polycon::Utils.posicionarme()
          if Polycon::Utils.existe_prof?(professional)
            Polycon::Models::Appointments.posicionarme_prof(professional)
            Polycon::Models::Appointments.cancelar_turnos()
            warn "Se cancelaron todos los turnos del profesional #{professional}"
          else
            warn "No se pudieron cancelar turnos, debido a que no existe el profesional #{professional}"
          end          
        end
      end

      class List < Dry::CLI::Command
        desc 'List appointments for a professional, optionally filtered by a date'

        argument :professional, required: true, desc: 'Full name of the professional'
        option :date, required: false, desc: 'Date to filter appointments by (should be the day)'

        example [
          '"Alma Estevez" # Lists all appointments for Alma Estevez',
          '"Alma Estevez" --date="2021-09-16" # Lists appointments for Alma Estevez on the specified date'
        ]

        def call(professional:, date: nil)
          Polycon::Utils.posicionarme()
          if (date.nil?) || Polycon::Models::Appointments.fecha_correcta?(date)
            if Polycon::Utils.existe_prof?(professional)
              turnos = Polycon::Models::Appointments.listar_turnos(professional, date)
              if turnos.empty?
                warn "No hay turnos para el #{date}"
              else
                puts turnos
              end
            else
              warn "No se pudieron listar turnos, debido a que no existe el profesional #{professional}"
            end
          else
            warn "No se pudieron listar turnos, debido a que la fecha #{date} no respeta el formato"
          end 
        end
      end

      class Reschedule < Dry::CLI::Command
        desc 'Reschedule an appointment'

        argument :old_date, required: true, desc: 'Current date of the appointment'
        argument :new_date, required: true, desc: 'New date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'

        example [
          '"2021-09-16 13:00" "2021-09-16 14:00" --professional="Alma Estevez" # Reschedules appointment on the first date for professional Alma Estevez to be now on the second date provided'
        ]

        def call(old_date:, new_date:, professional:)
          Polycon::Utils.posicionarme()
          if Polycon::Models::Appointments.fecha_hora_correcta?(old_date)
            if Polycon::Models::Appointments.fecha_hora_correcta?(new_date)
              if Polycon::Utils.existe_prof?(professional)
                Polycon::Models::Appointments.posicionarme_prof(professional)
                if Polycon::Models::Appointments.existe_turno?(old_date)
                  if ! Polycon::Models::Appointments.existe_turno?(new_date)
                    if Polycon::Models::Appointments.fecha_posterior?(new_date)
                      Polycon::Models::Appointments.reprogramar_turno(old_date, new_date)
                      warn "Se reprogramó el turno #{old_date} para #{new_date} del profesional #{professional}"
                    else
                      warn "No se pudo reprogramar el turno, debido a que #{new_date} es anterior a la fecha actual"
                    end
                  else
                    warn "No se pudo reprogramar el turno, debido a que existe otro turno para esa fecha"
                  end
                else
                  warn "No se pudo reprogramar el turno para el #{old_date} con el profesional #{professional}, debido a que no existe en el sistema"
                end
              else
                warn "No se pudo reprogramar el turno, debido a que no existe el profesional #{professional}"
              end
            else
              warn "No se pudo reprogramar el turno, debido a que la fecha #{new_date} no respeta el formato"
            end
          else
            warn "No se pudo reprogramar el turno, debido a que la fecha #{old_date} no respeta el formato"
          end 
        end
      end

      class Edit < Dry::CLI::Command
        desc 'Edit information for an appointments'

        argument :date, required: true, desc: 'Full date for the appointment'
        option :professional, required: true, desc: 'Full name of the professional'
        option :name, required: false, desc: "Patient's name"
        option :surname, required: false, desc: "Patient's surname"
        option :phone, required: false, desc: "Patient's phone number"
        option :notes, required: false, desc: "Additional notes for appointment"

        example [
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" # Only changes the patient\'s name for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --name="New name" --surname="New surname" # Changes the patient\'s name and surname for the specified appointment. The rest of the information remains unchanged.',
          '"2021-09-16 13:00" --professional="Alma Estevez" --notes="Some notes for the appointment" # Only changes the notes for the specified appointment. The rest of the information remains unchanged.',
        ]

        def call(date:, professional:, **options)
          Polycon::Utils.posicionarme()
          if Polycon::Models::Appointments.fecha_hora_correcta?(date)
            if Polycon::Utils.existe_prof?(professional)
              Polycon::Models::Appointments.posicionarme_prof(professional)
              if Polycon::Models::Appointments.existe_turno?(date)
                turno = Polycon::Models::Appointments.from_file(date)
                turno.edit(options)
                turno.save(date)
                warn "Se editó el turno #{date} del profesional #{professional}"
              else
                warn "No se pudo editar el turno para el #{date} con el profesional #{professional}, debido a que no existe en el sistema"
              end
            else
              warn "No se pudo editar el turno, debido a que no existe el profesional #{professional}"
            end
          else
            warn "No se pudo editar el turno, debido a que la fecha #{date} no respeta el formato"
          end
        end
      end
    end
  end
end
