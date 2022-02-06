class Admin::MysteryPairsController < Admin::BaseController
  def index
    @mystery_pairs = MysteryPair.all
  end

  def show
    @mystery_pair = MysteryPair.find(pair_parameter)
  end

  private

  def pair_parameter
    parameter.require(:pair_id)
  end
end
