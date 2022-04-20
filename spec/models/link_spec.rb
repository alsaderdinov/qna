require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  invalid_urls = %w[http:// http://.com htttp://www.website.com http://foo_bar.com http://r?ksmorgas.com new://www.website.com]
  valid_urls = %w[https://example.com https://www.example.com/ http://втф.com www.example.de somesite.travel]

  it { should_not allow_values(invalid_urls).for(:url) }
  it { should allow_values(valid_urls).for(:url) }
end
