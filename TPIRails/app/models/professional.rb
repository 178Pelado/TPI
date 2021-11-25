class Professional < ApplicationRecord
  has_many :appointments, dependent: :restrict_with_error

  validates :name, presence: { message: 'es obligatorio' }, uniqueness: { message: 'ya existe un profesional con ese nombre'}
  validates :name, format: { with: /\A[a-zA-Z ]+\z/, message: 'solo se permiten letras' }
end
