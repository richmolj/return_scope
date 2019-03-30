require 'rails_helper'

RSpec.describe "posts#update", type: :request do
  subject(:make_request) do
    jsonapi_put "/api/v1/posts/#{post.id}?include=comments,comments.commentable", payload
  end

  describe 'issue120' do
    include_context 'remote api'
    let!(:post) { create(:post) }

    let(:api_response) do
      {
        data: [{
          id: '456',
          type: 'users',
          attributes: { name: 'Jane Doe' }
        }]
      }
    end

    let(:payload) do
      {
        data: {
          id: post.id.to_s,
          type: 'posts',
          attributes: { title: 'test' },
          relationships: {
            comments: {
              data: [
                { :'temp-id' => 'abc123', type: 'comments', method: 'create' }
              ]
            }
          }
        },
        included: [{
          type: 'comments',
          :'temp-id' => 'abc123',
          attributes: { body: 'new comment' },
          relationships: {
            commentable: {
              data: { id: '456', type: 'users' }
            }
          }
        }]
      }
    end

    it 'works' do
      mock_api('http://localhost:3001/api/v1/users?filter[id]=456', api_response, 2)
      make_request
      comment_sl = d.sideload(:comments)
      commentable_sl = comment_sl[0].sideload(:commentable)
      expect(commentable_sl.id).to eq(456)
      expect(commentable_sl.name).to eq('Jane Doe')
      expect(commentable_sl.jsonapi_type).to eq('users')
    end
  end
end
