# frozen_string_literal: true

class RecipeService

  def initialize; end

  # @return [Hash]
  def ensure_data
    read_json_file
  end

  # @return [Array] of keys from @@jsonfile
  def object_keys
    ensure_data.map(&:keys).flatten.uniq
  end

  private

  def read_json_file
    return @@jsonfile if defined?(@@jsonfile)

    file = File.read('files/recipes.json')
    @@jsonfile = JSON.parse(file)
  end
end
