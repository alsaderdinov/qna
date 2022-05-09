require 'rails_helper'

describe 'Answer API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
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

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer, :with_attachment) }
    let!(:comments) { create_list(:comment, 3, user: user, commentable: answer) }
    let!(:links) { create_list(:link, 3, linkable: answer) }
    let(:answer_resp) { json['answer'] }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context 'authorized' do
      before { get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request successful'

      it_behaves_like 'Resource public fields returnable' do
        let(:attrs) { %w[id body user_id created_at updated_at] }
        let(:resource_resp) { answer_resp }
        let(:resource) { answer }
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_resp) { answer_resp['comments'].first }

        it_behaves_like 'Request successful'

        it_behaves_like 'Resource size matchable' do
          let(:resource_resp) { answer_resp['comments'] }
          let(:resource) { comments }
        end

        it_behaves_like 'Resource public fields returnable' do
          let(:attrs) { %w[id body user_id created_at updated_at] }
          let(:resource_resp) { comment_resp }
          let(:resource) { comment }
        end
      end

      describe 'files' do
        let(:file) { answer.files.first }
        let(:file_resp) { answer_resp['files'].first }

        it_behaves_like 'Request successful'

        it_behaves_like 'Resource size matchable' do
          let(:resource_resp) { answer_resp['files'] }
          let(:resource) { answer.files }
        end

        it 'returns url fields' do
          expect(file_resp).to eq rails_blob_path(answer.files.first, only_path: true)
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_resp) { answer_resp['links'].first }

        it_behaves_like 'Request successful'

        it_behaves_like 'Resource size matchable' do
          let(:resource_resp) { answer_resp['links'] }
          let(:resource) { links }
        end

        it_behaves_like 'Resource public fields returnable' do
          let(:attrs) { %w[id url name created_at updated_at] }
          let(:resource_resp) { link_resp }
          let(:resource) { link }
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      describe 'create with valid attributes' do
        before do
          post api_path, params: { answer: attributes_for(:answer), access_token: access_token.token },
                         headers: headers
        end

        it_behaves_like 'Request successful'

        it 'saves a new answer in the database' do
          expect(Answer.count).to eq 4
        end

        it_behaves_like 'Resource public fields returnable' do
          let(:attrs) { %w[body] }
          let(:resource_resp) { json['answer'] }
          let(:resource) { Answer.last }
        end
      end

      describe 'create with invalid attributes' do
        before do
          post api_path,
               params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token }, headers: headers
        end

        it 'does not save a new answer in the database' do
          expect(Answer.count).to eq 3
        end

        it 'returns 422 status' do
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      describe 'update with valid attributes' do
        before do
          patch api_path, params: { answer: attributes_for(:answer), access_token: access_token.token },
                          headers: headers
        end

        it_behaves_like 'Request successful'

        it 'updates answer in the database' do
          expect(Answer.count).to eq 3
        end

        it_behaves_like 'Resource public fields returnable' do
          let(:attrs) { %w[body] }
          let(:resource_resp) { json['answer'] }
          let(:resource) { Answer.first }
        end
      end

      describe 'update with invalid attributes' do
        before do
          patch api_path,
                params: { answer: attributes_for(:answer, :invalid), access_token: access_token.token }, headers: headers
        end

        it 'does not update answer in the database' do
          expect(Answer.count).to eq 3
        end

        it 'returns 422 status' do
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      describe 'delete with valid attributes' do
        before do
          delete api_path, params: { access_token: access_token.token },
                           headers: headers
        end

        it_behaves_like 'Request successful'

        it 'deletes a answer from the database' do
          expect(Answer.count).to eq 2
        end
      end
    end
  end
end
