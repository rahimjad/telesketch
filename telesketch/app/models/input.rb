class Input < ActiveRecord::Base

  belongs_to :user
  belongs_to :story

  validates :type, presence: true

end 