module Api
  module V1
    class QuestionsController < Api::V1::BaseController
      authorize_resource

      def index
        @questions = Question.all
        render json: @questions
      end

      def show
        @question = Question.find(params[:id])
        render json: @question
      end
    end
  end
end
