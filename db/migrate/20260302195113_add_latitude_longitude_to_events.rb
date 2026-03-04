class AddLatitudeLongitudeToEvents < ActiveRecord::Migration[8.1]
  def change
    unless column_exists?(:events, :latitude)
      add_column :events, :latitude, :decimal, precision: 10, scale: 8
    end

    unless column_exists?(:events, :longitude)
      add_column :events, :longitude, :decimal, precision: 11, scale: 8
    end
  end
end
