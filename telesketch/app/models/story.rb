class Story < ActiveRecord::Base
  
  has_many :ratings
  has_many :inputs

  validate :complete?

  def content
    (inputs).sort_by(&:created_at)
  end

  private

  def complete?
    if inputs.count >= 12
      @complete = true
      errors.add(:complete, "Sorry, this game has ended. Go home and try again, please.")
    end
  end

end