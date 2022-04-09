class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_answer, only: %i[destroy update]
  before_action :find_question, only: %i[new create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    flash.now[:notice] = 'Your answer was successfully created.' if @answer.save
  end

  def update
    unless current_user.author_of?(@answer)
      flash.now[:alert] = 'You must be author of this answer'
      render 'questions/show'
      return
    end

    if @answer.update(answer_params)
      flash.now[:notice] = 'Your answer was succesfully updated.'
    else
      flash.now[:alert] = 'Fail answer update.'
    end
    @question = @answer.question
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash.now[:notice] = 'Your answer was successfully deleted.'
    else
      flash.now[:alert] = 'You must be author of this answer.'
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
