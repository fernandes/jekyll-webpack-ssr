require 'execjs'
require 'cgi'

module Jekyll
  class ReactTag < Liquid::Tag
    def initialize(tag_name, text, token)
      super
      process_params(text)
    end

    def render(context)
      # # params
      component_name = @component_name
      props = @props.to_json
      prerender_options = {}

      # # initialize
      js_code = read_file('bundle.js')
      @context = ExecJS.compile(GLOBAL_WRAPPER + js_code)

      # render
      js_executed_before = before_render(component_name, props, prerender_options)
      js_executed_after = after_render(component_name, props, prerender_options)
      js_main_section = main_render(component_name, props, prerender_options)
      component_js = render_from_parts(js_executed_before, js_main_section, js_executed_after)

      "<div data-react-class=\"#{component_name}\" data-react-props=\"#{CGI.escapeHTML(props)}\">#{component_js}</div>"
    rescue Exception => e
      puts e.message
    end

    def main_render(component_name, props, prerender_options)
      render_function = 'renderToString'
      "this.ReactRailsUJS.serverRender('#{render_function}', '#{component_name}', #{props})"
    end

    def read_file(filename)
      dir = File.dirname(__FILE__)
      file = File.join(dir, '..', 'js', filename)
      File.read(file)
    end

    # Hooks for inserting JS before/after rendering
    def before_render(component_name, props, prerender_options); ''; end
    def after_render(component_name, props, prerender_options); ''; end

    # Handle Node.js & other ExecJS contexts
    GLOBAL_WRAPPER = <<-JS
      var global = global || this;
      var self = self || this;
    JS

    private

      def render_from_parts(before, main, after)
        js_code = compose_js(before, main, after)
        @context.eval(js_code)
      end

      def compose_js(before, main, after)
        <<-JS
          (function () {
            #{before}
            var result = #{main};
            #{after}
            return result;
          })()
        JS
      end

      def process_params(params)
        @component_name, @props = params.split("|")
        @props = YAML.load(@props)
      end
  end
end

Liquid::Template.register_tag('react', Jekyll::ReactTag)
