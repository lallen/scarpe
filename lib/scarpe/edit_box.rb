# frozen_string_literal: true

class Scarpe
  class EditBox < Scarpe::Widget
    display_properties :text, :height, :width

    def initialize(text = nil, height: nil, width: nil, &block)
      @text = text || block.call

      super

      bind_self_event("change") do |new_text|
        self.text = new_text
        @callback&.call(new_text)
      end

      create_display_widget
    end

    def change(&block)
      @callback = block
    end
  end

  class WebviewEditBox < Scarpe::WebviewWidget
    attr_reader :text, :height, :width

    def initialize(properties)
      super

      # The JS handler sends a "change" event, which we forward to the Shoes widget tree
      bind("change") do |new_text|
        send_display_event(new_text, event_name: "change", target: shoes_linkable_id)
      end
    end

    def properties_changed(changes)
      t = changes.delete("text")
      if t
        html_element.value = t
      end

      super
    end

    def element
      oninput = handler_js_code("change", "this.value")

      HTML.render do |h|
        h.textarea(id: html_id, oninput: oninput, style: style) { text }
      end
    end

    private

    def style
      styles = {}

      styles[:height] = Dimensions.length(height)
      styles[:width] = Dimensions.length(width)

      styles.compact
    end
  end
end
