require 'spec_helper'
require 'rails_helper'

RSpec.describe RecipesController, type: :controller do
  render_views

  let(:ingredients) { ["600g de pâte à crêpe", "1/2 orange", "1/2 banane", "1/2 poire pochée", "1poignée de framboises", "75g de Nutella®", "1poignée de noisettes torréfiées",
                       "1/2poignée d'amandes concassées", "1cuillère à café d'orange confites en dés", "2cuillères à café de noix de coco rapée", "1/2poignée de pistache concassées",
                       "2cuillères à soupe d'amandes effilées"] }
  let(:ingredients_two) { ["2kg de cuisse de poulet (désossées)", "6 oignons", "2 pommes de terre par personnes (découper en morceaux de 2 à 3 cm)",
                           "5 citrons jaunes", "1kg de patate douce (découpée en morceau de 4 à 5 cm)", "2 cubes de bouillon de volaille", "75g de moutarde forte",
                           "70g de double concentré de tomates", "1 piment antillais (ciselé)", "1gousse d'ail (écrasée)", "6cuillères à soupe d'huile d’arachide",
                           "Poivre 5 baies", "1/2cuillère à café de muscade moulue", "2cuillères à café de citronnelle séchée ou fraîche", "2cuillères à soupe d'oignon frits"] }
  let(:ingredients_three) {  ["5 citrons jaunes"] }
  let!(:recipe) { Recipe.create(name: 'Recipe Nutella', ingredients: ingredients) }
  let!(:second_recipe) { Recipe.create(name: 'Recipe something', ingredients: ingredients_two) }
  let!(:third_recipe) { Recipe.create(name: 'Recipe citrons', ingredients: ingredients_three) }

  it 'go to index' do
    get :index
    expect(response).to be_successful
  end

  it 'get show' do
    get :show, params: { id: recipe.id }
    expect(response).to be_successful
  end

  context 'search by ingredients' do

    it 'search by one ingredient' do
      get :index, params: { search: 'Nutella' }
      expect(response).to be_successful
      expect(response.body).to include(recipe.name)
      expect(response.body).not_to include(second_recipe.name)
    end

    it 'search by multiple ingredients' do
      get :index, params: { search: 'orange, banan' }
      expect(response).to be_successful
      expect(response.body).to include(recipe.name)
      expect(response.body).not_to include(second_recipe.name)
    end

    it 'returns multiple recipes if ingredients match to many' do
      get :index, params: { search: 'citrons jaunes' }
      expect(response).to be_successful
      expect(response.body).to include(second_recipe.name)
      expect(response.body).to include(third_recipe.name)
      expect(response.body).not_to include(recipe.name)
    end
  end
end
