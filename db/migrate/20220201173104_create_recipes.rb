class CreateRecipes < ActiveRecord::Migration[6.1]

  def change
    create_table :recipes

    columns.each do |column|
      if %w[ingredients tags].include?(column)
        add_column :recipes, :"#{column}", :text, array: true, default: []
      else
        add_column :recipes, :"#{column}", :string
      end
    end
    add_column :recipes, :created_at, :timestamp
    add_column :recipes, :updated_at, :timestamp
  end

  private

  def columns
    RecipeService.new.object_keys
  end

end
