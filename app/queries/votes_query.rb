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
    @relation = @relation.where(_role: 'user', is_vote: true)
  end

  def filter_photo_exist
    @relation = @relation.where(photos: {'$elemMatch': {root: true}})
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
