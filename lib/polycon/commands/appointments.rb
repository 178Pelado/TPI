require "polycon/utils.rb"
require "polycon/models/appointments.rb"

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
          warn "TODO: Implementar creación de un turno con fecha '#{date}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          util = Polycon::Utils
          util.posicionarme()
          appo = Polycon::Models::Appointments
          if util.existe_prof?(professional)
            Dir.chdir(professional) #Modificar método posicionarme, con parámetro opcional
            if not appo.existe_turno?(date)
              appo.crear_turno(date, professional, name, surname, phone, notes)
              warn "Se creó un turno con el profesioanl #{professional} para el #{date}"
            else
              warn "No se pudo crear el turno, debido a que existe otro turno para esa fecha"
            end
          else
            warn "No se pudo crear el turno, debido a que no existe el profesional #{professional}"
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
          warn "TODO: Implementar detalles de un turno con fecha '#{date}' y profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          util = Polycon::Utils
          util.posicionarme()
          appo = Polycon::Models::Appointments
          if util.existe_prof?(professional)
            Dir.chdir(professional)
            if appo.existe_turno?(date)
              turno = appo.leer_turno(date)
              appo.mostrar_turno(turno)
            else
              warn "No existe un turno para el #{date} con el profesional #{professional}"
            end
          else
            warn "No se pudo mostrar el turno, debido a que no existe el profesional #{professional}"
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
          warn "TODO: Implementar borrado de un turno con fecha '#{date}' y profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          util = Polycon::Utils
          util.posicionarme()
          appo = Polycon::Models::Appointments
          if util.existe_prof?(professional)
            Dir.chdir(professional)
            if appo.existe_turno?(date)
              appo.cancelar_turno(date)
              warn "Se canceló el turno con el profesional #{professional}"
            else
              warn "No se pudo cancelar el turno para el #{date} con el profesional #{professional}, debido a que no existe en el sistema"
            end
          else
            warn "No se pudo cancelar el turno, debido a que no existe el profesional #{professional}"
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
          warn "TODO: Implementar borrado de todos los turnos de la o el profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          util = Polycon::Utils
          util.posicionarme()
          appo = Polycon::Models::Appointments
          if util.existe_prof?(professional)
            Dir.chdir(professional)
            appo.cancelar_turnos()
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
          warn "TODO: Implementar listado de turnos de la o el profesional '#{professional}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          util = Polycon::Utils
          util.posicionarme()
          appo = Polycon::Models::Appointments
          if util.existe_prof?(professional)
            Dir.chdir(professional)
            appo.listar_turnos(professional, date)
          else
            warn "No se pudieron listar turnos, debido a que no existe el profesional #{professional}"
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
          warn "TODO: Implementar cambio de fecha de turno con fecha '#{old_date}' para que pase a ser '#{new_date}'.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          util = Polycon::Utils
          util.posicionarme()
          appo = Polycon::Models::Appointments
          if util.existe_prof?(professional)
            Dir.chdir(professional)
            if not appo.existe_turno?(new_date)
              if appo.existe_turno?(old_date)
                appo.reprogramar_turno(old_date, new_date)
                warn "Se reprogramó el turno #{old_date} para #{new_date} del profesional #{professional}"
              else
                warn "No se pudo reprogramar el turno para el #{date} con el profesional #{professional}, debido a que no existe en el sistema"
              end
            else
              warn "No se pudo reprogramar el turno, debido a que existe otro turno para esa fecha"
            end
          else
            warn "No se pudo reprogramar el turno, debido a que no existe el profesional #{professional}"
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
          warn "TODO: Implementar modificación de un turno de la o el profesional '#{professional}' con fecha '#{date}', para cambiarle la siguiente información: #{options}.\nPodés comenzar a hacerlo en #{__FILE__}:#{__LINE__}."
          util = Polycon::Utils
          util.posicionarme()
          appo = Polycon::Models::Appointments
          if util.existe_prof?(professional)
            Dir.chdir(professional)
            if appo.existe_turno?(date)
              turno = File.readlines("#{appo.fecha_guion(date)}.paf")
              turno[0] = "#{options[:surname]}\n" if options[:surname] != nil
              turno[1] = "#{options[:name]}\n" if options[:name] != nil
              turno[2] = "#{options[:phone]}\n" if options[:phone] != nil
              turno[3] = "#{options[:notes]}\n" if options[:notes] != nil
              appo.crear_turno(date, professional, turno[1], turno[0], turno[2], turno[3])
              warn "Se comodificó correctamente el turno #{date} con el profesional #{professional}"
            else
              warn "No se pudo editar el turno para el #{date} con el profesional #{professional}, debido a que no existe en el sistema"
            end
          else
            warn "No se pudo editar el turno, debido a que no existe el profesional #{professional}"
          end
        end
      end
    end
  end
end
