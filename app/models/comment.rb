class Comment < ApplicationRecord
  belongs_to :post

  attr_accessor :commentable
end
