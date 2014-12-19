module Picturable
    extend ActiveSupport::Concern

    included do
      has_many :pictures, as: :pictureable
    end

end
