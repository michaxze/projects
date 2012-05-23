class Highlight < ActiveRecord::Base
  belongs_to :highlightable, :polymorphic => true
  has_one :highlight_category
  belongs_to :highlight_category
end
