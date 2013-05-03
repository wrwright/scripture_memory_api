module Api
  module V1
    class CardsController < ApplicationController
      def index
        @cards = Card.updated_since(params[:last_updated])

        render json: @cards
      end

      def create
        @cards = Card.create(params["card"])

        render json: @cards
      end

      def destroy
        Card.delete(params["id"])
      end
    end
  end
end
