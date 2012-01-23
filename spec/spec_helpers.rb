module Xtrn
  module SpecHelpers
    class SVNCommand
      def initialize()
        @username_and_password = ''
        @standard_args = '--no-auth-cache'
      end

      def cmd(c)
        @cmd = c
        self
      end

      def args(a)
        @args = a
        self
      end

      def credentials(u, p)
        unless u.nil?
          @username_and_password = "--username '#{u}' --password '#{p}' "
        end
        self
      end

      def to_s
        "svn #{@cmd} #{@username_and_password}#{@standard_args} #{@args}"
      end

      def match(actual)
        actual == to_s
      end
    end
  end
end

