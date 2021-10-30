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
          professional = Polycon::Models::Professionals.find(name)
          if ! professional.nil?
            warn "Ya existe un profesional llamado #{name}"
          else
            Polycon::Models::Professionals.crear_directorio_prof(name)
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
          professional = Polycon::Models::Professionals.find(name)
          if ! professional.nil?
            if ! professional.has_appointments?
              professional.eliminar_directorio_prof()
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
          if Polycon::Models::Professionals.existen_prof?
            puts Polycon::Models::Professionals.all
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
          professional_old = Polycon::Models::Professionals.find(old_name)
          professional_new = Polycon::Models::Professionals.find(new_name)
          if ! professional_old.nil?
            if professional_new.nil?
              professional_old.renombrar_directorio_prof(new_name)
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
