class TvController < ApplicationController
  def index
    @sessions = GameSession.active_or_expired.order(started_at: :desc)
  end
end
