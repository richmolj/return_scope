class UserResource < ApplicationResource
  self.remote = 'http://localhost:3001/api/v1/users'
end
