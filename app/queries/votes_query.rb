class VotesQuery

  def initialize(relation = User.all)
    @relation = relation
  end

  def call
    filter_role_user
    filter_photo_exist
    sort_by_votes
    @relation
  end

  def filter_role_user
    @relation = @relation.where(_role: 'user', is_vote: true)
  end

  def filter_photo_exist
    @relation = @relation.where(photos: {'$elemMatch': {root: true}})
  end

  def is_votes(current_user, voteable_user_id)
    if current_user.user_voteables.where(user_voteable_id: "#{voteable_user_id}").exists?
      return false
    end
    return true
  end

  # сортировка по цене
  def sort_by_votes()
    @relation = @relation.order_by(votes: -1)
  end

end
