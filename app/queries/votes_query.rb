class VotesQuery

  def initialize(relation = User.all)
    @relation = relation
  end

  def call(params = {})
    filter_role_user
    filter_photo_exist
    sort_by_votes(params)
    sort_by_date(params)
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

  def next_anketa(user, params)
    call(params)
    user_index_votes = @relation.to_a.index(user)
    if user_index_votes
      @relation.to_a[@relation.to_a.index(user)+1]
    else
      nil
    end
  end

  def prev_anketa(user, params)
    call(params)
    user_index_votes = @relation.to_a.index(user)
    if user_index_votes
      @relation.to_a[@relation.to_a.index(user)-1]
    else
      nil
    end
  end

  def anketa_position(user)
    @relation = @relation.where(votes: {'$gt': user.votes})
    filter_role_user
    filter_photo_exist
    @relation.length + 1
  end

  # сортировка по голосам
  def sort_by_votes(params)
    unless params[:votes]
      unless params[:create_date]
        @relation = @relation.order_by(votes: -1)
      end
    end
    if params[:votes] == "1"
      @relation = @relation.order_by(votes: 1)
      @relation = @relation.order_by(created_at: -1)
    end
    if params[:votes] == "-1"
      @relation = @relation.order_by(votes: -1)
    end
  end

  # сортировка по дате подачи анкеты
  def sort_by_date(params)
    if params[:create_date] == "1"
      @relation = @relation.order_by(created_at: 1)
    end
    if params[:create_date] == "-1"
      @relation = @relation.order_by(created_at: -1)
    end
    @relation
  end

end
