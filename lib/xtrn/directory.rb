module Xtrn
  class Directory

    def initialize(config, executor)
      @config = config
      @executor = executor
    end

    def update!
      @config.each do |entry|
        username = entry['username'] ? "--username '#{entry['username']}' " : ''
        password = entry['password'] ? "--password '#{entry['password']}' " : ''
        standard_args = "--no-auth-cache"

        x = @executor.exec("svn info #{username}#{password}#{standard_args} #{entry['url']}")
        rev = YAML.load(x)["Last Changed Rev"]
        cmd = if File.directory?(entry['path'])
          'update'
        else
          'checkout'
        end
        @executor.exec("svn #{cmd} #{username}#{password}#{standard_args} -r#{rev} #{entry['url']} #{entry['path']}")
      end

      def updated_gitignore(original_gitignore)
        to_add = @config.map{|i|i['path']}
        
        original_gitignore.each_line do |line|
          line.strip!
          to_add.delete(line)
        end
        return original_gitignore if to_add.empty?
        [*original_gitignore.lines.map(&:"strip!"), *to_add].join("\n")
      end
    end
  end
end
