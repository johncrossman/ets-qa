require_relative '../../util/spec_helper'

module Page

  module JunctionPages

    include PageObject
    include Logging
    include Page

    # Header
    link(:log_out_link, id: 'log-out')

    # Footer
    div(:toggle_footer_link, id: 'toggle-show-dev-auth')
    text_field(:basic_auth_uid_input, id: 'basic-auth-uid')
    text_field(:basic_auth_password_input, id: 'basic-auth-password')
    button(:basic_auth_log_in_button, id: 'basic-auth-submit-button')

    # Loads a Junction LTI tool in Canvas and switches focus to the iframe
    # @param path [String]
    def load_tool_in_canvas(path)
      navigate_to "#{Utils.canvas_base_url}#{path}"
      switch_to_canvas_iframe JunctionUtils.junction_base_url
    end

    # Logs the user out
    def log_out
      toggle_footer_link_element.when_visible Utils.medium_wait
      wait_for_update_and_click log_out_link_element unless title.include? 'Home'
      log_out_link_element.when_not_present Utils.short_wait
    end

  end
end
