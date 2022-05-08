require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) {
    { 'CONTENT_TYPE' => 'application/json',
      'ACCEPT' => 'application/json' }
  }

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'authorized' do
      let(:me) { create :user }
      let(:me_resp) { json['user'] }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request successful'

      it_behaves_like 'Resource public fields returnable' do
        let(:attrs) { %w[id email admin created_at updated_at] }
        let(:resource_resp) { me_resp }
        let(:resource) { me }
      end

      it_behaves_like "Resource private fields aren't returnable" do
        let(:attrs) { %w[password encrypted_password] }
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }
      let(:me) { create(:user) }
      let(:user) { users.first }
      let(:user_resp) { json['users']}
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'Request successful'

      it_behaves_like 'Resource size matchable' do
        let(:resource_resp) { user_resp }
        let(:resource) { users }
      end

      it_behaves_like 'Resource public fields returnable' do
        let(:attrs) { %w[id admin email created_at updated_at] }
        let(:resource_resp) { user_resp.first }
        let(:resource) { user }
      end

      it 'does not return signed_in user' do
        json['users'].each do |u|
          expect(u['id']).to_not eq me.id
        end
      end

      it_behaves_like "Resource private fields aren't returnable" do
        let(:attrs) { %w[password encrypted_password]}
      end
    end
  end
end
