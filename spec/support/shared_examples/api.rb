shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token if invalid' do
      do_request(method, api_path, params: { access_token: '1234' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'Request successful' do
  it 'returns 2xx status' do
    expect(response).to be_successful
  end
end

shared_examples_for 'Resource size matchable' do
  it 'returns list of resource' do
    expect(resource_resp.size).to eq resource.size
  end
end

shared_examples_for 'Resource public fields returnable' do
  it 'returns public fields' do
    attrs.each do |attr|
      expect(resource_resp[attr]).to eq resource.send(attr).as_json
    end
  end
end

shared_examples_for "Resource private fields aren't returnable" do
  it 'does not return private fields' do
    attrs.each do |attr|
      expect(json).to_not have_key(attr)
    end
  end
end
