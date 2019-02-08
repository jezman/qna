class Search < ApplicationRecord
  SEARCH_OBJECTS = %w[Question Answer User Comment].freeze

  def self.find(query, search_object = nil)
    search_object&.capitalize!

    object = search_object.in?(SEARCH_OBJECTS) ? search_object.constantize : ThinkingSphinx
    object.search(query)
  end
end
