class AddNameToUsers < ActiveRecord::Migration
  def up
    # add new column
    add_column :users, :name, :string

    # before we set the null: false constraint, populate null columns with first part of email
    User.find_each do |user|
      if user.name.nil?
        puts "\nUser Data Changes:"
        puts "==================="
        user.name = /^(.+)@.+?$/.match(user.email)[1]
        puts "#{user.email} (ID #{user.id}) was named #{user.name}"
        user.save!
      end
    end

    # set column constraint: no null values
    change_column_null :users, :name, false
  end

  def down
    remove_column :users, :name, :string
  end
end
