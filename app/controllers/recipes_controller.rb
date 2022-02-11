class RecipesController < ApplicationController
  
  def index
    @recipes = search_ingredients
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  private

  def search_ingredients
    if params[:search].blank?
      @recipes = Recipe.paginate(page: params[:page], per_page: 8)
    else
      @recipes = RecipeWithMatchQuery.new(Recipe.all).call(recipe_params)
    end
  end

  private

  def recipe_params
    params.permit(:search, :page)
  end

end
