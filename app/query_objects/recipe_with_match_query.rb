class RecipeWithMatchQuery

  RATE = 5

  attr_accessor :initial_scope

  def initialize(initial_scope)
    @initial_scope = initial_scope
  end

  def call(params)
    scoped = search(initial_scope, params[:search])
    scoped = sort_by_rate(scoped) # sort by rate only => add it as checkbox param
    # scoped = sort_by_matching_ingredients(scoped) # add it as checkbox param
    # add search by number of matching ingredients
    scoped = paginate(scoped, params[:page])
    scoped
  end

  private

  def search(scoped, query = nil)
    query = prepare_query(query)

    query ? scoped.where("array_to_string(ingredients, '') ILIKE ANY (array[?])", query) : scoped
  end

  def sort_by_rate(scoped)
    scoped.order(rate: :desc)
  end

  def sort_by_matching_ingredients(scoped, sort_type = :desc)
    scoped.where('ingredients IN (?) group by id order by count(distinct ingredients) desc')
  end

  def paginate(scoped, param)
    scoped.paginate(page: param, per_page: 8)
  end

  def prepare_query(query)
    query.downcase.split(',').map(&:strip).map { |val| "%#{val}%" }
  end

end
