class Professional < ApplicationRecord
  has_many :appointments, dependent: :restrict_with_error

  validates :name, presence: { message: 'es obligatorio' }, uniqueness: true
end
