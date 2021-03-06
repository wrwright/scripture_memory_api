module Api
  module V1
    class CardsController < ApplicationController
      before_action :find_card, only: [:show, :destroy, :update]

      def show
        render json: [@card], root: "cards"
      end

      def index
        @cards = Card.updated_since(params[:last_updated])

        render json: @cards
      end

      def create
        @card = Card.new(card_params)

        if @card.save
          render json: @card, root: "cards", status: :created,
            location: api_card_url(@card, host: HOST)
        else
          errors = { errors: @card.errors.full_messages }
          render json: errors, status: :unprocessable_entity
        end
      end

      def destroy
        @card.destroy

        head status: :no_content
      end

      def update
        @card.update(card_params)
      end

      private

      def find_card
        @card = Card.find(params["id"])
      rescue ActiveRecord::RecordNotFound
        error = { error: "The card you were looking for could not be found" }
        render json: error, status: 404
      end

      def card_params
        # Only anticipating one card on create, at this point
        # Hacking here because strong_parameters can't handle #require returning an array yet.
        params_array = Array(params.require(:cards))
        ActionController::Parameters.new(params_array.first).permit(:subject, :reference, :scripture, :translation)
      end
    end
  end
end
