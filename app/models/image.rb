class Image < Input

#validations for just images

  validates :image_path, presence: true
end 