class VoteableService
  def call(current_user, voteable_user_id)
    voteable(current_user, voteable_user_id)
  end

  def voteable(current_user, voteable_user_id)
    user = User.find_by(number: voteable_user_id)
    unless current_user.user_voteables.where(user_voteable_id: voteable_user_id).exists?
      current_user.user_voteables.create(
          user_voteable_id: voteable_user_id
      )
      # user.inc(votes: 1)
      # заменил на update, для обновления updated_at
      user.update(votes: user.votes + 1)
    end
    return user
  end

end