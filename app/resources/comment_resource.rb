class CommentResource < ApplicationResource
  attribute :body, :string

  filter :post_id, :integer

  polymorphic_belongs_to :commentable do
    group_by :commentable_type do
      on(:User).belongs_to :user
    end
  end
end
