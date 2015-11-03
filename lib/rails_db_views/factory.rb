
class RailsDbViews::Factory
  @symbols = {}

  class << self
    attr_reader :symbols

    def register_files symbol_class, files
      @symbols[symbol_class.to_s] ||= {}

      files.each do |file|
        symbol = symbol_class.new(file)
        @symbols[symbol_class.to_s][symbol.name] = symbol
      end
    end

    def drop(symbol_class)
      symbol_list = @symbols[symbol_class.to_s]
      if symbol_list
        symbol_list.each do |name, instance|
          instance.drop!
        end
      end
    end

    def create(symbol_class)
      symbol_list = @symbols[symbol_class.to_s]
      if symbol_list
        symbol_list.each do |name, instance|
          instance.create!
        end
      end
    end

    def get(symbol_class, name)
      (@symbols[symbol_class]||{})[name]
    end

    def clear!
      @symbols = {}
    end
  end
end
