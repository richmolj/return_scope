FactoryBot.define do
  factory :comment do
    post_id { 1 }
    commentable_id { 1 }
    commentable_type { "MyString" }
    body { "MyText" }
  end
end
