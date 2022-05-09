require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:questions_resp) { json['questions'] }
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 3) }
      let(:question) { questions.first }
      before { get '/api/v1/questions', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request successful'

      it_behaves_like 'Resource size matchable' do
        let(:resource_resp) { questions_resp }
        let(:resource) { questions }
      end

      it_behaves_like 'Resource public fields returnable' do
        let(:attrs) { %w[id title body created_at updated_at] }
        let(:resource_resp) { questions_resp.first }
        let(:resource) { question }
      end

      it_behaves_like 'Resource contains user' do
        let(:resource_resp) { questions_resp }
        let(:resource) { question }
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:question) { create(:question, :with_attachment) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'authorized' do
      let(:question_resp) { json['question'] }
      let!(:comments) { create_list(:comment, 3, commentable: question, user: user) }
      let!(:links) { create_list(:link, 3, linkable: question) }
      before { get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request successful'

      it_behaves_like 'Resource public fields returnable' do
        let(:attrs) { %w[id title body created_at updated_at] }
        let(:resource_resp) { question_resp }
        let(:resource) { question }
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_resp) { question_resp['comments'].first }

        it_behaves_like 'Request successful'

        it_behaves_like 'Resource size matchable' do
          let(:resource_resp) { question_resp['comments'] }
          let(:resource) { comments }
        end

        it_behaves_like 'Resource public fields returnable' do
          let(:attrs) { %w[id body user_id created_at updated_at] }
          let(:resource_resp) { comment_resp }
          let(:resource) { comment }
        end
      end

      describe 'files' do
        let(:file) { question.files.first }
        let(:file_resp) { question_resp['files'].first }

        it_behaves_like 'Request successful'

        it_behaves_like 'Resource size matchable' do
          let(:resource_resp) { question_resp['files'] }
          let(:resource) { question.files }
        end

        it 'returns url fields' do
          expect(file_resp).to eq rails_blob_path(question.files.first, only_path: true)
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_resp) { question_resp['links'].first }

        it_behaves_like 'Request successful'

        it_behaves_like 'Resource size matchable' do
          let(:resource_resp) { question_resp['links'] }
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

  describe 'POST /api/v1/questions' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:question) { create(:question, user: user) }

      describe 'create with valid attributes' do
        before do
          post '/api/v1/questions', params: { question: attributes_for(:question), access_token: access_token.token },
                                    headers: headers
        end

        it_behaves_like 'Request successful'

        it 'saves a new question in the database' do
          expect(Question.count).to eq 1
        end

        it_behaves_like 'Resource public fields returnable' do
          let(:attrs) { %w[title body] }
          let(:resource_resp) { json['question'] }
          let(:resource) { question }
        end
      end

      describe 'create with invalid attributes' do
        before do
          post '/api/v1/questions',
               params: { question: attributes_for(:question, :invalid), access_token: access_token.token }, headers: headers
        end

        it 'does not save a new question in the database' do
          expect(Question.count).to eq 0
        end

        it 'returns 422 status' do
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let!(:question) { create(:question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'authorized' do
      describe 'update with valid attributes' do
        before do
          patch "/api/v1/questions/#{question.id}", params: { question: attributes_for(:question), access_token: access_token.token },
                                                    headers: headers
        end

        it_behaves_like 'Request successful'

        it 'updates a question in the database' do
          expect(Question.count).to eq 1
        end

        it_behaves_like 'Resource public fields returnable' do
          let(:attrs) { %w[title body] }
          let(:resource_resp) { json['question'] }
          let(:resource) { question }
        end
      end

      describe 'update with invalid attributes' do
        before do
          patch "/api/v1/questions/#{question.id}",
                params: { question: attributes_for(:question, :invalid), access_token: access_token.token }, headers: headers
        end

        it 'does not update a question in the database' do
          expect(Question.count).to eq 1
        end

        it 'returns 422 status' do
          expect(response.status).to eq 422
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let!(:question) { create(:question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'authorized' do
      describe 'delete with valid attributes' do
        before do
          delete "/api/v1/questions/#{question.id}", params: { access_token: access_token.token },
                                                     headers: headers
        end

        it_behaves_like 'Request successful'

        it 'deletes a question from the database' do
          expect(Question.count).to eq 0
        end
      end
    end
  end
end
