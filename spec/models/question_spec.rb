require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'fileable'
  it_behaves_like 'linkable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should have_one(:reward).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
end
