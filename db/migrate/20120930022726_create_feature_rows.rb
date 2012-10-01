class CreateFeatureRows < ActiveRecord::Migration
  def change
    create_table :feature_rows do |t|
      t.string :one_attack_ago
      t.string :two_attacks_ago
      t.string :three_attacks_ago
      t.integer :user_id
      t.integer :round_id

      t.timestamps
    end
  end
end
