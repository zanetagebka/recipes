# Not perfect solution
# Currently it returns recipes with all matching ingredients and on top displays most rated
# CONS: It will be better if it will take ANY ingredients from an array and on top returns most matching by number of ingredients from user search
# at top and then goes to less matching at bottom
# I am lost
# Of course changing DB structure may help, but with current one I still have issue with array column matching
# The problem is that you are not able to use ILIKE/LIKE with counting matching elements in array so it needs to be written different way

class RecipeWithMatchQuery
  attr_accessor :initial_scope

  def initialize(initial_scope)
    @initial_scope = initial_scope
  end

  def call(params)
    scoped = search(initial_scope, params[:search])
    scoped = sort_by_rate(scoped)
    scoped = paginate(scoped, params[:page])
    scoped
  end

  private

  def search(scoped, query = nil)
    query = prepare_query(query)

    query ? scoped.where("array_to_string(ingredients, '') ILIKE ALL (array[?])", query) : scoped
  end

  def sort_by_rate(scoped)
    scoped.order(rate: :desc)
  end

  def sort_by_matching_ingredients(scoped)
  end

  def paginate(scoped, param)
    scoped.paginate(page: param, per_page: 8)
  end

  def prepare_query(query)
    query.downcase.split(',').map(&:strip).map { |val| "%#{val}%" }
  end

end
