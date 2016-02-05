class Tagging < ActiveRecord::Base
  validates :membership_id, uniqueness: {scope: :tag_id} # prevent duplicate taggings
  belongs_to :membership, touch: true
  belongs_to :tag

  def name
    self.tag.name
  end
end
