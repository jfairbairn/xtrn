module Xtrn
  class Executor
    def exec(cmd)
      `#{cmd}`
    end
  end
end

