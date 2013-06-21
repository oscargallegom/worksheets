class FieldTypeBmpType < ActiveRecord::Base
  belongs_to :field_type
  belongs_to :bmp_type
end
