# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects, force: true do |t|
      t.string :name
      t.string :github
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
