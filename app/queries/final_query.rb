class SemifinalQuery

  def initialize(relation = nil)
    @relation = User.where(_role: 'contestant')
  end

  def call(params = {})
    get_by_is_polufinal
    sort_by_votes
    @relation
  end

  def get_by_is_polufinal
    @relation = @relation.where(is_polufinal: true).limit(29)
  end

  # сортировка по голосам
  def sort_by_votes
    @relation = @relation.order_by(votes: -1)
  end

end
