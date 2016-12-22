class BattleController < ApplicationController
  include ApplicationHelper

  before_action :require_login, only: [:new, :create, :user_battles]

  # Instantiate new Battle with - by default - 2 hashtags
  def new
    @battle      = Battle.new 
    @battle.user = current_user

    2.times { @battle.hashtags.build }
  end

  # Create Battle with unique Hashtags
  def create
    @battle        = Battle.new
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

  # Gets a Battle
  def show
    @battle  = Battle.find(params[:id])
    @user = current_user
  end

  # Show all Battles (Visitor view)
  def index
    @battles = Battle.all
    @user = current_user
  end

  # Battles of a user (Logged user)
  def user_battles
    @battles = current_user.battles
  end

  # Pie Chart data of the Battle
  def pie_chart_data
    battle = Battle.find(params[:battle_id])
    
    render json: battle.hashtags.map { |h| [h.name, h.get_count_between(before: battle.created_at)] }
  end

  # Stacked Line Chart data of the Battle
  def stacked_line_chart_data
    battle = Battle.find(params[:battle_id])
    data   = []

    battle.hashtags.each do |h|
      data << h.get_stacked_evolution_data(from: battle.created_at)
    end

    render json: data
  end

end
