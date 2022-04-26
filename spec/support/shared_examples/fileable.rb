require 'rails_helper'

shared_examples_for 'fileable' do
  it 'has many attached' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
