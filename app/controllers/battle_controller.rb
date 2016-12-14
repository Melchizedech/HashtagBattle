class BattleController < ApplicationController
  include ApplicationHelper

  before_action :require_login
  def new
    @battle = Battle.new params[:battle]
    @battle.user = current_user

    2.times do @battle.hashtags << Hashtag.new end if @battle.hashtags.empty?
  end

  def create
    @battle ||= Battle.new
    @battle.user = current_user
    params[:battle][:hashtags_attributes].each do |i, hashtag|
      @battle.hashtags << Hashtag.find_or_create_by(name: hashtag[:name])
    end
    @battle.save
    if @battle.valid?
      redirect_to battle_path(@battle)
    else
      redirect_to battle_create_path(@battle)
    end
  end

  def show
    @battle = Battle.find_by_user_id_and_id!(current_user.id, params[:id])
    @battle.update_hashtags
  end

  def index
    @battles = current_user.battles
    @battles.each { |b| b.update_hashtags }
  end

  private

  def battle_params
    params.require(:battle).permit(hashtags_attributes: [:name])
  end

end
