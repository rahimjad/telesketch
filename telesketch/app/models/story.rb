class Story < ActiveRecord::Base
  
  has_many :ratings
  has_many :inputs

  def content
    inputs.order(:created_at)
  end

  def self.oldest_incomplete_story
    self.limit(1).where(complete: false).order(:created_at)[0]
  end

  def complete?
    if inputs.count >= 12 
     self.complete = true 
    end
    save
    # errors.add(:complete, "Sorry, this game has ended. Go home and try again, please.")
  end

end