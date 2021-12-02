class Appointment < ApplicationRecord
  belongs_to :professional

  validates :date, presence: true, uniqueness: { scope: :professional, message: 'existe otro turno para esa fecha y profesional' }
  validates :name, presence: true
  validates :surname, presence: true
  validates :phone, presence: true

  validates :name, :surname, format: { with: /\A[a-zA-Z ]+\z/, message: 'solo se permiten letras' }
  validates :phone, numericality: { message: 'solo se permiten números' }

  validate :appointment_date_cannot_be_in_the_past
  validate :appointment_date

  scope :filter_by_date, -> (date_f) { where("date(date) = ?", date_f) }

  def appointment_date_cannot_be_in_the_past
    errors.add(:date, 'no puede ser en el pasado') if date < DateTime.now
  end

  def appointment_date
    horarios = [0, 20, 40]
    errors.add(:date, 'los turnos se dan en un espacio de 20 minutos (00, 20 y 40)') unless horarios.include?(date.min)
  end

end
