class Story < ActiveRecord::Base
  
  has_many :ratings
  has_many :inputs

  def content
    inputs.order(:created_at)
  end

  def self.oldest_incomplete_story(id)
    self.order(:updated_at).limit(1).where('stories.id NOT IN (SELECT stories.id FROM stories JOIN inputs ON stories.id = inputs.story_id WHERE inputs.user_id = ?)', id).where(complete: false)[0]
  end

  def complete?
    if inputs.count >= 12 
     self.complete = true 
    end
    save
    # errors.add(:complete, "Sorry, this game has ended. Go home and try again, please.")
  end

  def average_rating
    ratings.average(:score).to_f.round(1)
  end

end