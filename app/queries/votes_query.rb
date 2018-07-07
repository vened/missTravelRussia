class VotesQuery

  def initialize(relation = User.where(_role: 'contestant'))
    @relation = relation.where(photos: {'$elemMatch': {root: true}})
  end

  def call(params = {})
    # filter_role_user
    # filter_photo_exist
    sort_by_votes(params)
    sort_by_date(params)
    @relation
  end

  # def filter_role_user
  #   @relation = @relation.where(_role: 'user', is_vote: true)
  # end

  # def filter_photo_exist
  #   @relation = @relation.where(photos: {'$elemMatch': {root: true}})
  # end

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
      @relation.to_a[user_index_votes+1]
    else
      nil
    end
  end

  def prev_anketa(user, params)
    call(params)
    user_index_votes = @relation.to_a.index(user)
    if user_index_votes
      @relation.to_a[user_index_votes-1]
    else
      nil
    end
  end

  def anketa_position(user)
    @relation = @relation.where(votes: {'$gt': user.votes})
    # filter_role_user
    # filter_photo_exist
    @relation.length + 1
  end

  # сортировка по голосам
  def sort_by_votes(params)
    @relation = @relation.order_by(is_disqualify: 1)
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

  def votes_count
    @relation = @relation.where(_role: 'user', is_vote: true)
    @relation.sum(:votes)
    # @relation.collection.aggregate(
    #     [
    #         # разворачиваем массив товаров, в каждом товаре содержится одно свойство
    #         { '$unwind' => '$user_voteables' },
    #         {
    #             '$project' => {
    #                 'user_voteable_id'  => '$user_voteables.user_voteable_id',
    #             }
    #         },
    #     ]
    # ).to_a
  end

end
