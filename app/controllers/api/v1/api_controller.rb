module Api::V1
  class ApiController < ActionController::API

    include SimpleError
    self.simple_error_partial = "api/v1/shared/simple_error"

    rescue_from ActiveRecord::RecordNotFound do
      render_error(message: "Não encontrado", status: :not_found)
    end

    rescue_from ActionController::RoutingError do
      render_error(message: "URL inválida", status: :not_found)
    end
  end
end
