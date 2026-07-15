class GameSession < ApplicationRecord
  # Enums
  enum :session_type, { sala_jogos: 0, playstation4: 1, sinuca: 2 }
  enum :status, { active: 0, expired: 1, finished: 2 }

  SESSION_TYPE_LABELS = {
    "sala_jogos" => "Sala de Jogos",
    "playstation4" => "Playstation 4",
    "sinuca" => "Sinuca"
  }.freeze

  SESSION_TYPE_BADGE_CLASSES = {
    "sala_jogos" => "bg-blue-100 text-blue-800",
    "playstation4" => "bg-purple-100 text-purple-800",
    "sinuca" => "bg-green-100 text-green-800"
  }.freeze

  SESSION_TYPE_PRICES = {
    "sala_jogos" => 5.00,
    "playstation4" => 7.00,
    "sinuca" => 3.00
  }.freeze

  # Validations
  validates :client_name, presence: true
  validates :session_type, presence: true

  # Callbacks
  before_create :set_initial_values

  # Scopes
  scope :active_or_expired, -> { where(status: [:active, :expired]) }
  scope :finished_only, -> { where(status: :finished) }

  # Methods
  def time_remaining
    return 0 if ends_at.nil? || ends_at < Time.current
    (ends_at - Time.current).to_i
  end

  def time_remaining_formatted
    seconds = time_remaining
    return "00:00" if seconds <= 0

    hours = seconds / 3600
    minutes = (seconds % 3600) / 60
    secs = seconds % 60

    if hours > 0
      format("%02d:%02d:%02d", hours, minutes, secs)
    else
      format("%02d:%02d", minutes, secs)
    end
  end

  def session_type_label
    SESSION_TYPE_LABELS[session_type]
  end

  def session_type_badge_class
    SESSION_TYPE_BADGE_CLASSES[session_type]
  end

  def renew!(minutes: 60)
    update!(
      ends_at: ends_at + minutes.minutes,
      renewals_count: renewals_count + 1
    )
  end

  def finish!
    update!(
      ended_at: Time.current,
      status: :finished
    )
  end

  private

  def set_initial_values
    self.started_at ||= Time.current
    self.amount_paid ||= SESSION_TYPE_PRICES[session_type]

    if sinuca?
      self.ended_at ||= started_at
      self.status ||= :finished
    else
      self.ends_at ||= started_at + 1.hour
      self.status ||= :active
    end
  end
end
