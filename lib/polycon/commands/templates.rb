module Polycon
  module Commands
    module Templates

      class CreateDay < Dry::CLI::Command
        desc 'Create an appointment'

        argument :date, required: true, desc: 'Current date of the appointment'
        option :professional, required: false, desc: 'Full date for the appointment'

        def call(date:, professional: nil)
          Polycon::Utils.posicionarme()
          Polycon::A_day.grilla_de_un_dia(date, professional)
        end
      end

      class CreateWeek < Dry::CLI::Command
        desc 'Create an appointment'

        argument :date, required: true, desc: 'Current date of the appointment'
        option :professional, required: false, desc: 'Full date for the appointment'

        def call(date:, professional: nil)
          Polycon::Utils.posicionarme()
          Polycon::A_week.grilla_de_una_semana(date, professional)
        end
      end

    end
  end
end