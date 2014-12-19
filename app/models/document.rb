class Document < ActiveRecord::Base
  include Documentable

  has_many :pictures
end
