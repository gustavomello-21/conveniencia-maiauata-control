class TvController < ApplicationController
  skip_before_action :require_login

  def index
    @sessions = GameSession.active_or_expired.order(started_at: :desc)
  end
end
