module Api
  module V1
    class CollectionsController < ApplicationController
      before_action :find_collection, only: [:show, :destroy, :update]

      def show
        render json: [@collection], root: "collections"
      end

      def index
        @collections = Collection.updated_since(params[:last_updated])

        render json: @collections
      end

      def create
        @collection = Collection.new(collection_params)

        if @collection.save
          render json: @collection, root: "collections", status: :created,
            location: api_collection_url(@collection, host: HOST)
        else
          errors = { errors: @collection.errors.full_messages }
          render json: errors, status: :unprocessable_entity
        end
      end

      def destroy
        @collection.delete

        head status: :no_content
      end

      def update
        @collection.update(collection_params)
      end

      private

      def find_collection
        @collection = Collection.find(params["id"])
      rescue
        error = { error: 'The collection you were looking for could not be found' }
        render json: error, status: 404
      end

      def collection_params
        params_array = Array(params.require(:collections))
        ActionController::Parameters.new(params_array.first).permit(:name)
      end
    end
  end
end
