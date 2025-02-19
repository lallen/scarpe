# frozen_string_literal: true

class Scarpe
  class DocumentRoot < Scarpe::Widget
    include Scarpe::Background

    def initialize
      super

      create_display_widget
    end

    # This can be absolutely huge in console output, and it's frequently printed.
    def inspect
      "<Scarpe::DocumentRoot>"
    end

    alias_method :info, :puts
  end
end
