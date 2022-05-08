require 'rails_helper'

describe 'Answer API', type: :request do
  let(:headers) do
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  end
  let(:access_token) { create(:access_token) }
  let(:question) { create(:question) }
  let!(:answers) { create_list(:answer, 3, question: question) }
  let(:answers_resp) { json['answers'] }
  let(:answer) { answers.first }

  describe 'GET /api/v1/questions/:question_id/answers' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'authorized' do
      before do
        get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token }, headers: headers
      end

      it_behaves_like 'Request successful'

      it_behaves_like 'Resource size matchable' do
        let(:resource_resp) { answers_resp }
        let(:resource) { answers }
      end

      it_behaves_like 'Resource public fields returnable' do
        let(:attrs) { %w[id user_id body created_at updated_at] }
        let(:resource_resp) { answers_resp.first }
        let(:resource) { answer }
      end

      it_behaves_like 'Resource contains user' do
        let(:resource_resp) { answers_resp }
        let(:resource) { answer }
      end
    end
  end
end
