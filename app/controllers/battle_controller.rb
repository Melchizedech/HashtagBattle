class BattleController < ApplicationController
  include ApplicationHelper

  before_action :require_login

  def new
    @battle      = Battle.new 
    @battle.user = current_user

    2.times { @battle.hashtags.build }
  end

  def create
    @battle      ||= Battle.new
    @battle.user   = current_user

    params[:battle][:hashtags_attributes].each do |i, hashtag|
      next if hashtag[:name].blank?
      @battle.hashtags << Hashtag.find_or_create_by(name: hashtag[:name])
    end
    if @battle.save
      redirect_to @battle
    else
      render new_battle_path(@battle), alert: @battle.errors
    end
  end

  def show
    @battle  = current_user.battles.find(params[:id])
    @results = {}

    @battle.hashtags.each do |h| 
      count            = h.get_count_between(before: @battle.created_at) 
      @results[h.name] = {count: count, id: h.id }
    end
  end

  def index
    @battles = current_user.battles
  end

  def pie_chart_data
    battle = current_user.battles.find(params[:battle_id])
    
    render json: battle.hashtags.map { |h| [h.name, h.get_count_between(before: battle.created_at)] }
  end

  def stacked_line_chart_data
    battle = current_user.battles.find(params[:battle_id])
    data   = []

    battle.hashtags.each do |h|
      data << h.get_stacked_evolution_data(from: battle.created_at)
    end

    render json: data
  end


  private

  def battle_params
    params.require(:battle).permit(hashtags_attributes: [:name])
  end

end
