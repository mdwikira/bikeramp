module ExceptionHandler
    extend ActiveSupport::Concern

    included do
        rescue_from ActionController::ParameterMissing, with: :param_missing
    end

    private

    def param_missing(e)
        render json: {"message": "Parameter is missing. Request has to contain all of the specified parameters : start_address, end_address, price, date."}, status: :bad_request
    end
end