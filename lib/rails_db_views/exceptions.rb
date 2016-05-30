module RailsDbViews
  class CircularReferenceError < RuntimeError; end

  class SymbolNotFound < RuntimeError; end
  class IllegalDirective < RuntimeError; end
  class AmbigousNameError < RuntimeError; end
end