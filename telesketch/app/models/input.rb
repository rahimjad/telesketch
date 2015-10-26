class Input < ActiveRecord::Base

  belongs_to :user
  belongs_to :story

  validates :type, presence: true
  validates :user_id, uniqueness: {scope: :story_id}
  validates :story_id, :user_id, presence: true
end 