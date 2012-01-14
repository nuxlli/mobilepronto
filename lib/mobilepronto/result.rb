# encoding: UTF-8

class MobilePronto
  class Result
    attr_reader :code
    attr_reader :error

    def initialize(code, error = nil)
      @code  = ["X01", "X02", :ok].include?(code) ? code : code.to_i
      @error = error
    end

    def on(*args)
      if block_given? and
         args.any? { |i| i.kind_of?(Range) ? i.include?(code) : i == code }
        yield
      end
    end

    def method_missing(method, *args, &block)
      if block_given? && !(code = /on_([0-9]*)/.match(method)).nil?
        self.on(code[1].to_i, &block)
      else
        super(method, *args, &block)
      end
    end
  end
end
