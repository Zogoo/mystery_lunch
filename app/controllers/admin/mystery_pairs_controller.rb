class Admin::MysteryPairsController < Admin::BaseController
  layout 'admin'

  def index
    page = params[:page] || 1
    @mystery_pairs = MysteryPair.order(:lunch_date).page(page)
  end

  def show
    @mystery_pair = MysteryPair.find(pair_parameter)
  end

  private

  def pair_parameter
    params.require(:id)
  end
end
