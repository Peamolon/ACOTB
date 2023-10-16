class ChangeInstitutionNameLimit < ActiveRecord::Migration[6.0]
  def change
    def change
      change_column :institutions, :name, :string, limit: 200
    end
  end
end
