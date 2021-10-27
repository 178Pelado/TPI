module Polycon
  module Commands
    module Professionals

      class Create < Dry::CLI::Command
        desc 'Create a professional'

        argument :name, required: true, desc: 'Full name of the professional'

        example [
          '"Alma Estevez"      # Creates a new professional named "Alma Estevez"',
          '"Ernesto Fernandez" # Creates a new professional named "Ernesto Fernandez"'
        ]

        def call(name:, **)
          Polycon::Utils.posicionarme()
          if Polycon::Utils.existe_prof?(name)
            warn "Ya existe un profesional llamado #{name}"
          else
            Polycon::Models::Professionals.crear_prof(name)
            warn "Se creó correctamente al profesional #{name}"
          end
        end
      end

      class Delete < Dry::CLI::Command
        desc 'Delete a professional (only if they have no appointments)'

        argument :name, required: true, desc: 'Name of the professional'

        example [
          '"Alma Estevez"      # Deletes a new professional named "Alma Estevez" if they have no appointments',
          '"Ernesto Fernandez" # Deletes a new professional named "Ernesto Fernandez" if they have no appointments'
        ]

        def call(name: nil)
          Polycon::Utils.posicionarme()
          if Polycon::Utils.existe_prof?(name)
            if ! Polycon::Models::Professionals.hay_turno_prof?(name)
              Polycon::Models::Professionals.eliminar_prof(name)
              warn "Se eiminó al profesional #{name}"
            else
              warn "No se puede eliminar al profesional, debido a que tiene turnos pendientes"
            end
          else
            warn "No se puede eliminar al profesional, debido a que no existe ninguno llamado #{name}"
          end
        end
      end

      class List < Dry::CLI::Command
        desc 'List professionals'

        example [
          "          # Lists every professional's name"
        ]

        def call(*)
          Polycon::Utils.posicionarme()
          if Polycon::Models::Professionals.existen_prof?
            Polycon::Models::Professionals.listar_prof
          else
            warn "No hay profesionales cargados en el sistema"
          end
        end
      end

      class Rename < Dry::CLI::Command
        desc 'Rename a professional'

        argument :old_name, required: true, desc: 'Current name of the professional'
        argument :new_name, required: true, desc: 'New name for the professional'

        example [
          '"Alna Esevez" "Alma Estevez" # Renames the professional "Alna Esevez" to "Alma Estevez"',
        ]

        def call(old_name:, new_name:, **)
          Polycon::Utils.posicionarme()
          if Polycon::Utils.existe_prof?(old_name)
            if ! Polycon::Utils.existe_prof?(new_name)
              Polycon::Models::Professionals.renombrar_prof(old_name, new_name)
              warn "Se actualizó el profesional #{old_name} y ahora se llama #{new_name}"
            else
              warn "No se puede renombrar al profesional, debido a que ya existe uno llamado #{new_name}"
            end
          else
            warn "No se puede renombrar al profesional, debido a que no existe ninguno llamado #{old_name}"
          end
        end
      end
    end
  end
end
