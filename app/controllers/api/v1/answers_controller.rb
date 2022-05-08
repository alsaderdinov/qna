module Api
  module V1
    class AnswersController < Api::V1::BaseController
      authorize_resource

      def index
        @question = Question.find(params[:question_id])
        render json: @question.answers
      end
    end
  end
end
