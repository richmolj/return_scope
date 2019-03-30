class PostResource < ApplicationResource
  attribute :title, :string

  has_many :comments
end
