class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  URL_REGEXP = %r{(http|https)://[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(/.*)?}ix.freeze

  validates :name, :url, presence: true
  validates_format_of :url, with: URL_REGEXP

  def gist_url?(url)
    url.include?('gist.github.com')
  end
end
