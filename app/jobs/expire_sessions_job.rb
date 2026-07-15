class ExpireSessionsJob < ApplicationJob
  queue_as :default

  def perform
    GameSession.where(status: :active)
           .where("ends_at <= ?", Time.current)
           .find_each do |session|
      session.update(status: :expired)
      broadcast_session_update(session)
    end
  end

  private

  def broadcast_session_update(session)
    # Broadcast para o painel do recepcionista
    Turbo::StreamsChannel.broadcast_replace_to(
      "sessions",
      target: "session_#{session.id}",
      partial: "sessions/session",
      locals: { session: session }
    )

    # Broadcast para a tela da TV
    Turbo::StreamsChannel.broadcast_replace_to(
      "tv_sessions",
      target: "tv_session_#{session.id}",
      partial: "tv/session_card",
      locals: { session: session }
    )
  end
end
