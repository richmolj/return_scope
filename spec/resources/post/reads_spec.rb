require 'rails_helper'

RSpec.describe PostResource, type: :resource do
  describe 'serialization' do
    let!(:post) { create(:post) }

    it 'works' do
      render
      data = jsonapi_data[0]
      expect(data.id).to eq(post.id)
      expect(data.jsonapi_type).to eq('posts')
    end
  end

  describe 'filtering' do
    let!(:post1) { create(:post) }
    let!(:post2) { create(:post) }

    context 'by id' do
      before do
        params[:filter] = { id: { eq: post2.id } }
      end

      it 'works' do
        render
        expect(d.map(&:id)).to eq([post2.id])
      end
    end
  end

  describe 'sorting' do
    describe 'by id' do
      let!(:post1) { create(:post) }
      let!(:post2) { create(:post) }

      context 'when ascending' do
        before do
          params[:sort] = 'id'
        end

        it 'works' do
          render
          expect(d.map(&:id)).to eq([
            post1.id,
            post2.id
          ])
        end
      end

      context 'when descending' do
        before do
          params[:sort] = '-id'
        end

        it 'works' do
          render
          expect(d.map(&:id)).to eq([
            post2.id,
            post1.id
          ])
        end
      end
    end
  end

  describe 'sideloading' do
    describe 'comments > commentable' do
      include_context 'remote api'

      let!(:post) { create(:post) }
      let!(:comment) do
        create :comment,
          post: post,
          commentable_id: 123,
          commentable_type: 'User'
      end

      let(:api_response) do
        {
          data: [{
            id: '123',
            type: 'users',
            attributes: { name: 'Jane Doe' }
          }]
        }
      end

      before do
        params[:include] = 'comments,comments.commentable'
      end

      it 'works' do
        mock_api('http://localhost:3001/api/v1/users?filter[id]=123', api_response)
        render
      end
    end
  end
end
