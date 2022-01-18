class UsersController < ApplicationController
  before_action :authenticate_user!
  layout 'application'

  # GET /users or /users.json
  def index
    partner_ids = MysteryPair.where(user: current_user).pluck(:partner_id)
    @partners = Users.where(id: partner_ids)
  end

  # GET /users/1 or /users/1.json
  def show; end

  # GET /users/1/edit
  def edit; end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if current_user.update(user_params)
        format.html { redirect_to user_url(current_user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: current_user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: current_user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def user_params
    params.fetch(:user, {})
  end
end
