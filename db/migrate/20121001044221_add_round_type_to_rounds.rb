class AddRoundTypeToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :round_type, :string
  end
end
