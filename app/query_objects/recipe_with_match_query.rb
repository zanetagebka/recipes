# Query match user input with recipe ingredients and returns
# most matching at top (by number of matching ingredients).
# Second match is by rate, but with prioritizing user search.

class RecipeWithMatchQuery
  attr_accessor :initial_scope

  def initialize(initial_scope)
    @initial_scope = initial_scope
  end

  def call(params)
    scoped = search(initial_scope, params[:search])
    scoped = sort_by_matching_ingredients(scoped, params[:search])
    scoped = sort_by_rate(scoped)
    paginate(scoped, params[:page])
  end

  private

  def search(scoped, query = nil)
    query = prepare_query(query)

    query ? scoped.where("array_to_string(ingredients, '') ILIKE ANY (array[?])", query) : scoped
  end

  def sort_by_matching_ingredients(scoped, query)
    conditions = prepare_order_conditions(query)

    scoped.order(Arel.sql("(CONCAT(#{conditions})) DESC"))
  end

  def sort_by_rate(scoped)
    scoped.order(rate: :desc)
  end

  def paginate(scoped, param)
    scoped.paginate(page: param, per_page: 8)
  end

  def prepare_query(query)
    query.downcase.split(',').map(&:strip).map { |val| "%#{val}%" }
  end

  def prepare_order_conditions(query)
    query = prepare_query(query)

    query.map { |term| "(array_to_string(ingredients, '') ILIKE #{"'#{term}'"})" }.join(', ')
  end

end
