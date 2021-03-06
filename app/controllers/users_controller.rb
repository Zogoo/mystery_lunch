class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show]
  before_action :find_partners
  layout 'application'

  # GET /users or /users.json
  def index; end

  # GET /users/1 or /users/1.json
  def show; end

  # GET /users/1/edit
  def edit; end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if self_update? && current_user.update(user_params)
        format.html { redirect_to user_url(current_user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: current_user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def find_partners
    # Show previous partners
    @partner_ids = MysteryPair.by_user(current_user)
                              .before_at(Date.today)
                              .where.not(partner_id: current_user.id)
                              .order(:lunch_date).pluck(:partner_id)
    @partners = User.where(id: @partner_ids)
    @next_partner_ids = MysteryPair.by_user(current_user)
                                   .after_at(Date.today)
                                   .where.not(partner_id: current_user.id)
                                   .order(:lunch_date).pluck(:partner_id)
    @next_partners = User.where(id: @next_partner_ids)
    @limit_show = params[:more].present? ? @partners.size : 10
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(
      :photo,
      :username,
      :first_name,
      :last_name,
      :email
    )
  end

  def self_update?
    params[:id] == current_user.id.to_s
  end
end
