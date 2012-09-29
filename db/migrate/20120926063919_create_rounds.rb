class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.string :player1attack
      t.string :player2attack

      t.timestamps
    end
  end
end
