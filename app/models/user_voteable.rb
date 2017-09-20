class UserVoteable
  include Mongoid::Document
  field :user_voteable_id, type: BSON::ObjectId
  embedded_in :user, touch: true
end