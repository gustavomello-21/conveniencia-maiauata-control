class SessionsController < ApplicationController
  def index
    @sessions = GameSession.active_or_expired.order(started_at: :desc)
  end

  def create
    @session = GameSession.new(session_params)

    if @session.save
      broadcast_session_update(@session) unless @session.sinuca?

      notice = @session.sinuca? ? "Sinuca registrada para #{@session.client_name}" : "Sessão iniciada para #{@session.client_name}"
      redirect_to root_path, notice: notice
    else
      @sessions = GameSession.active_or_expired.order(started_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def renew
    @session = GameSession.find(params[:id])
    minutes = params[:minutes].presence&.to_i || 60
    @session.renew!(minutes: minutes)
    broadcast_session_update(@session)
    redirect_to root_path, notice: "Sessão renovada em #{minutes} min para #{@session.client_name}"
  end

  def finish
    @session = GameSession.find(params[:id])
    @session.finish!
    broadcast_session_removal(@session)
    redirect_to root_path, notice: "Sessão encerrada para #{@session.client_name}"
  end

  private

  def session_params
    params.require(:game_session).permit(:client_name, :session_type)
  end

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

  def broadcast_session_removal(session)
    # Remove da lista do painel
    Turbo::StreamsChannel.broadcast_remove_to(
      "sessions",
      target: "session_#{session.id}"
    )

    # Remove da tela da TV
    Turbo::StreamsChannel.broadcast_remove_to(
      "tv_sessions",
      target: "tv_session_#{session.id}"
    )
  end
end
