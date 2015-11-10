module RailsTranslator
  class Translation
    include Mongoid::Document
    field :key
    field :values, type: Hash, default: {}
  end
end
