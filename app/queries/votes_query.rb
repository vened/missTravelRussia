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

  def next_anketa(user)
    call
    @relation.to_a[@relation.to_a.index(user)+1]
    # filter_role_user
    # filter_photo_exist
    # sort_by_votes
    # @relation = @relation.order_by(number: 1)
    # @relation = @relation.where(votes: { '$lte': user.votes }).not.in(number: [ user.number ])
    # @relation.first
  end

  def prev_anketa(user)
    call
    @relation.to_a[@relation.to_a.index(user)-1]
    # sort_by_votes
    # @relation = @relation.order_by(number: -1)
    # @relation = @relation.where(number: { '$lt': user.number })
    # filter_role_user
    # filter_photo_exist
    # @relation.first
  end

  def anketa_position(user)
    @relation = @relation.where(votes: { '$gt': user.votes })
    filter_role_user
    filter_photo_exist
    @relation.length + 1
  end

  # сортировка по голосам
  def sort_by_votes()
    @relation = @relation.order_by(votes: -1)
  end

end
