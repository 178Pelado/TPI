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
  end
end