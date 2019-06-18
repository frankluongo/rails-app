# Full list of Validations: https://guides.rubyonrails.org/active_record_validations.html

class Article < ApplicationRecord
  has_many :comments, dependent: :destroy
  validates :title, presence: true,
                    length: { minimum: 5 }
end
