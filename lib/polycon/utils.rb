module Polycon
  module Utils
    
    def self.posicionarme
      Dir.chdir(ENV["HOME"])
      Dir.mkdir("Polycon") unless File.exists?("Polycon")
      Dir.chdir("Polycon")
    end

    def self.existe_prof?(name)
      File.exists?(name)
    end
  end
end