class HistoricoController < ApplicationController
  def index
    @sessions = GameSession.finished_only.order(ended_at: :desc)

    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date]).beginning_of_day
      end_date = Date.parse(params[:end_date]).end_of_day
      @sessions = @sessions.where(ended_at: start_date..end_date)
    end

    @sessions = @sessions.page(params[:page]).per(20) if defined?(Kaminari)
  end
end
