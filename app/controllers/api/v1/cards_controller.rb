module Api
  module V1
    class CardsController < ApplicationController
      before_filter :find_card, only: [:destroy, :update]

      def index
        @cards = Card.updated_since(params[:last_updated])

        render json: @cards
      end

      def create
        @cards = Card.create(params["card"])

        render json: @cards, status: 201
      end

      def destroy
        @card.destroy
      end

      def update
        @card.update_attributes(params["card"])
      end

      private

      def find_card
        @card = Card.find(params["id"])
      rescue ActiveRecord::RecordNotFound
        error = { error: "The card you were looking for could not be found" }
        render json: error, status: 404
      end
    end
  end
end
