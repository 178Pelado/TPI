module Polycon
  module Utils
    
    def self.posicionarme
      Dir.chdir(ENV["HOME"])
      Dir.mkdir(".polycon") unless File.exists?(".polycon")
      Dir.chdir(".polycon")
    end

    def self.existe_prof?(name)
      File.exists?(name)
    end

    def self.horas()
      horas = []
      (8...20).each do |h|
        horas << "#{h}:00"
        horas << "#{h}:20"
        horas << "#{h}:40"
      end
      horas
    end

  end
end