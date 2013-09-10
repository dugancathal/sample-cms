class Content
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning

  field :title, type: String
  field :type, type: String
  field :medium, type: String
  field :body, type: String

  max_versions 5
end
