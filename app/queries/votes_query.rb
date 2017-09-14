class VotesQuery

  def initialize(relation = User.all)
    @relation = relation
  end

  def call
    filter_role_user
    filter_photo_exist
    @relation
  end

  def filter_role_user
    @relation = @relation.where(_role: 'user')
  end

  def filter_photo_exist
    @relation = @relation.where(photos: {'$elemMatch': {root: true}})
  end

  def is_votes(current_user, voteable_user_id)
    if current_user.user_voteables.where(user_voteable_id: voteable_user_id).exists?
      return false
    end
    return true
  end

  # сортировка по цене
  def sort_by_price(params)
    sort_by_price = params[:sort_by_price].to_i

    if sort_by_price != 0
      @relation = @relation.order_by(pricing_sale_price: sort_by_price)
    else
      @relation = @relation.order_by(pricing_sale_price: 1)
    end
  end

end
