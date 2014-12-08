module Api
  class ApiController < ApplicationController
    respond_to :json

    rescue_from StandardError do |e|
      render json: { error: e.message }, status: 400
    end
  end
end
