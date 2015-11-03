
class RailsDbViews::Factory
  class AmbigousNameError < RuntimeError; end

  @symbols = {}

  class << self
    attr_reader :symbols

    def register_files symbol_class, files
      @symbols[symbol_class.to_s] ||= {}

      files.each do |file|
        symbol = symbol_class.new(file)

        if s=@symbols[symbol_class.to_s][symbol.name]
          raise AmbigousNameError, "between #{file} and #{s.path}"
        end

        @symbols[symbol_class.to_s][symbol.name] = symbol
      end

      @symbols.values.map(&:values).flatten.each(&:process_inverse_of_required!)
    end

    def drop(symbol_class)
      symbol_list = @symbols[symbol_class.to_s]

      symbol_list.values.each(&:drop!) if symbol_list
    end

    def create(symbol_class)
      symbol_list = @symbols[symbol_class.to_s]

      symbol_list.values.each(&:create!) if symbol_list
    end

    def get(symbol_class, name)
      (@symbols[symbol_class.to_s]||{})[name]
    end

    def clear!
      @symbols = {}
    end
  end
end
