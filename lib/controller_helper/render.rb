module ControllerHelper
  module Render
    protected
    def render_success(status_code, response_json = {})
      render_json(status_code, response_json)
    end

    def render_error(status_code, error_code, message)
      response_json = {
        error: {
          code: error_code,
          message: message
        }
      }

      render_json(status_code, response_json)
    end

    def render_json(status_code, response_json)
      render status: status_code, json: response_json
    end
  end
end
