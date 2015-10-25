class Rating < ActiveRecord::Base

  belongs_to :user
  belongs_to :story

<<<<<<< HEAD
  validates :user_id, :story_id, presence: true
=======
  validates :user_id, uniqueness: {scope: :story_id}

>>>>>>> d84be21ad65ca3336bbe327c2f6995dfe44f9a21
end 