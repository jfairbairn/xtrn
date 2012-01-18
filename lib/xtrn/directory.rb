module Xtrn
  class Directory

    def initialize(config, executor)
      @config = config
      @executor = executor
    end

    def update!
      @config.each do |entry|
        cmd = "svn info #{entry['url']}"
        puts cmd
        x = @executor.exec(cmd)
        puts x
        rev = YAML.load(x)["Last Changed Rev"]
        cmd = if File.directory?(entry['path'])
          'update'
        else
          'checkout'
        end

        @executor.exec("svn #{cmd} -r#{rev} #{entry['url']} #{entry['path']}")
      end
    end
  end
end
